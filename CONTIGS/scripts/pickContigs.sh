#!/bin/bash
#SBATCH --job-name="pickContigs"
#SBATCH --time=120:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=20   # CHANGE THIS to the number of processors
#SBATCH --mail-user="erenada@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL
#SBATCH --exclusive
#SBATCH -o %x_%A.out
#SBATCH -e %x_%A.err


#getting the contig names and linking


for contig in $(cut -d'/' -f 1 /data/schwartzlab/eren/Chapter2/SISRS_Run/missing_5/alignment_locs_m5_nogap.txt | uniq -c | sort -bgr | sed 's/[[:space:]]*[[:digit:]]*[[:space:]]//' | head -50000);
do
  ln -s /data/schwartzlab/eren/Chapter2/SISRS_Run/aligned_contigs/"${contig}".fasta /data/schwartzlab/eren/Chapter2/CONTIGS/Annotation/ALIGNED/ALL_50K/"${contig}".fasta
done


#cut -d'/' -f 1 alignment_locs_m5_nogap.txt | uniq -c | sort -bgr | sed 's/[[:space:]]//' > sorted_frequencies.csv
