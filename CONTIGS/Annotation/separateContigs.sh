#!/bin/bash

cd /data/schwartzlab/eren/Chapter1/CONTIGS/Annotation

listOfData=$(cat annot.csv | tail -n +2 | cut -f 2 | sort | uniq)

for type in $listOfData;
do
  mkdir $type

  alignmentList=$(tail -n +2 /data/schwartzlab/eren/Chapter1/CONTIGS/Annotation/"$type"_table.csv | cut -f 1)
  for file in $alignmentList;
  do
    ln -s /data/schwartzlab/eren/Chapter1/CONTIGS/contigs_5_missing/${file} /data/schwartzlab/eren/Chapter1/CONTIGS/Annotation/${type}/${file}
  done
done