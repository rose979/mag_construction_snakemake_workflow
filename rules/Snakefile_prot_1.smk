import os
configfile: "config.yaml"

# this is an optional step, it doesn't affect the following rule trimming in any way
# the reads are going to get trimmed based on strict trimming parameters, not on fastqc results
rule quality_check:
    input: 
        os.path.join(config["general"]["data"], "samples/{sample}_{read}.fastq")
    output:
        os.path.join(config["general"]["output_dir"], "fastqc/{sample}_{read}_fastqc.html"),
        os.path.join(config["general"]["output_dir"], "fastqc/{sample}_{read}_fastqc.zip"),
    params:
        os.path.join(config["general"]["output_dir"], "fastqc")     
    
    conda: 
        "envs/config_fastqc.yaml"
    
    shell:
        "fastqc {input} -o {params}"

# reads are going to get trimmed based on parameters specified in the params section
rule trimming:
    input:
        fwd = os.path.join(config["general"]["data"], "samples/{sample}_1.fastq"),
        rev = os.path.join(config["general"]["data"], "samples/{sample}_2.fastq")
    output:
        fwd = os.path.join(config["general"]["data"], "processed_reads/{sample}_1.fastq"),
        rev = os.path.join(config["general"]["data"], "processed_reads/{sample}_2.fastq")
    params:
        length = 36,
        qual = 30        
    conda: 
        "envs/config_fastp.yaml"
    shell:
        "fastp -i {input.fwd} -I {input.rev} -o {output.fwd} -O {output.rev} -l {params.length} -q {params.qual}"