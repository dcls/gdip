#!/bin/bash

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
