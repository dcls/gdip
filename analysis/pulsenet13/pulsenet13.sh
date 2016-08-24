#!/bin/bash

################################################################################
## Get some example S Enteritidis data from CDC Pulsenet
################################################################################

## Get some Salmonella Enteritidis data from ENA. 
## This is data from CDC/Pulsenet.
## May want to do this in a screen session while you work on other stuff.

mkdir -p ~/exampledata && cd ~/exampledata

curl -O "ftp.sra.ebi.ac.uk/vol1/fastq/SRR357/008/SRR3573518/SRR3573518_[1-2].fastq.gz"
curl -O "ftp.sra.ebi.ac.uk/vol1/fastq/SRR357/005/SRR3573595/SRR3573595_[1-2].fastq.gz"
curl -O "ftp.sra.ebi.ac.uk/vol1/fastq/SRR357/007/SRR3573617/SRR3573617_[1-2].fastq.gz"
curl -O "ftp.sra.ebi.ac.uk/vol1/fastq/SRR357/006/SRR3573696/SRR3573696_[1-2].fastq.gz"
curl -O "ftp.sra.ebi.ac.uk/vol1/fastq/SRR357/000/SRR3573700/SRR3573700_[1-2].fastq.gz"
curl -O "ftp.sra.ebi.ac.uk/vol1/fastq/SRR357/008/SRR3573778/SRR3573778_[1-2].fastq.gz"
curl -O "ftp.sra.ebi.ac.uk/vol1/fastq/SRR357/009/SRR3573799/SRR3573799_[1-2].fastq.gz"
curl -O "ftp.sra.ebi.ac.uk/vol1/fastq/SRR357/000/SRR3573820/SRR3573820_[1-2].fastq.gz"
curl -O "ftp.sra.ebi.ac.uk/vol1/fastq/SRR357/001/SRR3573841/SRR3573841_[1-2].fastq.gz"
curl -O "ftp.sra.ebi.ac.uk/vol1/fastq/SRR366/004/SRR3669924/SRR3669924_[1-2].fastq.gz"
curl -O "ftp.sra.ebi.ac.uk/vol1/fastq/SRR366/005/SRR3669925/SRR3669925_[1-2].fastq.gz"
curl -O "ftp.sra.ebi.ac.uk/vol1/fastq/SRR366/008/SRR3669928/SRR3669928_[1-2].fastq.gz"
curl -O "ftp.sra.ebi.ac.uk/vol1/fastq/SRR366/009/SRR3669929/SRR3669929_[1-2].fastq.gz"

mv SRR3573518_1.fastq.gz PNUSAS002243_1.fastq.gz ; mv SRR3573518_2.fastq.gz PNUSAS002243_2.fastq.gz
mv SRR3573595_1.fastq.gz PNUSAS002244_1.fastq.gz ; mv SRR3573595_2.fastq.gz PNUSAS002244_2.fastq.gz
mv SRR3573617_1.fastq.gz PNUSAS002245_1.fastq.gz ; mv SRR3573617_2.fastq.gz PNUSAS002245_2.fastq.gz
mv SRR3573696_1.fastq.gz PNUSAS002246_1.fastq.gz ; mv SRR3573696_2.fastq.gz PNUSAS002246_2.fastq.gz
mv SRR3573700_1.fastq.gz PNUSAS002247_1.fastq.gz ; mv SRR3573700_2.fastq.gz PNUSAS002247_2.fastq.gz
mv SRR3573778_1.fastq.gz PNUSAS002249_1.fastq.gz ; mv SRR3573778_2.fastq.gz PNUSAS002249_2.fastq.gz
mv SRR3573799_1.fastq.gz PNUSAS002250_1.fastq.gz ; mv SRR3573799_2.fastq.gz PNUSAS002250_2.fastq.gz
mv SRR3573820_1.fastq.gz PNUSAS002251_1.fastq.gz ; mv SRR3573820_2.fastq.gz PNUSAS002251_2.fastq.gz
mv SRR3573841_1.fastq.gz PNUSAS002252_1.fastq.gz ; mv SRR3573841_2.fastq.gz PNUSAS002252_2.fastq.gz
mv SRR3669924_1.fastq.gz PNUSAS002248_1.fastq.gz ; mv SRR3669924_2.fastq.gz PNUSAS002248_2.fastq.gz
mv SRR3669925_1.fastq.gz PNUSAS002484_1.fastq.gz ; mv SRR3669925_2.fastq.gz PNUSAS002484_2.fastq.gz
mv SRR3669928_1.fastq.gz PNUSAS002485_1.fastq.gz ; mv SRR3669928_2.fastq.gz PNUSAS002485_2.fastq.gz
mv SRR3669929_1.fastq.gz PNUSAS002486_1.fastq.gz ; mv SRR3669929_2.fastq.gz PNUSAS002486_2.fastq.gz

# optionally subset the data?
# find *gz | parallel --dry-run "zcat {} | head -n 1000000 | gzip -c > subset{}"
# rm -f PNUSAS*.fastq.gz
# rename -v 's/subset//g' subset*.fastq.gz

################################################################################
## Run the CFSAN SNP pipeline on the data you downloaded.
################################################################################

## get the scripts you'll need to prepare directories for running cfsan
git clone https://github.com/dcls/gdip
~/gdip/scripts/cfsan-prepare-directories.sh -h

## Set up directory structure
cd ~/exampledata
~/gdip/scripts/cfsan-prepare-directories.sh
cd cfsan

## Run the pipeline. (in a screen session: `screen -S cfsan`, and ctrl-A, D to detach)
# On an m2.2xlarge node (8 cores), this takes ~1hr walltime.
time run_snp_pipeline.sh -m soft -o cfsan-output -s . /opt/genomes/senteritidisp125109.fasta

# See what you've got
cd ~/exampledata/cfsan/cfsan-output
ls -l

# the "samples" directory is huge. remove it if you don't want the alignments, etc.
rm -rf ~/exampledata/cfsan/cfsan-output/samples


################################################################################
## Draw a tree
################################################################################

## Build a tree using generalized time-reversible mode
FastTree -nt -gtr snpma.fasta > snpma.nw

## Transfer this file over and open in FigTree. Or...

## Optionally re-root the tree
nw_reroot snpma.nw PNUSAS002249 > snpma.rerooted.nw

## Render the re-rooted tree showing branch length (sbl) and support (ss)
#  Save the image to a 1800x1200 png file.
#  whatever is passed to -i will be appended to "t0.". 
#  So, if you just pass "-i png", output will be "t0.png".
#  If you passed "-i rerooted.png", output is "t0.rerooted.png"
ete view -t snpma.rerooted.nw --ss --sbl -i png --Iw 1800 --Ih 1200

# Or, just render the default arbitrarily rooted tree in text
ete view -t snpma.nw --text
#    /-PNUSAS002485
#   |
#   |--PNUSAS002486
#   |
#   |   /-PNUSAS002484
# --|  |
#   |  |         /-PNUSAS002244
#   |  |      /-|
#   |  |     |   \-PNUSAS002248
#   |  |     |
#    \-|     |            /-PNUSAS002245
#      |     |         /-|
#      |   /-|      /-|   \-PNUSAS002247
#      |  |  |     |  |
#      |  |  |   /-|   \-PNUSAS002249
#      |  |  |  |  |
#      |  |  |  |  |   /-PNUSAS002243
#       \-|   \-|   \-|
#         |     |      \-PNUSAS002252
#         |     |
#         |      \-PNUSAS002246
#         |
#         |   /-PNUSAS002250
#          \-|
#             \-PNUSAS002251

## Or do it all in one step
FastTree -quiet -nt -gtr snpma.fasta \
  | nw_reroot /dev/stdin PNUSAS002249 \
  | ete view -t /dev/stdin --ss --sbl -i png --Iw 1800 --Ih 1200
## Rerooted rendered tree png file is saved in t0.png


################################################################################
## Run SRST2 for antibiotic resistance for a single sample
################################################################################

cd ~/exampledata

time srst2 --log \
  --input_pe PNUSAS002249_1.fastq.gz PNUSAS002249_2.fastq.gz \
  --output   srst2/PNUSAS002249-amr \
  --gene_db  /home/ubuntu/srst2/data/ARGannot.r1.fasta

# Takes ~3 minutes
# Results in two files:

# full results file: srst2/PNUSAS002249-amr__fullgenes__ARGannot.r1__results.txt
# ------------------------------------------------------------------------------
# Sample  DB  gene  allele  coverage  depth diffs uncertainty divergence  length  maxMAF  clusterid seqid annotation
# PNUSAS002249  ARGannot.r1 Aac6-Iaa_AGly Aac6-Iy_761 100.0 26.435  14snp   3.196 438 0.067 454 761 no;yes;Aac6-Iy;AGly;AF144880;3542-3979;438
# PNUSAS002249  ARGannot.r1 TEM-1D_Bla  TEM-198_1035  100.0 73.332  1snp    0.116 861 0.108 205 1035  no;no;TEM-198;Bla;AB700703;162-1022;861
# ------------------------------------------------------------------------------

# summary results file: srst2/PNUSAS002249-amr__genes__ARGannot.r1__results.txt
# -----------------------------------------------------------------------------
# Sample  Aac6-Iaa_AGly TEM-1D_Bla
# PNUSAS002249  Aac6-Iy_761*  TEM-198_1035*
# -----------------------------------------------------------------------------

# You should be able to concatenate multiple full results files from multiple runs together.


################################################################################
## Run SRST2 for antibiotic resistance for multiple samples
################################################################################

## Get some help
~/gdip/scripts/multisrst2.sh -h

# Running this command will echo the following commands to STDOUT.
~/gdip/scripts/multisrst2.sh
# srst2 --log --input_pe PNUSAS002243_1.fastq.gz PNUSAS002243_2.fastq.gz --output srst2/amr_PNUSAS002243 --gene_db /home/ubuntu/srst2/data/ARGannot.r1.fasta --threads 2
# srst2 --log --input_pe PNUSAS002244_1.fastq.gz PNUSAS002244_2.fastq.gz --output srst2/amr_PNUSAS002244 --gene_db /home/ubuntu/srst2/data/ARGannot.r1.fasta --threads 2
# srst2 --log --input_pe PNUSAS002245_1.fastq.gz PNUSAS002245_2.fastq.gz --output srst2/amr_PNUSAS002245 --gene_db /home/ubuntu/srst2/data/ARGannot.r1.fasta --threads 2
# srst2 --log --input_pe PNUSAS002246_1.fastq.gz PNUSAS002246_2.fastq.gz --output srst2/amr_PNUSAS002246 --gene_db /home/ubuntu/srst2/data/ARGannot.r1.fasta --threads 2
# srst2 --log --input_pe PNUSAS002247_1.fastq.gz PNUSAS002247_2.fastq.gz --output srst2/amr_PNUSAS002247 --gene_db /home/ubuntu/srst2/data/ARGannot.r1.fasta --threads 2
# srst2 --log --input_pe PNUSAS002248_1.fastq.gz PNUSAS002248_2.fastq.gz --output srst2/amr_PNUSAS002248 --gene_db /home/ubuntu/srst2/data/ARGannot.r1.fasta --threads 2
# srst2 --log --input_pe PNUSAS002249_1.fastq.gz PNUSAS002249_2.fastq.gz --output srst2/amr_PNUSAS002249 --gene_db /home/ubuntu/srst2/data/ARGannot.r1.fasta --threads 2
# srst2 --log --input_pe PNUSAS002250_1.fastq.gz PNUSAS002250_2.fastq.gz --output srst2/amr_PNUSAS002250 --gene_db /home/ubuntu/srst2/data/ARGannot.r1.fasta --threads 2
# srst2 --log --input_pe PNUSAS002251_1.fastq.gz PNUSAS002251_2.fastq.gz --output srst2/amr_PNUSAS002251 --gene_db /home/ubuntu/srst2/data/ARGannot.r1.fasta --threads 2
# srst2 --log --input_pe PNUSAS002252_1.fastq.gz PNUSAS002252_2.fastq.gz --output srst2/amr_PNUSAS002252 --gene_db /home/ubuntu/srst2/data/ARGannot.r1.fasta --threads 2
# srst2 --log --input_pe PNUSAS002484_1.fastq.gz PNUSAS002484_2.fastq.gz --output srst2/amr_PNUSAS002484 --gene_db /home/ubuntu/srst2/data/ARGannot.r1.fasta --threads 2
# srst2 --log --input_pe PNUSAS002485_1.fastq.gz PNUSAS002485_2.fastq.gz --output srst2/amr_PNUSAS002485 --gene_db /home/ubuntu/srst2/data/ARGannot.r1.fasta --threads 2
# srst2 --log --input_pe PNUSAS002486_1.fastq.gz PNUSAS002486_2.fastq.gz --output srst2/amr_PNUSAS002486 --gene_db /home/ubuntu/srst2/data/ARGannot.r1.fasta --threads 2

## Pipe to bash to run it (in a GNU screen session)
~/gdip/scripts/multisrst2.sh | bash

## Or write a script
# ~/gdip/scripts/multisrst2.sh > runsrst2.sh
# cat runsrst2.sh
# bash runsrst2.sh

## Compile the output
srst2 --prev_output srst2/*__genes__ARGannot.r1__results.txt --output srst2/srst2

cat srst2/srst2__compiledResults.txt
# Sample          Aac6-Iaa_AGly   TEM-1D_Bla
# PNUSAS002243    Aac6-Iy_761*    -
# PNUSAS002244    Aac6-Iy_761*    -
# PNUSAS002245    Aac6-Iy_761*    -
# PNUSAS002246    Aac6-Iy_761*    -
# PNUSAS002247    Aac6-Iy_761*    -
# PNUSAS002248    Aac6-Iy_761*    -
# PNUSAS002249    Aac6-Iy_761*    TEM-198_1035*
# PNUSAS002250    Aac6-Iy_761*    -
# PNUSAS002251    Aac6-Iy_761*    -
# PNUSAS002252    Aac6-Iy_761*    -
# PNUSAS002484    Aac6-Iy_761*    -
# PNUSAS002485    Aac6-Iy_761*    -
# PNUSAS002486    Aac6-Iy_761*    -

################################################################################
## SRST2 for MLST for a single sample
################################################################################

cd ~/exampledata

time srst2 --log \
  --input_pe PNUSAS002249_1.fastq.gz PNUSAS002249_2.fastq.gz \
  --output srst2/PNUSAS002249-mlst \
  --mlst_db          /opt/genomes/mlst_senterica/Salmonella_enterica.fasta \
  --mlst_definitions /opt/genomes/mlst_senterica/senterica.txt \
  --mlst_delimiter '-'

# Takes about 15 minutes
# Results file: srst2/PNUSAS002249-mlst__mlst__Salmonella_enterica__results.txt
# -----------------------------------------------------------------------------
# Sample  ST      aroC    dnaN    hemD    hisD    purE    sucA    thrA    mismatches      uncertainty     depth   maxMAF
# PNUSAS002249    11?     5       2?      3       7       6       6       11      0       dnaN-2/edge2.0  20.4158571429   0.333333333333
# -----------------------------------------------------------------------------


## You could extend multisrst2.sh to incorporate BOTH AMR and MLST.
## https://github.com/katholt/srst2#running-lots-of-jobs-and-compiling-results
