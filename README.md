# mag_construction_snakemake_workflow
This is a snakemake workflow for the construction of metagenome-assembled genomes, based on the protocol: "Protocol for the construction and functional profiling of metagenome-assembled genomes for microbiome analyses", by Goutam Banerjee, Suraya Rahman Papri and Pratik Banerjee. It can be found at https://www.sciencedirect.com/science/article/pii/S2666166724003320.
The workflow is divided into two sub-workflows, the first deals with the construction and optimisation of the MAG's, the second sub-workflow deals with the functional annotation of the MAGS.
Execution:
- To create the conda environment needed for the workflow, type ``conda env create -n mag_construction_snakemake -f config.yaml`` 
- To execute the first sub-workflow, type ``snakemake --snakefile Snakefile1 --sdm conda`` in your Linux or WSL terminal
- To execute the second sub-workflow, type ``snakemake --snakefile Snakefile2 --sdm conda``


Requirements:
- Minimum hardware: 32 GB RAM and 1.5 TB disk space
- **Human-DNA reference sequence** in fasta format, download here (https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001405.40/) and rename it to "human_reference_sequence.fasta" and store it in data/host_dna_removal
- **CheckM database**, download here: https://data.ace.uq.edu.au/public/CheckM_databases/, and run
``checkm data setRoot <checkm_data_dir> ``, fill in the path to your directory where the checkm database is stored
- **gtdbtk-database**, first install gtdbtk with conda, then run ``download-db.sh`` to install the database (320 GB and patience required)
- **metaquast** assembly statistics package, download as described here: https://quast.sourceforge.net/install.html

Details:
- The workflow can be run on multiple samples, to ensure that all work correctly, please update config.yaml with your sample names in the section: "wildcards"
- The input files must be in paired-end format, following the pattern: "{samplename}_{1/2}.fastq"
- If you provide more than two samples, please update Snakefile2 with the following codeline at the beginning: ``BIN_NR_sample2 = ast.literal_eval(bin_dict["bin_numbers"][config["wildcards"]["sample"][{sample_3}]])``, for each additional sample provided, add another line with the number of the sample in between the curly braces.

