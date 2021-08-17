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

var0=$SLURM_SUBMIT_DIR
var1="$var0/JarvisFinalTree.nwk" #tree file
var2="/data/schwartzlab/eren/Chapter2/SISRS_Run/aligned_contigs" #input contigs folder
var3="$var0/raxml_out" #output folder
var4="10" #alignment number


#module load RAxML/8.2.12-intel-2019b-hybrid-avx2

#this script runs raxml for each alignment on a reference tree

#usage: sbatch run_raxml.sh </tree.nwk> </alignFolder> <outFolder> <randomcount>

# sbatch run_raxml.sh JarvisFinalTree.nwk /data/schwartzlab/eren/Chapter2/SISRS_Run/aligned_contigs /raxml_out 100


for alignment in $(ls $var2 | sort -R | tail -$randomcount);
do
contigName=$(echo "$alignment" | cut -d "-" -f 2 | cut -d "." -f 1)
#for alignment in $(ls $alignFolder/*fasta); # go through each fasta file
/data/schwartzlab/eren/programs/standard-RAxML/raxmlHPC-PTHREADS-SSE3 -f e -t $var1 -m GTRGAMMA -s $var2/$alignment -n "$contigName" -T 10
done

#name change for tree files

mv $var0/RaxML_* $var3/

cd $var0/$var3

for tree in $(ls *result*);
do
  mv $tree $tree.nwk
done
