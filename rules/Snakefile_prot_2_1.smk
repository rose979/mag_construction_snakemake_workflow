import os
configfile: "config.yaml"

# rule for indexing the reference genome, the reference genome must be downloaded manually
# bowtie2-build needs an index on which the files can be created
rule index_ref_seq:
    input:        
        os.path.join(config["general"]["data"], "host_dna_removal/human_reference_sequence.fasta")        
    output:
        expand(os.path.join(config["general"]["data"],"human_index/reference_sequence.fasta.index.{ext}"), ext=["1.bt2", "2.bt2", "3.bt2", "4.bt2", "rev.1.bt2", "rev.2.bt2"])
    conda:
        "envs/config_bowtie2.yaml"
    params:
        index = os.path.join(config["general"]["data"], "human_index/reference_sequence.fasta.index")
    threads: 12
    shell:
        "bowtie2-build --threads {threads} {input} {params.index}"

    

