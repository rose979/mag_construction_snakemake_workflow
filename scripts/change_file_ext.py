# Python file for changing the file extension of the yielded clean reads from host dna contamination removal
# bowtie2 produces read files with the extension .1 and .2, which are not supported by other tools of this workflow
import os

def change_file_ext(directory):
    file_found = False # control instance, if the specified read files were found
    for entry in os.scandir(directory):
        if entry.is_file():
            filename, ext = os.path.splitext(entry.name)
            if ext == ".1":
                new_filename = filename + "_1.fastq"
                os.rename(entry.path, os.path.join(directory, new_filename))
                file_found = True
            elif ext == ".2":
                new_filename = filename + "_2.fastq"
                os.rename(entry.path, os.path.join(directory, new_filename))
                file_found = True

    if not file_found:
        raise FileNotFoundError(f"No relevant files were found in directory: {directory}")
    
    return "File Extensions were successfully changed!" 
               

directory = os.path.dirname(snakemake.input[0])
print(change_file_ext(directory))