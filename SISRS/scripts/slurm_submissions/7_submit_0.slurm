#!/bin/sh
#SBATCH --job-name="7_step_0"
#SBATCH --time=90:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node - just use 1 - it doesn't parallel
#SBATCH --mail-user="erenada@uri.edu" #CHANGE to your user email address
#SBATCH --mail-type=END,FAIL

cd $SLURM_SUBMIT_DIR

module purge

#CHANGE if not on a URI system
module load Python/3.7.4-GCCcore-8.3.0
module load SciPy-bundle/2019.10-foss-2019b-Python-3.7.4
module load Bowtie2/2.3.5.1-GCC-8.3.0
module load FastQC/0.11.8-Java-1.8
module load BBMap/38.81-foss-2019b-Java-1.8
module load Biopython/1.75-foss-2019b-Python-3.7.4
module load Ray/2.3.1-foss-2019b
module load SAMtools/1.10-GCC-8.3.0
module load BEDTools/2.29.2-GCC-8.3.0

python3 /data/schwartzlab/eren/Chapter2/SISRS/scripts/filter_nexus_for_missing.py /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment.nex 0
python3 /data/schwartzlab/eren/Chapter2/SISRS/scripts/filter_nexus_for_missing_nogap.py /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment.nex 0

grep -oe "SISRS_[^/]*" /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_locs_m0.txt | uniq -c | sort -k1 -nr | awk '{print $2}' > /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_locs_m0_Clean.txt
grep -oe "SISRS_[^/]*" /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_locs_m0_nogap.txt | uniq -c | sort -k1 -nr | awk '{print $2}' > /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_locs_m0_nogap_Clean.txt

python3 /data/schwartzlab/eren/Chapter2/SISRS/scripts/filter_nexus_for_missing.py /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_bi.nex 0
python3 /data/schwartzlab/eren/Chapter2/SISRS/scripts/filter_nexus_for_missing_nogap.py /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_bi.nex 0

grep -oe "SISRS_[^/]*" /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_bi_locs_m0.txt | uniq -c | sort -k1 -nr | awk '{print $2}' > /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_bi_locs_m0_Clean.txt
grep -oe "SISRS_[^/]*" /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_bi_locs_m0_nogap.txt | uniq -c | sort -k1 -nr | awk '{print $2}' > /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_bi_locs_m0_nogap_Clean.txt

python3 /data/schwartzlab/eren/Chapter2/SISRS/scripts/filter_nexus_for_missing.py /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_pi.nex 0
python3 /data/schwartzlab/eren/Chapter2/SISRS/scripts/filter_nexus_for_missing_nogap.py /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_pi.nex 0

grep -oe "SISRS_[^/]*" /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_pi_locs_m0.txt | uniq -c | sort -k1 -nr | awk '{print $2}' > /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_pi_locs_m0_Clean.txt
grep -oe "SISRS_[^/]*" /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_pi_locs_m0_nogap.txt | uniq -c | sort -k1 -nr | awk '{print $2}' > /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_pi_locs_m0_nogap_Clean.txt
