import os
configfile: "config.yaml"

# functional annotation of mags with prokka
rule mag_annotation:
    input:
        os.path.join(config["general"]["data"], "bins/dereplicated_{sample}/dereplicated_genomes/bin_{bin_nr}.fasta")   
    output:
        directory(os.path.join(config["general"]["output_dir"], "mag_annotation_{sample}_{bin_nr}"))
    conda:
        "envs/config_prokka.yaml"
    threads: 12
    shell:
        "prokka --kingdom Bacteria --addgenes --evalue 1e-9 --rfam --outdir {output} {input}"
