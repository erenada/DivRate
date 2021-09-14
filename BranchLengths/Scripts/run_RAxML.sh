#!/bin/bash
#SBATCH --job-name="run_raxml"
#SBATCH --time=120:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=20   # CHANGE THIS to the number of processors
#SBATCH --mail-user="erenada@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL
#SBATCH --exclusive
#SBATCH -o r%x_%A.out
#SBATCH -e %x_%A.err

module purge


# first part of the scripts calculates the branch lengths for each sequence in data type.

AlignPath=$(echo "/data/schwartzlab/eren/Chapter2/CONTIGS/Annotation/ALIGNED")

RAxML=$(/data/schwartzlab/eren/programs/standard-RAxML/raxmlHPC-PTHREADS-SSE3)

RefTree=$(echo "/data/schwartzlab/eren/Chapter2/CONTIGS/RefTree/JarvisFinalTree.nwk")

OutPathSEP=$(echo "/data/schwartzlab/eren/Chapter2/BranchLengths/RAxML_OUT/SEP")

cd $AlignPath

ListOfData=$(set -- */; printf "%s\n" "${@%/}")

for type in ${ListOfData};
do
  mkdir ${OutPathSEP}/${type};
  for seq in $(find ${AlignPath}/${type} -name *.fasta);
  do
    ${RAxML} -f e -t ${RefTree} -m GTRGAMMA -s ${seq} -n "${seq}" -T 20 -w ${OutPathSEP}/${type}
  done
done


# second part of the script calculates the branch lengths for each concatenated data type.

CONCATDIR=$(echo "/data/schwartzlab/eren/Chapter2/CONTIGS/Annotation/CONCAT")
OutPathCONCAT=$(echo "/data/schwartzlab/eren/Chapter2/BranchLengths/RAxML_OUT/CONCAT")

cd $CONCATDIR

for type in $(set -- */; printf "%s\n" "${@%/}");
do
  mkdir ${CONCATDIR}/${type}
  ${RAxML} -f e -t ${RefTree} -m GTRGAMMA -s ${CONCATDIR}/"${type}".fasta  -n "${type}" -T 20 -w ${OutPathCONCAT}/${type}
done
