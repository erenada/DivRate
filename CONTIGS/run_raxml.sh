#!/bin/bash
#SBATCH --job-name="run_raxml"
#SBATCH --time=120:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=20   # CHANGE THIS to the number of processors
#SBATCH --mail-user="erenada@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL
#SBATCH --exclusive
#SBATCH -o run_raxml.out
#SBATCH -e run_raxml.err

#module load RAxML/8.2.12-intel-2019b-hybrid-avx2

#this script runs raxml for each alignment on a reference tree

#usage: sbatch run_raxml.sh </tree.nwk> </alignFolder> <outFolder> <randomcount>

# sbatch run_raxml.sh JarvisFinalTree.nwk /data/schwartzlab/eren/Chapter2/SISRS_Run/aligned_contigs /raxml_out 100

tree=$1 #path to the tree file
alignFolder=$2 #path to the alignment folder
outFolder=$3 #path to the output folder
randomcount=$4 #only in use for randomly selecting contigs - change for loop, give a numer eg: 100
submit_directory=$(pwd) #change in bash

cd $alignFolder

for alignment in $(ls $alignFolder | sort -R | tail -$randomcount);
do
contigName=$(echo "$alignment" | cut -d "-" -f 2 | cut -d "." -f 1)
#for alignment in $(ls $alignFolder/*fasta); # go through each fasta file
/data/schwartzlab/eren/programs/standard-RAxML/raxmlHPC-PTHREADS-SSE3 -f e -t $submit_directory/$1 -m GTRGAMMA -s $alignFolder/$alignment -n "$contigName" -T 10
done

#name change for tree files

mv $submit_directory/RaxML_* $submit_directory/$outFolder

cd $submit_directory/$outFolder

for tree in $(ls *result*);
do
  mv $tree $tree.nwk
done
