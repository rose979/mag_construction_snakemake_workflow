# mag_construction_snakemake_workflow
This is a snakemake workflow for the construction of metagenome-assembled genomes, based on the protocol: "Protocol for the construction and functional profiling of metagenome-assembled genomes for microbiome analyses", by Goutam Banerjee, Suraya Rahman Papri and Pratik Banerjee. It can be found here: https://www.sciencedirect.com/science/article/pii/S2666166724003320

Requirements:
- Hardware minimum: 32 GB RAM and 1.5 TB storage
- **Human-DNA reference sequence** in fasta format, download here (https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001405.40/) and rename it to "human_reference_sequence.fasta"
- **checkm database**, download here: https://data.ace.uq.edu.au/public/CheckM_databases/, and run
``checkm data setRoot <checkm_data_dir> ``, fill in the path to your directory where the checkm database is stored
- **gtdbtk-database**, first install gtdbtk with conda, then run ``download-db.sh`` to install the database (320 GB and patience required)
- **metaquast** package for assembly statistics, download as described here: https://quast.sourceforge.net/install.html

Execution:
- The workflow can be executed on multiple samples, to ensure that all works correctly, please insert your sample names in the config.yaml file in the section: "wildcards"
- The input files must be in paired-end format, following the pattern: "{samplename}_{1/2}.fastq"
- If you provide more than two samples, please update Snakefile2 with the following codeline in the beginning: ``BIN_NR_sample2 = ast.literal_eval(bin_dict["bin_numbers"][config["wildcards"]["sample"][{sample_3}]])``, for every additional sample, that is provided, add another line with the number of the sample in inserted in the curly braces.
-  

