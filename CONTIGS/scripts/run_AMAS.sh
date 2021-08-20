#!/bin/bash

#SBATCH --job-name="amas_cat"
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

python3 /data/schwartzlab/eren/Chapter2/CONTIGS/scripts/AMAS.py concat -f fasta -d dna -i /data/schwartzlab/eren/Chapter2/SISRS_Run/aligned_contigs/*.fasta -c 20
