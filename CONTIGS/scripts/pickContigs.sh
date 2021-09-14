#!/bin/bash

#getting the contig names


for contig in $(cut -d'/' -f 1 /data/schwartzlab/eren/Chapter2/SISRS_Run/missing_5/alignment_locs_m5_nogap.txt | uniq -c | sort -bgr | sed 's/[[:space:]]*[[:digit:]]*[[:space:]]//' | head -50000);
do
  ln -s /data/schwartzlab/eren/Chapter2/SISRS_Run/aligned_contigs/"${contig}".fasta /data/schwartzlab/eren/Chapter2/CONTIGS/Annotation/ALIGNED/ALL_50K/"${contig}".fasta
done


#cut -d'/' -f 1 alignment_locs_m5_nogap.txt | uniq -c | sort -bgr | sed 's/[[:space:]]//' > sorted_frequencies.csv
