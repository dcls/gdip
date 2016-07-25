#!/bin/bash

# Nullarbor+dependencies installation script for a fresh Ubuntu 14.04 instance.

# This script is meant to be run interactively. It installs nullarbor, all its
# dependencies, and the CFSAN SNP pipeline. It also downloads some data from
# SRA/Genometrackr, and runs both pipelines on this example data.

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
sudo apt-get -y install build-essential gcc make cmake ruby curl git vim parallel unzip firefox default-jre zlib1g-dev libxml2-dev libcurl4-openssl-dev

# further required by Roary, which is required by nullarbor
sudo apt-get -y install bedtools cd-hit ncbi-blast+ mcl cpanminus prank mafft fasttree

# nullarbor dependencies
sudo apt-get -y install libexpat1-dev pandoc

# others
sudo apt-get -y install tree htop mosh 


################################################################################
## Get some data
################################################################################

# Below you'll be installing some perl modules, homebrew formulae, and others.
# Some of this takes a *long* time. Meanwhile, download a Salmonella Enteritidis
# reference genome, a kraken database, and some data from the FDA genometrackr
# project to play with. You'll probably want to run this in a GNU screen.

screen -S data

## Get a reference genome: 
# >NC_011294.1 Salmonella enterica subsp. enterica serovar Enteritidis str. P125109 complete genome
sudo mkdir -p /opt/genomes
echo "curl -s ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF_000009505.1_ASM950v1/GCF_000009505.1_ASM950v1_genomic.fna.gz | gzip -dc > /opt/genomes/senteritidisp125109.fa" | sudo sh

## Kraken data
wget https://ccb.jhu.edu/software/kraken/dl/minikraken.tgz
sudo tar -C /opt -zxvf minikraken.tgz
# set where you want it to go in your bash_profile, the source it so you actually set.
echo "export KRAKEN_DEFAULT_DB=/opt/minikraken_20141208" >> ~/.bash_profile
source ~/.bash_profile
ls $KRAKEN_DEFAULT_DB
rm -f minikraken.tgz

## Get some Salmonella Enteritidis data from ENA to play with. 
## Change -P to something >1 if want to do in parallel.
mkdir -p ~/genometrackr && cd $_
echo ftp.sra.ebi.ac.uk/vol1/fastq/SRR120/000/SRR1207440/SRR1207440_1.fastq.gz \
     ftp.sra.ebi.ac.uk/vol1/fastq/SRR120/000/SRR1207440/SRR1207440_2.fastq.gz \
     ftp.sra.ebi.ac.uk/vol1/fastq/SRR120/000/SRR1207460/SRR1207460_1.fastq.gz \
     ftp.sra.ebi.ac.uk/vol1/fastq/SRR120/000/SRR1207460/SRR1207460_2.fastq.gz \
     ftp.sra.ebi.ac.uk/vol1/fastq/SRR120/001/SRR1207461/SRR1207461_1.fastq.gz \
     ftp.sra.ebi.ac.uk/vol1/fastq/SRR120/001/SRR1207461/SRR1207461_2.fastq.gz \
     ftp.sra.ebi.ac.uk/vol1/fastq/SRR120/008/SRR1207468/SRR1207468_1.fastq.gz \
     ftp.sra.ebi.ac.uk/vol1/fastq/SRR120/008/SRR1207468/SRR1207468_2.fastq.gz \
     ftp.sra.ebi.ac.uk/vol1/fastq/SRR120/003/SRR1207483/SRR1207483_1.fastq.gz \
     ftp.sra.ebi.ac.uk/vol1/fastq/SRR120/003/SRR1207483/SRR1207483_2.fastq.gz \
     ftp.sra.ebi.ac.uk/vol1/fastq/SRR120/005/SRR1207515/SRR1207515_1.fastq.gz \
     ftp.sra.ebi.ac.uk/vol1/fastq/SRR120/005/SRR1207515/SRR1207515_2.fastq.gz \
     | xargs -n 1 -P 1 wget -q

# Ctrl-a, d: to detach this screen here.

################################################################################
## Perl
################################################################################

## Install & test Bioperl
sudo cpan -f -i Bio::Perl
perl -MBio::Perl -e 1
perl -MBio::Root::Version -le 'print $Bio::Root::Version::VERSION'

## Install & test Roary
sudo cpan -f -i Bio::Roary
perl -MBio::Roary -e 1

## Other nullarbor dependencies
## The first/third lines test to see if you have the module installed.
## If the first line fails, install with cpan, then test again.

perl -MTime::Piece -e 1
# sudo cpan -f -i Time::Piece
perl -MTime::Piece -e 1

perl -MData::Dumper -e 1
# sudo cpan -f -i Data::Dumper
perl -MData::Dumper -e 1

perl -MFile::Copy -e 1
# sudo cpan -f -i File::Copy
perl -MFile::Copy -e 1

perl -MMoo -e 1
sudo cpan -f -i Moo
perl -MMoo -e 1

perl -MSpreadsheet::Read -e 1
sudo cpan -f -i Spreadsheet::Read
perl -MSpreadsheet::Read -e 1

perl -MYAML::Tiny -e 1
sudo cpan -f -i YAML::Tiny
perl -MYAML::Tiny -e 1

perl -MXML::Simple -e 1
sudo cpan -f -i XML::Simple
perl -MXML::Simple -e 1

perl -MFile::Slurp -e 1
sudo cpan -f -i File::Slurp
perl -MFile::Slurp -e 1

perl -MSVG -e 1
sudo cpan -f -i SVG
perl -MSVG -e 1


################################################################################
## Linuxbrew
################################################################################

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
echo 'export PATH="$HOME/.linuxbrew/bin:$PATH"' >>~/.bash_profile
echo 'export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"' >>~/.bash_profile
echo 'export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"' >>~/.bash_profile
source ~/.bash_profile

brew tap homebrew/science
brew tap chapmanb/cbl
brew tap tseemann/bioinformatics-linux
brew install curl 
brew install cairo --with-x11 
brew install blast
brew install vcflib

# You should also install vcftools, but you'll need the perl module or
# else you'll get the "can't find Vcf.pm in @INC" error. So bash_profile it.
brew install vcftools
echo 'export PERL5LIB=$HOME/.linuxbrew/lib/perl5/site_perl:${PERL5LIB}' >> ~/.bash_profile
source ~/.bash_profile


################################################################################
## LOL Freebayes
################################################################################

# Congrats on making it this far. Now you're in for a real treat.
# Freebayes is a PITA. The version in homebrew won't compile.
# if `brew install whatever` this doesn't work, try this hack. 
# get binaries or `make` the software yourself, then copy everything to 
# HOMEBREW_PREFIX/Cellar/whatever/v1.0.0/ then `brew link whatever`.

# First try `brew install freebayes`. If fails (and it will), do this:
cd ~
git clone --recursive git://github.com/ekg/freebayes.git
cd freebayes
make

# At some point you'll get an error in freebayes-parallel about not being able
# to find vcffirstheader or vcfstreamsort. Make sure these are in your path.
# They should have been installed and in your path if you `brew install vcflib`.
# Then strip out the relative path reference and just call the bare program by name.
# These should have been compiled in brew vcflib above. 
cd ~/freebayes/scripts
sed -i 's/\.\.\/vcflib\/\(scripts\|bin\)\///g' freebayes-parallel
git diff
# git diff will show:
# -) | ../vcflib/scripts/vcffirstheader \
# -    | ../vcflib/bin/vcfstreamsort -w 1000 | vcfuniq # remove duplicates at region edges
# +) | vcffirstheader \
# +    | vcfstreamsort -w 1000 | vcfuniq # remove duplicates at region edges

# Now copy freebayes-parallel and other scripts into the bin, because this is
# the only directory that'll get linked when you brew link it.
cd ~/freebayes
cp scripts/* bin/
export FREEBAYES_VERSION=$(bin/freebayes --version | awk '{print $2}')
echo $FREEBAYES_VERSION
mkdir -p $HOME/.linuxbrew/Cellar/freebayes/$FREEBAYES_VERSION
cp -r ~/freebayes/* $HOME/.linuxbrew/Cellar/freebayes/$FREEBAYES_VERSION
brew link freebayes

# Check everything.
which freebayes
which freebayes-parallel
cat $(which freebayes-parallel)
which vcffirstheader
which vcfstreamsort

# Optionally, remove the freebayes cruft in your home.
# rm -rf ~/freebayes

# Now, snippy depends on freebayes. Not anymore.
brew edit snippy
# comment out "depends_on "freebayes"


################################################################################
## Install nullarbor
################################################################################

# Install nullarbor
brew install nullarbor --HEAD

# Setup up a prokka database
prokka --setupdb

# Turn off GNU parallel's message before you try running it in a script.
parallel --citation


################################################################################
## Try running it on the data you downloaded.
################################################################################

# You're going to need a computer with multiple processors and a good bit of
# RAM, for the assembly. Make sure to generate the makefile on this computer.
# The CPUS variable is set in the makefile, and if CPUS=1, megahit will fail,
# telling you that you need at least 2 CPUS.

# Make a tab-delimited samplesheet with sample name (SRR ID), and fastq files
cd ~/genometrackr
find *gz | sort | paste - - | perl -pe 's/((^SRR\d+).*)/$2\t$1/g' > samples.tab

# Set up the makefile
nullarbor.pl --name TestingNullarbor --mlst senterica --ref /opt/genomes/senteritidisp125109.fa --input samples.tab --outdir nullarbor --force

# You're going to run into an error with prokka with errors that look like:
# Contig ID must <= 20 chars long: gnl|X|SRR1207440_contig000001
# Please rename your contigs or use --centre XXX to generate clean contig names.
# See issue referenced at: https://github.com/tseemann/nullarbor/issues/81
# Hackjob solution is to modify the prokka commands to shorten the locustag name.
sed -i 's/locustag SRR[0-9]*/locustag x/g' nullarbor/Makefile

# Run it!
nice make -j 1 -C /home/ubuntu/genometrackr/nullarbor


################################################################################
## Optional: Also install anaconda python and the FDA CFSAN SNP pipeline
################################################################################

# You're close enough already. Go ahead and install the FDA CFSAN-SNP pipeline.

# a better python
wget http://repo.continuum.io/archive/Anaconda2-4.0.0-Linux-x86_64.sh
bash Anaconda2-4.0.0-Linux-x86_64.sh
echo 'export PATH="$HOME/anaconda2/bin:$PATH"' >> .bash_profile
source ~/.bash_profile
which python

# depends on a few more tools
brew install bowtie2 sratoolkit bcftools

# Varscan
wget http://downloads.sourceforge.net/project/varscan/VarScan.v2.3.9.jar
sudo mkdir /opt/software
sudo mv VarScan.v2.3.9.jar /opt/software/
echo 'export CLASSPATH=/opt/software/VarScan.v2.3.9.jar:$CLASSPATH' >> ~/.bash_profile

# biopython
conda install -c anaconda biopython=1.67

# Install the SNP pipeline
pip install --user snp-pipeline
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bash_profile
source .bash_profile
which run_snp_pipeline.sh


################################################################################
## Optional: Run the CFSAN SNP pipeline on the data you downloaded.
################################################################################

cd ~/genometrackr
find *_1.fastq.gz | cut -f1 -d_ | xargs -i echo 'mkdir -p cfsan/{}; ln -s $(readlink -f {}_[12].fastq.gz) cfsan/{}'
!! | sh
cd cfsan
run_snp_pipeline.sh -m soft -o cfsan-output -s . /opt/genomes/senteritidisp125109.fa

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
