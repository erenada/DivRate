

# Concatenating multiple sequences
#
#
import os
from Bio.Nexus import Nexus

# the combine function takes a list of tuples [(name, nexus instance)...],
# if we provide the file names in a list we can use a list comprehension to
# create these tuples
path_to_files ="/data/schwartzlab/eren/Chapter2/SISRS_Run/aligned_contigs/"
file_list = os.listdir(path_to_files)


#file_list = ["btCOI.nex", "btCOII.nex", "btITS.nex"]
nexi = [(fname, Nexus.Nexus(fname)) for fname in file_list]

combined = Nexus.combine(nexi)
combined.write_nexus_data(filename=open("btCOMBINED.nex", "w"))
