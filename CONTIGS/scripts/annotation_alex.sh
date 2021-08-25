#!/bin/bash
#SBATCH --job-name="annotate_bird"
#SBATCH --time=100:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=20   # processor core(s) per node

cd $SLURM_SUBMIT_DIR
date
scripts_dir="/data/schwartzlab/eren/Chapter2/CONTIGS/scripts/"
sisrsContigs="/data/schwartzlab/eren/Chapter2/CONTIGS/contigs_TRH27/"
taxonName="ColLiv"
assemblyDB="/data/schwartzlab/eren/Reference_Genomes/Birds/ColLiv/GCF_000337935.1_Cliv_1.0_genomic.fna"
assemblyGFF="/data/schwartzlab/eren/Reference_Genomes/Birds/ColLiv/GCF_000337935.1_Cliv_1.0_genomic.gff"
outputMode="l"

#Andromeda (URI's cluster) specific
module purge
module load Biopython/1.78-foss-2020b
#
python ${scripts_dir}annotation_getTaxContigs.py ${taxonName} ${sisrsContigs}

#Andromeda (URI's cluster) specific
module purge
module load BLAST+
#

makeblastdb -in ${assemblyDB} -dbtype nucl

blastn -query ${taxonName}.fasta -db ${assemblyDB} -outfmt 6 -num_threads 20 > blast_results.blast

python3 ${scripts_dir}annotation_blast_parser.py blast_results.blast > full_table.bed

sort -k1,1 -k2,2n full_table.bed > full_table_sorted.bed

#Andromeda (URI's cluster) specific
module purge
module load BEDTools/2.27.1-foss-2018b
#

bedtools intersect -a full_table_sorted.bed -b ${assemblyGFF} -wa -wb > full_table_annotated.bed

python3 ${scripts_dir}annotation_bed2table.py full_table_annotated.bed ${outputMode} > annotations.csv

date
