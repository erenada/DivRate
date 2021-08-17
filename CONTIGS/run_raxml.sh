#!/bin/bash

#this script runs raxml for each alignment on a reference tree

#usage: s/batch run_raxml.sh </tree.nwk> </alignFolder> <outFolder> <randomcount>

tree=$1 #path to the tree file
alignFolder=$2 #path to the alignment folder
outFolder=$3 #path to the output folder
randomcount=$4 #only in use for randomly selecting contigs - change for loop, give a numer eg: 100,

for alignment in $(ls $alignFolder/*fasta | sort -R | tail -$randomcount);
#for alignment in $(ls $alignFolder/*fasta); # go through each fasta file
do
  contigName=$(echo "$alignment" | cut -d "-" -f 2 | cut -d "." -f 1)
raxmlHPC -f e -t $1 -m GTRGAMMA -s $alignment -n "$contigName"
done

#name change for tree files

mv RaxML_* $outFolder/

cd $outFolder

for tree in $(ls *result*);
do
  mv $tree $tree.nwk
done
