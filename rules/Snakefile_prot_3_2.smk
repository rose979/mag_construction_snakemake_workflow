import os 
import pandas as pd
configfile: "config.yaml"
SAMPLES = config["wildcards"]["sample"]

#bin dereplication with dRep
rule bin_dereplication:
    input:
        os.path.join(config["general"]["data"], "bins/bin_refinement_{sample}")
    output:
        dir1 = directory(os.path.join(config["general"]["data"], "bins/dereplicated_{sample}")),
        dir2 = directory(os.path.join(config["general"]["data"], "bins/dereplicated_{sample}/dereplicated_genomes"))
    params:
        completeness = 0,
        contamination = 100,
        length = 50000,
        checkM_method = "taxonomy_wf",
        files = os.path.join(config["general"]["data"], "bins/bin_refinement_{sample}/final_bins/*.fasta"),
    shell:
        "dRep dereplicate {output.dir1} -d -g {params.files} -l {params.length} -comp {params.completeness} -con {params.contamination} --checkM_method {params.checkM_method}"

# creation of a datatable, which contains all newly produced bins with right bin numbers
rule create_bin_nr_datatable:
    input:
        expand(os.path.join(config["general"]["data"], "bins/dereplicated_{sample}/dereplicated_genomes"), sample=SAMPLES)
    output:
        os.path.join(config["general"]["data"], "bins/bin_datatable.csv")
    script:
        "scripts/create_bin_datatable.py"

# assign taxonomy to the produced bins with the gtdbtk database
rule gtdbtk:
    input:
        os.path.join(config["general"]["data"], "bins/dereplicated_{sample}/dereplicated_genomes")
    output:
        os.path.join(config["general"]["output_dir"], "gtdb_result_{sample}")
    conda:
        "envs/config_gtdbtk.yaml"
    params:
        ext = "fa"
    threads: 12
    shell:
        "gtdbtk classify_wf --genome_dir {input} -x {params.ext} --cpus {threads} --genes --out_dir {output}"


