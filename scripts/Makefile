MLST_REF := Salmonella_enterica
DATE := $(shell date +%F)

all: ./cfsan/*/*_[12].fastq ./cfsan-output/snpma.fasta ./treefile.nwk ./srst2/amr/*__fullgenes__ARGannot.r1__results.txt ./srst2/mlst/*__mlst__${MLST_REF}__results.txt ./gdip_results_${DATE}/* ./gdip_results_${DATE}/treefile.nwk ./gdip_results_${DATE}/*ARGannot.r1__results.txt ./gdip_results_${DATE}/*__mlst__${MLST_REF}__results.txt ./gdip_results_${DATE}.zip

tree-only: ./cfsan/*/*_[12].fastq ./cfsan-output/snpma.fasta ./treefile.nwk ./gdip_results_${DATE}/treefile.nwk ./gdip_results_${DATE}.zip

amr: ./srst2/amr/*__fullgenes__ARGannot.r1__results.txt ./gdip_results_${DATE}/*ARGannot.r1__results.txt ./gdip_results_${DATE}.zip

mlst: ./srst2/mlst/*__mlst__${MLST_REF}__results.txt ./gdip_results_${DATE}/*__mlst__${MLST_REF}__results.txt ./gdip_results_${DATE}.zip


clean: 
	sudo rm -r cfsan/ cfsan-output/ srst2/ treefile.nwk gdip_results_${DATE}.zip

.PHONY: all clean

# Organize data into CFSAN-SNP-friendly directories
./cfsan/*/*_[12].fastq: *[_R]1.fastq.gz
	cfsan-prepare-directories.sh 

# Run CFSAN SNP Pipeline to generate snp-distance matrix
./cfsan-output/snpma.fasta: ./cfsan/*/*_[12].fastq
	cfsan-snp.sh 

# Run FastTree to generate phylogeny tree
./treefile.nwk: ./cfsan-output/snpma.fasta
	FastTree -gtr -nt ./cfsan-output/snpma.fasta > ./treefile.nwk
 
# Run SRST2 to generate AMR gene report
./srst2/amr/*__fullgenes__ARGannot.r1__results.txt: *[_R]1.fastq.gz
	multisrst2.sh | bash

# Run SRST2 to generate MLST report
./srst2/mlst/*__mlst__${MLST_REF}__results.txt: *[_R]1.fastq.gz
	mlstsrst2.sh | bash

# Create directory for final report
./gdip_results_${DATE}/*:
	mkdir ./gdip_results_${DATE}/

# Add snp-distance martix to final report directory
./gdip_results_${DATE}/cfsan-snp/snpma.fasta: ./cfsan-output/snpma.fasta ./gdip_results_${DATE} 
	ln -s $(shell pwd)/csfan-output/snpma.fasta ./gdip_results_${DATE}
	
# Add tree to final report directory
./gdip_results_${DATE}/treefile.nwk: treefile.nwk ./gdip_results_${DATE}/cfsan-snp/snpma.fasta
	ln -s $(shell pwd)/treefile.nwk ./gdip_results_${DATE}

# Add srst2 AMR to final report directory
./gdip_results_${DATE}/*ARGannot.r1__results.txt: srst2/amr/*__fullgenes__ARGannot.r1__results.txt
	ln -s $(shell pwd)/srst2/amr/*__fullgenes__ARGannot.r1__results.txt ./gdip_results_${DATE}

# Add srst2 MLST to final report directory
./gdip_results_${DATE}/*__mlst__${MLST_REF}__results.txt: ./srst2/mlst/*__mlst__${MLST_REF}__results.txt
	 ln -s $(shell pwd)/srst2/mlst/*__mlst__${MLST_REF}__results.txt ./gdip_results_${DATE}

# Compress final report for sharing
./gdip_results_${DATE}.zip: ./gdip_results_${DATE}/*
	zip -r $@ ./gdip_results_${DATE}/*

