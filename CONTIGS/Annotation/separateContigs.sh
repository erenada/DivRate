#!/bin/bash
#SBATCH --job-name="linking_2"
#SBATCH --time=10:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=20   # CHANGE THIS to processor core(s) per node
#SBATCH --mail-user="erenada@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=END,FAIL
#SBATCH --exclusive


cd /data/schwartzlab/eren/Chapter2/CONTIGS/Annotation

listOfData=$(cat annot_table_all.csv | tail -n +2 | cut -f 2 | sort | uniq)

for type in $listOfData;
do
  mkdir $type
  alignmentList=$(tail -n +2 /data/schwartzlab/eren/Chapter2/CONTIGS/Annotation/"$type"_table.csv | cut -f 1)
  for file in $alignmentList;
  do
    ln -s /data/schwartzlab/eren/Chapter2/SISRS_Run/contigs_outputs/${file} /data/schwartzlab/eren/Chapter1/CONTIGS/Annotation/${type}/${file}
  done
done
