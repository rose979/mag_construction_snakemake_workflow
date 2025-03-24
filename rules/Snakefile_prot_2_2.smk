import os
configfile: "config.yaml"

# filtering human reads out of the read files, bowtie2 aligns processed reads against reference sequence
rule host_dna_removal:
    input:
        index = expand(os.path.join(config["general"]["data"],"human_index/reference_sequence.fasta.index.{ext}"), ext=["1.bt2", "2.bt2", "3.bt2", "4.bt2", "rev.1.bt2", "rev.2.bt2"]),
        fwd = os.path.join(config["general"]["data"], "processed_reads/{sample}_1.fastq"),
        rev = os.path.join(config["general"]["data"], "processed_reads/{sample}_2.fastq")
    output:
        os.path.join(config["general"]["data"], "clean_reads/{sample}.1"),
        os.path.join(config["general"]["data"], "clean_reads/{sample}.2"),
    params:
        index = os.path.join(config["general"]["data"], "human_index/reference_sequence.fasta.index"),
        dir_path = os.path.join(config["general"]["data"], "clean_reads/{sample}")
    conda:
        "envs/config_bowtie2.yaml"
    threads: 12
    shell:
        "bowtie2 -x {params.index} -p {threads} -1 {input.fwd} -2 {input.rev} --un-conc {params.dir_path}"

# changing the file extension of the clean read files from host dna removal
rule change_file_ext:
    input:
        os.path.join(config["general"]["data"], "clean_reads/{sample}.{read}")
    output:
        os.path.join(config["general"]["data"], "clean_reads/{sample}_{read}.fastq")
    script:
        "scripts/change_file_ext.py"
        
# metagenomic assembly with metaspades
rule assembly:
    input:
        fwd = os.path.join(config["general"]["data"], "clean_reads/{sample}_1.fastq"),
        rev = os.path.join(config["general"]["data"], "clean_reads/{sample}_2.fastq")
    output:
        dir = directory(os.path.join(config["general"]["data"], "assembly/metaspades/assembly_{sample}")),
        fasta_file= os.path.join(config["general"]["data"], "assembly/metaspades/assembly_{sample}/contigs.fasta")
    conda:
        "envs/config_spades.yaml"
    threads: 12
    shell:
        "spades.py --meta -1 {input.fwd} -2 {input.rev} -o {output.dir} --threads {threads} --only-assembler"


# assembly statistics 
rule assembly_statistics:
    input:
        os.path.join(config["general"]["data"], "assembly/metaspades/assembly_{sample}/contigs.fasta")
    output:
        directory(os.path.join(config["general"]["output_dir"], "assembly_statistics/metaspades/metaspades_{sample}"))
    threads: 12
    shell:
        "quast/metaquast.py -o {output} --threads {threads} {input}"
        