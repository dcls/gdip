SAMPLES := $(wildcard [$(shell find *_1.fastq.gz | cut -f1 -d_ | paste -s -d ',')])
MLST_REF := Salmonella_enterica
DATE := $(shell date +%F)

all: ./cfsan/${SAMPLES}/ ./treefile.nwk ./srst2/amr/*__fullgenes__ARGannot.r1__results.txt ./srst2/mlst/*__results.txt ./*-gdip-report/treefile.nwk ./*-gdip-report/srst2/amr ./*-gdip-report/srst2/mlst ./*-gdip-report.zip

tree-only: ./cfsan/${SAMPLES}/ ./treefile.nwk ./*-gdip-report/treefile.nwk ./*-gdip-report.zip

amr: ./srst2/amr/*__fullgenes__ARGannot.r1__results.txt ./*-gdip-report/srst2/amr ./*-gdip-report.zip

mlst: ./srst2/mlst/*__results.txt ./*-gdip-report/srst2/mlst ./*-gdip-report.zip

clean: 
	sudo rm -r ./cfsan/ ./cfsan-output/ ./treefile.nwk ./srst2/ ./*-gdip-report*

.PHONY: all tree-only amr mlst clean

# Organize data into CFSAN-SNP-friendly directories
./cfsan/${SAMPLES}/: *[_R]1.fastq.gz
	cfsan-prepare-directories.sh

# Run CFSAN SNP Pipeline to generate snp-distance matrix
./cfsan-output/snpma.fasta: ./cfsan/${SAMPLES}/
	cfsan-snp.sh

# Run FastTree to generate phylogeny tree
./treefile.nwk: ./cfsan-output/snpma.fasta
	FastTree -gtr -nt ./cfsan-output/snpma.fasta > ./treefile.nwk

# Run SRST2 to generate AMR gene report
./srst2/amr/*__fullgenes__ARGannot.r1__results.txt: *[_R]1.fastq.gz
	multisrst2.sh | bash

# Run SRST2 to generate MLST report
./srst2/mlst/*__results.txt: *[_R]1.fastq.gz
	mlstsrst2.sh | bash

# Create directory for final report, add matrix and tree
./*-gdip-report/treefile.nwk: ./cfsan-output/snpma.fasta ./treefile.nwk 
	mkdir ./${DATE}-gdip-report/ 
	ln -s $(shell pwd)/cfsan-output/snpma.fasta ./${DATE}-gdip-report/
	ln -s $(shell pwd)/treefile.nwk ./${DATE}-gdip-report/

# Add SRST@ AMR to final report
./*-gdip-report/srst2/amr: ./srst2/amr/*__fullgenes__ARGannot.r1__results.txt
	mkdir -p ./${DATE}-gdip-report/srst2/amr
	ln -s $(shell pwd)/srst2/amr/*__fullgenes__ARGannot.r1__results.txt ./${DATE}-gdip-report/srst2/amr

# Add SRST2 MLST to final report
./*-gdip-report/srst2/mlst: ./srst2/mlst/*__results.txt
	mkdir -p ./${DATE}-gdip-report/srst2/mlst
	ln -s $(shell pwd)/srst2/mlst/*__results.txt ./${DATE}-gdip-report/srst2/mlst

# Compress final report for sharing
./*-gdip-report.zip: ./*-gdip-report/treefile.nwk
	zip -r ./${DATE}-gdip-report.zip ./${DATE}-gdip-report
