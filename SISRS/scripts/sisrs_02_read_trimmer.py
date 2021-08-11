#!/usr/bin/env python3

'''
Paired-end read files must be identically basenamed and end in _1/_2
Input: (Optional) -p/--processors Number of available processors for FastQC
(Default: 1, For 10 processors: python sisrs_02_read_trimmer.py -p 10)
# Output: (1) Trimmed Reads (in <base_dir>/Reads/TrimReads/<Taxon>/<Read_Basename>_Trim.fastq.gz
# Output: (2) Trim Log (in <base_dir>/Reads/RawReads/trimOutput)
# Output: (3) FastQC output for all raw + trimmed read sets (in <base_dir>/Reads/RawReads/fastqcOutput & <base_dir>/Reads/TrimReads/fastqcOutput)
'''

import os
from os import path
import sys
from glob import glob
from cmdCheck import *
import subprocess
from subprocess import check_call

'''
This function is designed to Find BBDuk + Adapter File. It will return the path
to the location of these files.
'''
def findAdapter():
    cmd = ['which', 'bbduk.sh']
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    o, e = proc.communicate()
    bbduk_adapter = path.dirname(o.decode('ascii'))+"/resources/adapters.fa"

    return bbduk_adapter

'''
This function is deisgned to do the remaining folder setup that is needed to do
the genome triming. Its only argument is the directory where all of the sisrs
output is being stored and will be returning the
'''
def setup(sisrs_dir):
    # Returned items as a list
    # raw_read_dir          --> 0
    # trim_read_dir         --> 1
    # trim_output           --> 2
    # raw_fastqc_output     --> 3
    # trim_fastqc_output    --> 4
    # raw_read_tax_dirs     --> 5
    rtn = []

    #Set RawRead and TrimRead directories based off of script folder location
    raw_read_dir = sisrs_dir+"/Reads/RawReads"
    trim_read_dir = sisrs_dir+"/Reads/TrimReads"
    rtn += [raw_read_dir]
    rtn += [trim_read_dir]

    #Find taxa folders within RawRead folder
    raw_read_tax_dirs = sorted(glob(raw_read_dir+"/*/"))

    #Create folder for BBDuk StdOut
    if not path.isdir(raw_read_dir+"/trimOutput"):
        os.mkdir(raw_read_dir+"/trimOutput")
    rtn += [raw_read_dir+"/trimOutput/"]

    #Create folder for Raw FastQC output
    if not path.isdir(raw_read_dir+"/fastqcOutput"):
        os.mkdir(raw_read_dir+"/fastqcOutput")
    rtn += [raw_read_dir+"/fastqcOutput/"]

    #Create folder for Trimmed FastQC output
    if not path.isdir(trim_read_dir+"/fastqcOutput"):
        os.mkdir(trim_read_dir+"/fastqcOutput")
    rtn += [trim_read_dir+"/fastqcOutput/"]

    #Ensure Trim Log/FastQC output directories not included in taxa list
    raw_read_tax_dirs = [x for x in raw_read_tax_dirs if not x.endswith('trimOutput/')]
    raw_read_tax_dirs = [x for x in raw_read_tax_dirs if not x.endswith('fastqcOutput/')]

    rtn += [raw_read_tax_dirs]

    return rtn

'''
This function is designed to run the fastqc command with new data only. Modified
to run both the raw and the trimmed data, takes the number of processors, the
output directory, and the read directory.
'''
def newdFastqc(processors,fastqc_output,data_dir,newFiles):
    #Run FastQC on all trimmed files, using all available processors
    fastqc_command = [
        'fastqc',
        '-t',
        '{}'.format(processors),
        '-o',
        '{}'.format(fastqc_output)]

    for item in data_dir:
        for x in glob(item+"/*.fastq.gz"):
            f = x.split('/')

            if f[-1] in newFiles:
                fastqc_command.append(x)

    check_call(fastqc_command)

'''
This function is designed to run the fastqc command. Modified to run both the raw
and the trimmed data, takes the number of processors, the output directory, and
the read directory.
'''
def fastqcCommand(processors,fastqc_output,read_dir):
    #Run FastQC on all trimmed files, using all available processors
    fastqc_command = [
        'fastqc',
        '-t',
        '{}'.format(processors),
        '-o',
        '{}'.format(fastqc_output)]

    for x in glob(read_dir+"/*/*.fastq.gz"):
        fastqc_command.append(x)

    check_call(fastqc_command)

'''
This function is desinged to do setup work to obtain all of the possible
single read and pair read files. Its main purpose is to clean up the large for
loop that is seem below in the trim function. It only needs the current working
raw read directory and the matching trim read directory as arguments.
'''
def trimHelper(tax_dir,trim_read_dir,newData):

    #List all files and set output dir
    files = sorted(glob(tax_dir+"*.fastq.gz"))
    taxon_ID = path.basename(tax_dir[:-1])
    out_trim_dir = trim_read_dir + "/" + taxon_ID

    left_pairs = list()
    right_pairs = list()
    single_end = list()

    #Find files ending in _1/_2.fastq.gz
    left_files = [s for s in files if "_1.fastq.gz" in s]
    right_files = [s for s in files if "_2.fastq.gz" in s]

    lf = []
    rf = []
    if newData != []:
        for f in left_files:
            o = f.split('/')
            if o[-1] in newData:
                lf += [f]
        left_files = lf
        for f in right_files:
            o = f.split('/')
            if o[-1] in newData:
                rf += [f]
        right_files = rf

    #Strip _1.fastq.gz/_2.fastq.gz and identify pairs based on file name
    left_files = [x.replace('_1.fastq.gz', '') for x in left_files]
    right_files = [x.replace('_2.fastq.gz', '') for x in right_files]

    paired_files = list(set(left_files).intersection(right_files))

    #Reset file names and filter out single-end files
    for pair in paired_files:
        left_pairs.append(pair+"_1.fastq.gz")
        right_pairs.append(pair+"_2.fastq.gz")
    paired_files = sorted(left_pairs + right_pairs)

    single_end = [x for x in files if x not in paired_files]

    se = []
    if newData != []:
        for f in single_end:
            o = f.split('/')
            if o[-1] in newData:
                se += [f]
        single_end = se

    #Remove .fastq.gz from lists to make naming easier
    left_pairs = [x.replace('_1.fastq.gz', '') for x in left_pairs]
    right_pairs = [x.replace('_2.fastq.gz', '') for x in right_pairs]
    single_end = [x.replace('.fastq.gz', '') for x in single_end]

    return out_trim_dir,left_pairs,right_pairs,single_end


'''
This function is designed to trim all of the rawdata that has been provided to
the program. It requiers the raw_read_tax_dirs, trim_read_dir, trim_output, and
bbduk_adapter file.
'''
def trim(raw_read_tax_dirs,trim_read_dir,bbduk_adapter,trim_output,newData):

    #For each taxa directory...
    for tax_dir in raw_read_tax_dirs:

        out_trim_dir,left_pairs,right_pairs,single_end = trimHelper(tax_dir,trim_read_dir,newData)

        #Trim single-end files if present...
        if len(single_end) > 0:
            for x in single_end:
                se_trim_command = [
                    'bbduk.sh',
                    'maxns=0',
                    'ref={}'.format(bbduk_adapter),
                    'qtrim=w',
                    'trimq=15',
                    'minlength=35',
                    'maq=25',
                    'in={}'.format(x+'.fastq.gz'),
                    'out={}'.format(out_trim_dir+"/"+path.basename(x)+'_Trim.fastq.gz'),
                    'k=23',
                    'mink=11',
                    'hdist=1',
                    'hdist2=0',
                    'ktrim=r',
                    'ow=t',
                    '&>',
                    '{outDir}out_{fileName}_Trim'.format(outDir=trim_output,fileName=path.basename(x))]
                check_call(se_trim_command)

        #Trim paired-end files if present...
        if(len(left_pairs) == len(right_pairs) & len(left_pairs) > 0):
            for x in range(len(left_pairs)):
                file_name = path.basename(left_pairs[x])
                pe_trim_command = [
                    'bbduk.sh',
                    'maxns=0',
                    'ref={}'.format(bbduk_adapter),
                    'qtrim=w',
                    'trimq=15',
                    'minlength=35',
                    'maq=25',
                    'in={}'.format(left_pairs[x]+'_1.fastq.gz'),
                    'in2={}'.format(right_pairs[x]+'_2.fastq.gz'),
                    'out={}'.format(out_trim_dir+"/"+path.basename(left_pairs[x])+'_Trim_1.fastq.gz'),
                    'out2={}'.format(out_trim_dir+"/"+path.basename(right_pairs[x])+'_Trim_2.fastq.gz'),
                    'k=23',
                    'mink=11',
                    'hdist=1',
                    'hdist2=0',
                    'ktrim=r',
                    'ow=t',
                    '&>',
                    '{outDir}out_{fileName}_Trim'.format(outDir=trim_output,fileName=file_name)]
                check_call(pe_trim_command)

if __name__ == "__main__":

    cmd = sys.argv
    #sis = os.path.dirname(sys.path[0]) #use for a default path up one dir

    if len(cmd) < 3: 
        print("THIS SCRIPT REQUIERS A MINIMUM OF 2 ARGUMENT (-dir <path to output directory>")
        exit()

    sis = " "
    if '-dir' in cmd or '--directory' in cmd:
        out_dir = isFound('-dir','--directory',cmd)
        sis = out_dir
    else:
        print("SPECIFY THE OUTPUT PATH (-dir, --directory).PROGRAM EXITING.")
        exit()

    proc = 1
    if '-p' in cmd or '--processors' in cmd:
        try:
            proc = int(isFound('-p','--processors',cmd))
        except:
            proc = 1
    else:
        print("SWITCHING TO DEFAULT 1 PROCESSOR (-p,--processors)")

    bba = findAdapter()
    out = setup(sis)

    # raw_fastqc_command
    fastqcCommand(proc,out[3],out[0])

    trim(out[5],out[1],bba,out[2],[])

    # trim_fastqc_command
    fastqcCommand(proc,out[4],out[1])
