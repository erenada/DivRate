#!/usr/bin/env python3

'''

This script runs one sisrs alignment
'''

import os
from os import path
import sys
from glob import glob
from cmdCheck import *
import argparse
import re

'''
This function runs bowtie2 on the reads in a folder treating all reads as unpaired
'''
def runBowtie(outPath,threads,readfolder):

    outbam = "".join([outPath, '/SISRS_Run/', os.path.basename(os.path.dirname(readfolder)), #dirname then basename bc ends w /
        '/',
        os.path.basename(os.path.dirname(readfolder)),
        '_Temp.bam'])
    outbamb = "".join([outPath, '/SISRS_Run/', os.path.basename(os.path.dirname(readfolder)), #AotNan
        '/',
        os.path.basename(os.path.dirname(readfolder)),
        '.bam'])
    print(outbam)

    bowtie_command = [
        'bowtie2 -p ',
        str(threads),
        ' -N 1 --local -x ',
        outPath,'/SISRS_Run/Composite_Genome/contigs -U ', #contigs base of filename
        ",".join(glob(os.path.expanduser(readfolder)+'/*.fastq.gz')), #files in the readfolder
        ' | samtools view -Su -@ ', 
        str(threads),
        ' -F 4 - | samtools sort -@ ',
        str(threads),
        ' - -o ',
        outbam]
    print(bowtie_command)
    os.system("".join(bowtie_command))

    samtools1 = [
        'samtools view -@ ',
        str(threads),
        ' -H ', outbam,
        ' > ', outbam, '_Header.sam' ]
    samtools2 = [ 
        'samtools view -@ ', 
        str(threads),
        ' ', outbam, ' | grep -v "XS:" | cat ', outbam, '_Header.sam - | samtools view -@ ',
        str(threads), ' -b - > ', outbamb]
    
    print(samtools1)
    print(samtools2)
   
    os.system("".join(samtools1))
    os.system("".join(samtools2)) #why is this command necessary?

    os.remove(outbam)  #rm SISRS_DIR/TAXA/TAXA_Temp.bam
    os.remove(outbam+'_Header.sam') #rm SISRS_DIR/TAXA/TAXA_Header.sam

if __name__ == '__main__':

    # Get arguments
    my_parser = argparse.ArgumentParser()
    my_parser.add_argument('-d','--directory',action='store',nargs="?")
    my_parser.add_argument('-p','--processors',action='store',default=1,nargs="?")
    my_parser.add_argument('-f', '--folder', action='store',nargs="?")
    args = my_parser.parse_args()

    sis = args.directory
    proc = args.processors
    folder = args.folder

    print(sis, folder)

    runBowtie(sis,proc,folder)
