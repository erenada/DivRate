#!/bin/bash
#SBATCH --job-name="run_raxml"
#SBATCH --time=120:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=20   # CHANGE THIS to the number of processors
#SBATCH --mail-user="erenada@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL
#SBATCH --exclusive
#SBATCH -o run_concat_raxml.out
#SBATCH -e run_concat_raxml.err

var0=$SLURM_SUBMIT_DIR
var1="$var0/JarvisFinalTree.nwk" #tree file
var2="/data/schwartzlab/eren/Chapter2/CONTIGS" #input contigs folder
var3="raxml_out/concat_out" #output folder
#var4="50000" #alignment number


#module load RAxML/8.2.12-intel-2019b-hybrid-avx2

#this script runs raxml for each alignment on a reference tree

#usage: sbatch ./run_raxml.sh

# for random est. usage: sbatch run_raxml.sh </tree.nwk> </alignFolder> <outFolder> <randomcount>

## sbatch run_raxml.sh JarvisFinalTree.nwk /data/schwartzlab/eren/Chapter2/SISRS_Run/aligned_contigs /raxml_out 100

#for alignment in $(ls $var2 | sort -R | tail -$var4);
cd /data/schwartzlab/eren/Chapter2/CONTIGS
#for alignment in $(ls $var2); # go through each fasta file
#do
#contigName=$(echo "$alignment" | cut -d "-" -f 2 | cut -d "." -f 1);
/data/schwartzlab/eren/programs/standard-RAxML/raxmlHPC-PTHREADS-SSE3 -f e -t JarvisFinalTree.nwk -m GTRGAMMA -s /data/schwartzlab/eren/Chapter2/CONTIGS/concatenated_contigs/concatenated.fasta -n concatenated -T 20
done

#name change for tree files

#mv $var0/RAxML_* $var0/$var3

#cd $var0/$var3

#for tree in $(ls *result*);
#do
  #mv $tree $tree.nwk
#done
