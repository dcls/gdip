#!/bin/bash

# CFSAN SNP pipeline + dependencies installation script for a fresh Ubuntu 14.04 instance.

################################################################################
## Conveniences
################################################################################

# Some essential aliases
echo "alias rm='rm -i'" >> ~/.bash_profile
echo "alias mv='mv -i'" >> ~/.bash_profile
echo "alias cp='cp -i'" >> ~/.bash_profile
echo "alias l='ls -lhGgo --color=always'" >> ~/.bash_profile
echo "alias u='cd ..; l'" >> ~/.bash_profile
echo "alias du='du -h --max-depth=1'" >> ~/.bash_profile
echo "alias sls='screen -ls'" >> ~/.bash_profile
echo "alias sdr='screen -dr'" >> ~/.bash_profile
echo "alias ss='screen -S'" >> ~/.bash_profile
echo "alias top='htop'" >> ~/.bash_profile
echo "alias hgrep='history | grep'" >> ~/.bash_profile
echo 'export VISUAL=vim' >> ~/.bash_profile
echo 'export EDITOR="$VISUAL"' >> ~/.bash_profile
source ~/.bash_profile

# Turn off GNU screen startup message
echo "startup_message off" >> ~/.screenrc
echo 'shell -$SHELL' >> ~/.screenrc


################################################################################
## apt
################################################################################

## Update existing software
# apt-get update will update the list of available packages and their versions, 
# but it does not install/upgrade.
sudo apt-get -y update

# apt-get upgrade actually installs newer versions of the packages you have. 
# After updating the lists, the package manager knows about available updates 
# for the software you have installed. This is why you first want to update.
sudo apt-get -y upgrade

# install some essentials
sudo apt-get -y install build-essential gcc make cmake ruby curl git vim parallel unzip default-jre
sudo apt-get -y install zlib1g-dev libxml2-dev libcurl4-openssl-dev 
sudo apt-get -y install libcurl4-gnutls-dev libssl-dev
sudo apt-get -y install tree htop mosh firefox pandoc


################################################################################
## conda/bioconda
################################################################################

## Get miniconda, and install numpy, scipy, matplotlib
wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
bash Miniconda2-latest-Linux-x86_64.sh
rm -f Miniconda2-latest-Linux-x86_64.sh
echo 'export PATH="$HOME/miniconda2/bin:$PATH"' >> .bash_profile
source ~/.bash_profile
conda install -y numpy scipy matplotlib

## Add r and bioconda channels. See docs at: https://bioconda.github.io/
conda config --add channels r
conda config --add channels bioconda
conda install -y htslib samtools bcftools sra-tools bowtie2 varscan

# For CFSAN SNP pipeline, set the CLASSPATH environment variable as described here: 
# http://snp-pipeline.readthedocs.io/en/latest/installation.html#step-3-environment-variables
echo "export CLASSPATH=$(find $HOME/miniconda2/share/ -type f -name VarScan.jar):\$CLASSPATH" >> ~/.bash_profile

# Others that are probably useful.
conda install -y blast bedtools fasttree ete2 fastqc

# Install biopython (required by CFSAN SNP pipeline)
conda install -y -c anaconda biopython=1.67


################################################################################
## Install CFSAN-SNP pipeline
################################################################################

pip install --upgrade pip
pip install --user snp-pipeline
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bash_profile
source .bash_profile
which run_snp_pipeline.sh


################################################################################
## Other useful stuff
################################################################################

## Newick utilities?
# wget http://cegg.unige.ch/pub/newick-utils-1.6-Linux-x86_64-disabled-extra.tar.gz

## Get shell integration for iterm2, but first fix curl cert issue
echo 'capath=/etc/ssl/certs/' >> .curlrc
echo 'cacert=/etc/ssl/certs/ca-certificates.crt' >> .curlrc
curl -L https://iterm2.com/misc/install_shell_integration_and_utilities.sh | bash

## Get AWS command line interface
pip install awscli

## gargs: https://github.com/brentp/gargs#readme
sudo wget -O /usr/local/bin/gargs https://github.com/brentp/gargs/releases/download/v0.3.1/gargs_linux && sudo chmod 755 /usr/local/bin/gargs
gargs -h

################################################################################
## Get reference genome fasta files
################################################################################

# >NC_011294.1 Salmonella enterica subsp. enterica serovar Enteritidis str. P125109 complete genome
sudo mkdir -p /opt/genomes
echo "curl -s ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF_000009505.1_ASM950v1/GCF_000009505.1_ASM950v1_genomic.fna.gz | gzip -dc > /opt/genomes/senteritidisp125109.fasta" | sudo sh


################################################################################
## Get some example S Enteritidis data
################################################################################

## Get some Salmonella Enteritidis data from ENA to play with. 
## This is data from CDC/Pulsenet.
## May want to do this in a screen session while you work on other stuff.

mkdir -p ~/exampledata && cd $_

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


################################################################################
## Run the CFSAN SNP pipeline on the data you downloaded.
################################################################################

cd ~/exampledata
~/scripts/cfsan-prepare-directories.sh
cd cfsan
tree
# in a screen session:
# screen -S cfsan
time run_snp_pipeline.sh -m soft -o cfsan-output -s . /opt/genomes/senteritidisp125109.fasta
# ctrl-A, D

################################################################################
## Optional: iterm2 shell integration, AWS CLI, etc.
################################################################################

# Get shell integration for iterm2, but first fix curl cert issue
echo 'capath=/etc/ssl/certs/' >> .curlrc
echo 'cacert=/etc/ssl/certs/ca-certificates.crt' >> .curlrc
curl -L https://iterm2.com/misc/install_shell_integration_and_utilities.sh | bash

# Get AWS command line interface
pip install awscli


################################################################################
## Install R
################################################################################

# See guide at https://www.digitalocean.com/community/tutorials/how-to-set-up-r-on-ubuntu-14-04

# Set up apt
sudo sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list'
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -

# Install R
sudo apt-get update
sudo apt-get -y install r-base

# Set up devtools
sudo apt-get -y install libcurl4-gnutls-dev libxml2-dev libssl-dev
sudo su - -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"devtools::install_github('stephenturner/annotables')\""

# Install packages
sudo su - -c "R -e \"install.packages('dplyr', repos = 'http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('tidyr', repos = 'http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('readr', repos = 'http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('stringr', repos = 'http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('ggplot2', repos = 'http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('ape', repos = 'http://cran.rstudio.com/')\""


################################################################################
## Install SRST2 and dependencies
################################################################################

## Make a directory to put specific software versions needed by SRST2
sudo mkdir -p /opt/software

## get an old bowtie2
wget http://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.2.4/bowtie2-2.2.4-linux-x86_64.zip
unzip bowtie2-2.2.4-linux-x86_64.zip
sudo mv bowtie2-2.2.4 /opt/software/
rm -f bowtie2-2.2.4-linux-x86_64.zip

## get an old samtools
wget http://downloads.sourceforge.net/project/samtools/samtools/0.1.18/samtools-0.1.18.tar.bz2
tar -xjvf samtools-0.1.18.tar.bz2
cd samtools-0.1.18 && make && cd ..
sudo mv samtools-0.1.18 /opt/software/
rm -f samtools-0.1.18.tar.bz2

## put this in ~/.bash_profile:
echo "export SRST2_SAMTOOLS=/opt/software/samtools-0.1.18/samtools" >> ~/.bash_profile
echo "export SRST2_BOWTIE2=/opt/software/bowtie2-2.2.4/bowtie2" >> ~/.bash_profile
echo "export SRST2_BOWTIE2_BUILD=/opt/software/bowtie2-2.2.4/bowtie2-build" >> ~/.bash_profile
source ~/.bash_profile

## install SRST2
pip install srst2/
srst2 --version

# download an mlst database
mkdir mlst_senterica
cd mlst_senterica
getmlst.py --species "Salmonella enterica"
cd ..
sudo mv mlst_senterica /opt/genomes


################################################################################
## Run SRST2 on a few samples
################################################################################

cd ~/exampledata

# MLST search
time srst2 --input_pe PNUSAS002249_1.fastq.gz PNUSAS002249_2.fastq.gz --output srst2/PNUSAS002249-mlst --log --mlst_db /opt/genomes/mlst_senterica/Salmonella_enterica.fasta --mlst_definitions /opt/genomes/mlst_senterica/senterica.txt --mlst_delimiter '-'

# AMR search
time srst2 --input_pe PNUSAS002249_1.fastq.gz PNUSAS002249_2.fastq.gz --output srst2/PNUSAS002249-amr  --log --gene_db ~/srst2/data/ARGannot.r1.fasta


################################################################################
## Optional: create a public AWS AMI
################################################################################

# If you want to create/share an AMI, there's some housecleaning to do.

## Update/upgrade
sudo apt-get -y update && sudo apt-get -y upgrade

# Do you want to allow a password login? Potentially unsecure, but easy for sharing.
# Allow password login vim /etc/cloud/cloud.cfg http://stackoverflow.com/a/28080326/654296
# sudo passwd # set to 'ubuntu'
# sudo sh -c 'sed -i "s/lock_passwd: True/lock_passwd: False/" /etc/cloud/cloud.cfg'
# sudo sh -c 'sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config'
# sudo service ssh restart

## Disable local root access
sudo passwd -l root

## Remove SSH Host Key Pairs
# If you plan to share an AMI derived from a public AMI, remove the existing SSH
# host key pairs located in /etc/ssh. This forces SSH to generate new unique SSH
# key pairs when someone launches an instance using your AMI, improving security
# and reducing the likelihood of "man-in-the-middle" attacks.
sudo shred -u /etc/ssh/*_key /etc/ssh/*_key.pub
sudo find / -name "authorized_keys" -exec rm -f {} \;

# Remove all shell history
history -w
history -c
shred -u ~/.*history
sudo find /root/.*history /home/*/.*history -exec rm -f {} \;
history -w
history -c

# Shut it down and create an image.
sudo poweroff
