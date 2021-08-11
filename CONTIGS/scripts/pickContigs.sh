#!bin/bash

#getting the contig names


for contig in $(cut -d'/' -f 1 /data/schwartzlab/eren/Chapter2/SISRS_Run/missing_5/alignment_locs_m5_nogap.txt | uniq -c | sort -bgr | sed 's/[[:space:]]*[[:digit:]]*[[:space:]]//' | head 50000);
do
  cp /data/schwartzlab/eren/Chapter2/CONTIGS/contigs_29M/$contig.fasta /data/schwartzlab/eren/Chapter2/CONTIGS/contigs_5M/
done
