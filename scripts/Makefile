SAMPLES := $(wildcard [$(shell find *_1.fastq.gz | cut -f1 -d_ | paste -s -d ',')])
REF_GENOME := /opt/genomes/senteritidisp125109.fasta
MLST_REF := Salmonella_enterica
DATE := $(shell date +%F)

all: ./cfsan/${SAMPLES}/ ./treefile.nwk ./srst2/amr/*__fullgenes__ARGannot.r1__results.txt ./srst2/mlst/*__results.txt ./${DATE}-gdip-report/treefile.nwk ./${DATE}-gdip-report/srst2/amr ./${DATE}-gdip-report/srst2/mlst ./${DATE}-gdip-report.zip

tree-only: ./cfsan/${SAMPLES}/ ./treefile.nwk ./${DATE}-gdip-report/treefile.nwk ./${DATE}-gdip-report.zip

amr: ./srst2/amr/*__fullgenes__ARGannot.r1__results.txt ./${DATE}-gdip-report/srst2/amr ./${DATE}-gdip-report.zip

mlst: ./srst2/mlst/*__results.txt ./${DATE}-gdip-report/srst2/mlst ./${DATE}-gdip-report.zip

clean: 
	rm -rf ./cfsan/ ./cfsan-output/ ./treefile.nwk ./srst2/ ./${DATE}-gdip-report*

space:
	rm -rf ./cfsan-output/samples/*/*.[sb]am ./srst2/*/*{pileup,bam}

.PHONY: all tree-only amr mlst clean

# Organize data into CFSAN-SNP-friendly directories
./cfsan/${SAMPLES}/: *[_R]1.fastq.gz
	cfsan-prepare-directories.sh

# Create directory for final report, add tree, matrix fasta/pairwise/distance, and metrics
./${DATE}-gdip-report: *[_R]1.fastq.gz
	mkdir -p ./${DATE}-gdip-report/ 

# Run CFSAN SNP Pipeline to generate snp-distance matrix
./cfsan-output/snpma.fasta: ./cfsan/${SAMPLES}/
	run_snp_pipeline.sh -m soft -o cfsan-output -s ./cfsan ${REF_GENOME}

# Run FastTree to generate phylogeny tree
./treefile.nwk: ./cfsan-output/snpma.fasta
	FastTree -gtr -nt ./cfsan-output/snpma.fasta > ./treefile.nwk

# Run SRST2 to generate AMR gene report
./srst2/amr/*__fullgenes__ARGannot.r1__results.txt: *[_R]1.fastq.gz
	multisrst2.sh | bash

# Run SRST2 to generate MLST report
./srst2/mlst/*__results.txt: *[_R]1.fastq.gz
	mlstsrst2.sh | bash

# Create directory for final report, add tree, matrix fasta/pairwise/distance, and metrics
./${DATE}-gdip-report/treefile.nwk: ./treefile.nwk ${DATE}-gdip-report
	cp treefile.nwk cfsan-output/metrics.tsv cfsan-output/snpma.fasta cfsan-output/snp_distance_matrix.tsv cfsan-output/snp_distance_pairwise.tsv ./${DATE}-gdip-report/

# Add SRST@ AMR to final report
./${DATE}-gdip-report/srst2/amr: ./srst2/amr/*__fullgenes__ARGannot.r1__results.txt
	mkdir -p ./${DATE}-gdip-report/srst2/amr
	cp $(shell pwd)/srst2/amr/*__fullgenes__ARGannot.r1__results.txt ./${DATE}-gdip-report/srst2/amr

# Add SRST2 MLST to final report
./${DATE}-gdip-report/srst2/mlst: ./srst2/mlst/*__results.txt
	mkdir -p ./${DATE}-gdip-report/srst2/mlst
	cp $(shell pwd)/srst2/mlst/*__results.txt ./${DATE}-gdip-report/srst2/mlst

# Compress final report for sharing
./${DATE}-gdip-report.zip: ./${DATE}-gdip-report
	zip -r ./${DATE}-gdip-report.zip ./${DATE}-gdip-report
