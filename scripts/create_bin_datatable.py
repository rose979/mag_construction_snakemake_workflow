import pandas as pd
import yaml
import os

# function to collect all unique bin numbers from each created bin respectively
def get_bin_nr(bin_dir):
    bin_found = False
    bin_arr = []
    for entry in os.scandir(bin_dir):
        if entry.is_file() and os.path.splitext(entry.name)[1] == ".fasta":
            bin_found = True
            bin_nr = str(os.path.splitext(entry.name)[0]).split('_')[1]
            bin_arr.append(bin_nr)
        
    if not bin_found:
        raise FileNotFoundError(f"No bin file found")
    return bin_arr

# create a dataframe, which contains the bin numbers for each sample
def create_dataframe(samples, all_bin_arr):
    df = pd.DataFrame({'bin_numbers': all_bin_arr}, index=samples)
    df.index.name = 'sample'
    return df

# load the config file with the samples
with open("config_1.yaml", "r") as file:
    config = yaml.safe_load(file)

# fill in the arrays with all bin numbers and the number of bins from each sample
all_bin_arr = []
for i in config["wildcards"]["sample"]:
    bin_arr = get_bin_nr(f"data/bins/dereplicated_{i}/dereplicated_genomes")
    all_bin_arr.append(bin_arr)

# create the dataframe
df = create_dataframe(config["wildcards"]["sample"], all_bin_arr)
df.to_csv('data/bins/bin_datatable.csv', index=True)
