#!/bin/bash

#SBATCH --job-name="cat_subsets"
#SBATCH --time=100:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=20   # CHANGE THIS to the number of processors on your node
#SBATCH --mail-user="erenada@uri.edu" #CHANGE THIS to your email address
#SBATCH --mail-type=ALL
#SBATCH -o %x_%A.out
#SBATCH -e %x_%A.err
#SBATCH --exclusive

cd $SLURM_SUBMIT_DIR

module purge

#CHANGE THESE IF NOT ON A URI SYSTEM

module load Python/3.7.4-GCCcore-8.3.0

listOfData=$(cat ../Tables/annot_table_all.csv | tail -n +2 | cut -f 2 | sort | uniq)

PTH=(/data/schwartzlab/eren/Chapter1/CONTIGS/Annotation/ALIGNED)
PTH_OUT=(/data/schwartzlab/eren/Chapter1/CONTIGS/Annotation/CONCAT)

for type in $listOfData;
do
  mkdir ${PTH_OUT}/${type}
done


for type in $listOfData;
do
  cp /data/schwartzlab/eren/Chapter1/CONTIGS/Annotation/Scripts/AMAS_ch1.py ${PTH}/${type}/AMAS_ch1.py

  cd ${PTH}/${type}

  python3 AMAS_ch1.py concat -f fasta -d dna -i *fasta -c 20 --part-format raxml --concat-part "${type}"_partition.txt --concat-out "${type}"_concat.fasta

  mv "${type}"_concat.fasta ${PTH_OUT}/${type}/"${type}"_concat.fasta
  mv "${type}"_partition.txt ${PTH_OUT}/${type}/"${type}"_partition.txt
  rm AMAS_ch1.py
done
