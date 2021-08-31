#!/bin/bash
#SBATCH --job-name="align_subsets"
#SBATCH --time=99:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=20   # CHANGE THIS to processor core(s) per node
#SBATCH --mail-user="erenada@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=END,FAIL
#SBATCH -o %x_%A.out
#SBATCH -e %x_%A.err
#SBATCH --exclusive

module load MAFFT/7.475-gompi-2020b-with-extensions

listOfData=$(cat /data/schwartzlab/eren/Chapter2/CONTIGS/Annotation/annot_table_all.csv | tail -n +2 | cut -f 2 | sort | uniq)
PTH=(/data/schwartzlab/eren/Chapter2/CONTIGS/Annotation)
PTH_OUT=(/data/schwartzlab/eren/Chapter2/CONTIGS/Annotation/ALIGNED)

for type in $listOfData;
do
  mkdir /data/schwartzlab/eren/Chapter2/CONTIGS/Annotation/ALIGNED/${type}
  FILELIST=$(ls $PTH/${type}/*.fasta)
  ARRLEN=${#FILELIST[@]}
  for infile in $FILELIST;
  do
    out_file=$(basename ${FILELIST[i]})
    echo mafft --nwildcard --auto --thread 20 ${infile} > ${PTH}/${type}/${out_file}
  done
done
