#!/bin/bash
#SBATCH --job-name="run_part_cat_raxml"
#SBATCH --time=120:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=20   # CHANGE THIS to the number of processors
#SBATCH --mail-user="erenada@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL
#SBATCH --exclusive
#SBATCH -o run_concat_raxml.out
#SBATCH -e run_concat_raxml.err


/data/schwartzlab/eren/programs/standard-RAxML/raxmlHPC-PTHREADS-SSE3 -f e -t JarvisFinalTree.nwk -m GTRGAMMA -s /data/schwartzlab/eren/Chapter2/CONTIGS/concatenated_contigs/concatenated.fasta.reduced -n concatenated -T 20 -q /data/schwartzlab/eren/Chapter2/CONTIGS/concatenated_contigs/RAxML_partition_file.reduced
