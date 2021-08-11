#!/bin/bash
#SBATCH --job-name="6_step_last_taxa"
#SBATCH --time=24:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=20   # CHANGE THIS to processor core(s) per node
#SBATCH --mail-user="erenada@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=END,FAIL
#SBATCH --exclusive

#CHANGE IF NOT on a URI system
module load Python/3.7.4-GCCcore-8.3.0
module load SciPy-bundle/2019.10-foss-2019b-Python-3.7.4
module load Bowtie2/2.3.5.1-GCC-8.3.0
module load FastQC/0.11.8-Java-1.8
module load BBMap/38.81-foss-2019b-Java-1.8
module load Biopython/1.75-foss-2019b-Python-3.7.4
module load Ray/2.3.1-foss-2019b
module load SAMtools/1.10-GCC-8.3.0
module load BEDTools/2.29.2-GCC-8.3.0

#bowtie2 -p 20 -N 1 --local -x /data/schwartzlab/eren/Chapter2/SISRS_Run/Composite_Genome/contigs -U /data/schwartzlab/eren/Chapter2/Reads/TrimReads/TytAlb/TytAlb_SRR959575_Trim_1.fastq.gz,/data/schwartzlab/eren/Chapter2/Reads/TrimReads/TytAlb/TytAlb_SRR959575_Trim_2.fastq.gz,/data/schwartzlab/eren/Chapter2/Reads/TrimReads/TytAlb/TytAlb_SRR959576_Trim_1.fastq.gz,/data/schwartzlab/eren/Chapter2/Reads/TrimReads/TytAlb/TytAlb_SRR959576_Trim_2.fastq.gz | samtools view -Su -@ 20 -F 4 - | samtools sort -@ 20 - -o /data/schwartzlab/eren/Chapter2/SISRS_Run/TytAlb/TytAlb_Temp.bam

samtools view -@ 20 -H /data/schwartzlab/eren/Chapter2/SISRS_Run/TytAlb/TytAlb_Temp.bam > /data/schwartzlab/eren/Chapter2/SISRS_Run/TytAlb/TytAlb_Temp.bam_Header.sam

samtools view -@ 20 /data/schwartzlab/eren/Chapter2/SISRS_Run/TytAlb/TytAlb_Temp.bam | grep -v "XS:" | cat /data/schwartzlab/eren/Chapter2/SISRS_Run/TytAlb/TytAlb_Temp.bam_Header.sam - | samtools view -@ 20 -b - > /data/schwartzlab/eren/Chapter2/SISRS_Run/TytAlb/TytAlb.bam

