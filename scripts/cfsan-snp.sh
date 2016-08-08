#!/bin/bash

REF_GENOME="/opt/genomes/senteritidisp125109.fasta"

HELP="
Assumes paired fastq.gz reads are organized with a top-level 'cfsan' directory, with subdirectories for each sample name.

i.e.:

$ tree .
|-- cfsan
|   |-- samp1
|   |   |-- samp1_1.fastq.gz
|   |   |-- samp1_2.fastq.gz
|   |-- samp2
|   |   |-- samp2_1.fastq.gz
|   |   |-- samp2_2.fastq.gz
|   |-- samp3
|   |   |-- samp3_1.fastq.gz
|   |   |-- samp3_2.fastq.gz

If reads are not organized in this structure, run:
$ cfsan-prepare-directories.sh

Running cfsan-snp.sh in the directory with the organized read files will run the CFSAN-SNP pipeline, mirror the input samples and reference file and write all output to ./cfsan-output.
"

# If the user invokes the script with -h or any command line arguments, print some help.
if [ "$#" -ne 0 ] || [ "$1" == "-h" ] ; then
  echo "$HELP"
  exit 0
fi


# For all samples
for i in cfsan/*/*_[12].fastq
do
  run_snp_pipeline.sh -m soft -o cfsan-output -s ./cfsan $REF_GENOME
done
