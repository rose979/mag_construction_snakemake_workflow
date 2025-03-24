# mag_construction_snakemake_workflow
This is a snakemake workflow for the construction of metagenome-assembled genomes, based on the protocol: "Protocol for the construction and functional profiling of metagenome-assembled genomes for microbiome analyses", by Goutam Banerjee, Suraya Rahman Papri and Pratik Banerjee. It can be found here: https://www.sciencedirect.com/science/article/pii/S2666166724003320

Requirements: As described in the Star Protocol
- Hardware minimum: 32 GB RAM and 1.5 TB storage
- Human-DNA reference sequence in fasta format, download here (https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001405.40/) and rename it to "human_reference_sequence.fasta"
- checkm database, download here: https://data.ace.uq.edu.au/public/CheckM_databases/, and run
``checkm data setRoot <checkm_data_dir> ``
