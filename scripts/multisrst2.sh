#!/bin/bash

# See help below.
THREADS=$(nproc)
GENE_DB="$HOME/srst2/data/ARGannot.r1.fasta"


HELP="
Assumes a directory with paired fastq files ending in either
_1.fastq.gz and _2.fastq.gz or R1.fastq.gz and R2.fastq.gz.

Running this in the directory with so-named fastq files will echo to 
the STDOUT the commands needed to run SRST2 for antibiotic resistance.

Pipe this output to |sh to run those commands, or save to a script.

The gene database is its default location in the home directory.
The number of threads to be used is taken from the nproc command
but can be overridden by modifying the script.

E.g., running this script in a directory with _1 and _2.fastq.gz files:

$ ls
samp1_1.fastq.gz
samp1_2.fastq.gz
samp2_1.fastq.gz
samp2_2.fastq.gz
samp3_1.fastq.gz
samp3_2.fastq.gz

Will echo these commands out to the STDOUT....

$ multisrst2.sh
srst2 --log --input_pe samp1_1.fastq.gz samp1_2.fastq.gz --output srst2/amr_samp1 --gene_db /home/ubuntu/srst2/data/ARGannot.r1.fasta --threads 2
srst2 --log --input_pe samp2_1.fastq.gz samp2_2.fastq.gz --output srst2/amr_samp2 --gene_db /home/ubuntu/srst2/data/ARGannot.r1.fasta --threads 2
srst2 --log --input_pe samp3_1.fastq.gz samp3_2.fastq.gz --output srst2/amr_samp3 --gene_db /home/ubuntu/srst2/data/ARGannot.r1.fasta --threads 2

...Pipe to |bash to run them...

# Preview what you'll do:
multisrst2.sh 
# Actually run it
multisrst2.sh | bash

... or save to a script, preview the script, then run the script.

multisrst2.sh > runsrst2.sh
cat runsrst2.sh
bash runsrst2.sh
"

# If the user invokes the script with -h, print some help.
if [ "$1" == "-h" ]; then
	echo "$HELP"
  exit 0
fi

# For all pairs of fastq files
for i in *[_R]1.fastq.gz
do
  # Strip off the _1.fastq.gz to get just the sample name
  i=$(echo $i | sed 's/1\.fastq\.gz//g')
  # Strip off any other remaining cruft
  iclean=$(echo $i | sed 's/[R_]$//g')
  # These are the full paths to the _1 and _2 read pair files
  # r1="$(readlink -f ${i}1.fastq.gz)"
  # r2="$(readlink -f ${i}2.fastq.gz)"
  r1=${i}1.fastq.gz
  r2=${i}2.fastq.gz
  echo "srst2 --log --input_pe $r1 $r2 --output srst2/amr_$iclean --gene_db $GENE_DB --threads $THREADS"
done

