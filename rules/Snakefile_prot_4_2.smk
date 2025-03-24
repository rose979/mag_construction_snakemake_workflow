import os
configfile: "config.yaml"


# to calculate the abundance of each MAG respectively, first the MAG has to be indexed
rule abundance_bwa_index:
    input:
        os.path.join(config["general"]["data"], "bins/dereplicated_{sample}/dereplicated_genomes/bin_{bin_nr}.fasta"),# sample=[wildcards.sample], bin_nr=[i for i in ast.literal_eval(bin_dict["bin_numbers"][wildcards.sample])])
    output:
        multiext(os.path.join(config["general"]["data"], "bins/dereplicated_{sample}/dereplicated_genomes/bin_{bin_nr}.fasta"), ".amb", ".ann", ".bwt", ".pac", ".sa")
    conda: 
        "envs/config_bwa.yaml"
    threads: 12
    shell:
        "bwa index {input}"


# bwa mem aligns the initial read files to the produced MAG and calculates its abundance in the sample
rule abundance_bwa_mem:
    input:
        bins = os.path.join(config["general"]["data"], "bins/dereplicated_{sample}/dereplicated_genomes/bin_{bin_nr}.fasta"),
        fwd_reads = os.path.join(config["general"]["data"], "clean_reads/{sample}_1.fastq"),
        rev_reads = os.path.join(config["general"]["data"], "clean_reads/{sample}_2.fastq"),
        indices = multiext(os.path.join(config["general"]["data"], "bins/dereplicated_{sample}/dereplicated_genomes/bin_{bin_nr}.fasta"), ".amb", ".ann", ".bwt", ".pac", ".sa")        
    output:
        os.path.join(config["general"]["data"], "Samtools_{sample}/bin_{bin_nr}.sam")
    conda:
        "envs/config_bwa.yaml"
    threads: 12
    shell:
        "bwa mem {input.bins} {input.fwd_reads} {input.rev_reads} > {output}"


# creating bam files out of the sam files
rule abundance_samtools_view:
    input:
        os.path.join(config["general"]["data"], "Samtools_{sample}/bin_{bin_nr}.sam")
    output:
        os.path.join(config["general"]["data"], "Samtools_{sample}/bin_{bin_nr}.bam")
    conda:
        "envs/config_samtools.yaml"
    threads: 12
    shell:
        "samtools view -b {input} > {output} --threads {threads}"

# create sorted bam files out of the sam files
rule abundance_samtools_sort:
    input:
        os.path.join(config["general"]["data"], "Samtools_{sample}/bin_{bin_nr}.sam")
    output:
        os.path.join(config["general"]["data"], "Samtools_{sample}/bin_{bin_nr}.sorted.bam")
    conda:
        "envs/config_samtools.yaml"
    threads: 12
    shell:
        "samtools sort -o {output} {input} --threads {threads}"

# doesnt work in a snakemake workflow because it produces no output files
#rule samtools_flagstat:
    #input:
        #os.path.join(config["general"]["data"], "Samtools_{sample}/bin_{bin_nr}.sorted.bam")
    #output:
        #os.path.join(config["general"]["output_dir"], "Samtools_{sample}/bin_{bin_nr}.json")
    #params:
        #output_format= "tsv"
    #conda:
        #"envs/basic_protocol_4.yaml"
    #threads: 12
    #shell:
        #"samtools flagstat -O default {input} --threads {threads}"



