#!/bin/bash

## Assumes a directory with paired fastq files ending in either
## _1.fastq.gz and _2.fastq.gz or R1.fastq.gz and R2.fastq.gz.

## Running in the directory with these files will create a top-level
## "cfsan" directory, with subdirectories for each sample name, 
## extracted from the read name files by removing the suffix.

## Finally, the script will symlink the read_1 and read_2 files
## into the appropriate cfsan/sample subdirectory. 

## E.g., go from this, a flat directory of _1 and _2.fastq.gz files:

# $ tree .
# |-- samp1_1.fastq.gz
# |-- samp1_2.fastq.gz
# |-- samp2_1.fastq.gz
# |-- samp2_2.fastq.gz
# |-- samp3_1.fastq.gz
# |-- samp3_2.fastq.gz

## to this, the correct directory structure as needed by CFSAN SNP pipeline.

# $ tree .
# |-- cfsan
# |   |-- samp1
# |   |   |-- samp1_1.fastq.gz -> /home/ubuntu/exampledata/samp1_1.fastq.gz
# |   |   |-- samp1_2.fastq.gz -> /home/ubuntu/exampledata/samp1_2.fastq.gz
# |   |-- samp2
# |   |   |-- samp2_1.fastq.gz -> /home/ubuntu/exampledata/samp2_1.fastq.gz
# |   |   |-- samp2_2.fastq.gz -> /home/ubuntu/exampledata/samp2_2.fastq.gz
# |   |-- samp3
# |   |   |-- samp3_1.fastq.gz -> /home/ubuntu/exampledata/samp3_1.fastq.gz
# |   |   |-- samp3_2.fastq.gz -> /home/ubuntu/exampledata/samp3_2.fastq.gz
# |-- samp1_1.fastq.gz
# |-- samp1_2.fastq.gz
# |-- samp2_1.fastq.gz
# |-- samp2_2.fastq.gz
# |-- samp3_1.fastq.gz
# |-- samp3_2.fastq.gz


# For all pairs of fastq files
for i in *[_R]1.fastq.gz
do
  # Strip off the _1.fastq.gz to get just the sample name
  i=$(echo $i | sed 's/1\.fastq\.gz//g')
  # Strip off any other remaining cruft
  iclean=$(echo $i | sed 's/[R_]$//g')
  # These are the full paths to the _1 and _2 read pair files
  r1="$(readlink -f ${i}1.fastq.gz)"
  r2="$(readlink -f ${i}2.fastq.gz)"
  # Logging
  echo "Sample: $iclean"
  echo "Read 1: $r1"
  echo "Read 2: $r2"
  # If you've already created the subdirectory skip it.
  if [ -d "cfsan/$iclean" ]; then
    echo "WARNING: Skipping sample $iclean; output directory cfsan/$iclean already exists."
    echo
    continue
  fi
  echo "Creating cfsan/$iclean subdirectory and sylinking read files into that directory:"
  # Make a subdirectory in cfsan for the sample name
  echo "mkdir -p cfsan/$iclean"
  mkdir -p cfsan/$iclean
  # Create symlinks to those files in the cfsan/sample subdirectory
  echo "ln -s $r1 $r2 cfsan/$iclean"
  ln -s $r1 $r2 cfsan/$iclean
  echo
done
