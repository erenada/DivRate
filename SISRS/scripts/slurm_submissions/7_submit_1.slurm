#!/bin/sh
#SBATCH --job-name="7_step_1"
#SBATCH --time=90:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node - just use 1 - it doesn't parallel
#SBATCH --mail-user="erenada@uri.edu" #CHANGE to your user email address
#SBATCH --mail-type=END,FAIL

python3 /data/schwartzlab/eren/Chapter2/SISRS/scripts/filter_nexus_for_missing.py /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment.nex 1
python3 /data/schwartzlab/eren/Chapter2/SISRS/scripts/filter_nexus_for_missing_nogap.py /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment.nex 1

grep -oe "SISRS_[^/]*" /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_locs_m1.txt | uniq -c | sort -k1 -nr | awk '{print $2}' > /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_locs_m1_Clean.txt
grep -oe "SISRS_[^/]*" /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_locs_m1_nogap.txt | uniq -c | sort -k1 -nr | awk '{print $2}' > /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_locs_m1_nogap_Clean.txt

python3 /data/schwartzlab/eren/Chapter2/SISRS/scripts/filter_nexus_for_missing.py /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_bi.nex 1
python3 /data/schwartzlab/eren/Chapter2/SISRS/scripts/filter_nexus_for_missing_nogap.py /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_bi.nex 1

grep -oe "SISRS_[^/]*" /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_bi_locs_m1.txt | uniq -c | sort -k1 -nr | awk '{print $2}' > /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_bi_locs_m1_Clean.txt
grep -oe "SISRS_[^/]*" /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_bi_locs_m1_nogap.txt | uniq -c | sort -k1 -nr | awk '{print $2}' > /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_bi_locs_m1_nogap_Clean.txt

python3 /data/schwartzlab/eren/Chapter2/SISRS/scripts/filter_nexus_for_missing.py /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_pi.nex 1
python3 /data/schwartzlab/eren/Chapter2/SISRS/scripts/filter_nexus_for_missing_nogap.py /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_pi.nex 1

grep -oe "SISRS_[^/]*" /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_pi_locs_m1.txt | uniq -c | sort -k1 -nr | awk '{print $2}' > /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_pi_locs_m1_Clean.txt
grep -oe "SISRS_[^/]*" /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_pi_locs_m1_nogap.txt | uniq -c | sort -k1 -nr | awk '{print $2}' > /data/schwartzlab/eren/Chapter2/SISRS_Run/alignment_pi_locs_m1_nogap_Clean.txt
