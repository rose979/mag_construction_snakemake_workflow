import os
configfile: "config.yaml"


# binning with metawrap, using just the two binning algorithms maxbin2 and concoct, by default, because metabat2 ist instable
# if necessery, metabat2 can easily be enabled with params
rule binning:
    input:
        assembly_contigs_file = os.path.join(config["general"]["data"], "assembly/metaspades/assembly_{sample}/contigs.fasta"),
        fwd = os.path.join(config["general"]["data"], "clean_reads/{sample}_1.fastq"),
        rev = os.path.join(config["general"]["data"], "clean_reads/{sample}_2.fastq")
    output:
        dir = directory(os.path.join(config["general"]["data"], "bins/metaspades_{sample}_initial_binning")),
        maxbin2 = directory(os.path.join(config["general"]["data"], "bins/metaspades_{sample}_initial_binning/maxbin2_bins")),
        concoct = directory(os.path.join(config["general"]["data"], "bins/metaspades_{sample}_initial_binning/concoct_bins"))
    threads: 12
    params:
        metabat2 = "--metabat2"
    conda:
        "envs/config_metawrap.yaml"
    shell:
        "metawrap binning -o {output.dir} -t {threads} -a {input.assembly_contigs_file} --maxbin2 --concoct {input.fwd} {input.rev}"


# bin refinement with binette
rule bin_refinement:
    input:
        maxbin2 = os.path.join(config["general"]["data"], "bins/metaspades_{sample}_initial_binning/maxbin2_bins"),
        concoct = os.path.join(config["general"]["data"], "bins/metaspades_{sample}_initial_binning/concoct_bins"),
        assembly_contigs_file = os.path.join(config["general"]["data"], "assembly/metaspades/assembly_{sample}/contigs.fasta")
    output:
        directory(os.path.join(config["general"]["data"], "bins/bin_refinement_{sample}")),        
    threads: 12
    conda:
        "envs/config_binette.yaml"
    shell:
        "binette --bin_dirs {input.maxbin2} {input.concoct} --contigs {input.assembly_contigs_file} --outdir {output} --threads {threads}"




