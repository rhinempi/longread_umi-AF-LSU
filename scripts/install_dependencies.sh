#!/bin/bash
# DESCRIPTION
#    Instructions for installing dependencies for  
#    longread_umi-AF-LSU.
#
#    USE AT OWN RISK!!!
#    Will likely require system specific modifications to work.
#    Preferably run manually one dependency at a time.
#
#    Move script to directory where you want dependencies installed.
#    Run in terminal bash install_dependencies.sh
#
# IMPLEMENTATION
#    author   Søren Karst (sorenkarst@gmail.com)
#             Ryans Ziels (ziels@mail.ubc.ca)
#    license  GNU General Public License

### Terminal input
BRANCH=${1:-master}

# Store software dir path
SOFTWARE_DIR=$PWD
my_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

### Check for installation depenencies
if command -v conda >/dev/null 2>&1 ; then
    echo "conda found"
    echo "version: $(conda -V)"
else
    echo "conda not found. Install conda and re-run install script:
	# Miniconda3 install example
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	sh Miniconda3-latest-Linux-x86_64.sh -p $PWD/miniconda3
	source ~/.bashrc
	conda config --add channels defaults
	conda config --add channels bioconda
	conda config --add channels conda-forge
	conda config --set auto_activate_base false
	source ~/.bashrc"
	exit 0
fi


### Create file with paths

echo '' > ./longread_umi-AF-LSU_paths.txt

# Make ~/bin if it doesn't exist
mkdir -p ~/bin

# pip
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python3 get-pip.py --user
rm ./get-pip.py

# Python virtual environment
# python3 -m pip install virtualenv --user

# Rscript
echo "--------------- Rscript"
conda install -c conda-forge r-base
conda install -c conda-forge r-idpmisc

# Cmake
echo "--------------- cmake"
echo $PWD
git clone https://github.com/scivision/cmake-utils.git -b v1.4.0.0;
cd cmake-utils
python3 cmake_setup.py 3.15.2 \
  --install_path $SOFTWARE_DIR/cmake
cd ..
rm -rf ./cmake-utils

### Install longread_umi-AF-LSU
echo "--------------- repoDownload"
echo $PWD
git clone https://github.com/rhinempi/longread_umi-AF-LSU.git -b $BRANCH
cd ./longread_umi-AF-LSU
find . -name "*.sh" -exec chmod +x {} \;
cd ..
#echo $my_dir
#ln -sf $my_dir/../longread_umi.sh ~/bin/longread_umi
ln -sf $SOFTWARE_DIR/longread_umi-AF-LSU/longread_umi.sh ~/bin/longread_umi

### Install dependencies automaticly

# Seqtk
echo "--------------- seqtk"
echo $PWD
git clone https://github.com/lh3/seqtk.git;
cd seqtk; make
cd ..
echo "export SEQTK=$SOFTWARE_DIR/seqtk/seqtk" >> ./longread_umi-AF-LSU_paths.txt

# GNU Parallel
echo "--------------- parallel"
echo $PWD
(wget pi.dk/3 -qO - ||  curl pi.dk/3/) | bash
echo "export GNUPARALLEL=$(which parallel)" >> ./longread_umi-AF-LSU_paths.txt
rm -rf ./parallel*

# Racon
echo "--------------- racon"
echo $PWD
git clone --recursive https://github.com/isovic/racon.git racon
cd racon
mkdir build
cd build
$SOFTWARE_DIR/cmake/cmake*/bin/cmake -DCMAKE_BUILD_TYPE=Release ..
make
cd ../..
echo "export RACON=$SOFTWARE_DIR/racon/build/bin/racon" >> ./longread_umi-AF-LSU_paths.txt

# Minimap2
echo "--------------- minimap2"
echo $PWD
git clone https://github.com/lh3/minimap2
cd minimap2 && make
cd ..
ln -sf $SOFTWARE_DIR/minimap2/minimap2 ~/bin/minimap2
echo "export MINIMAP2=$(which minimap2)" >> ./longread_umi-AF-LSU_paths.txt

# Gawk
# Check presence by:
# which gawk
# If not present install
echo "export GAWK=$(which gawk)" >> ./longread_umi-AF-LSU_paths.txt

#Samtools
echo "--------------- samtools"
echo $PWD
wget "https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2"
tar -xjf ./samtools-1.9.tar.bz2
cd samtools-1.9
./configure \
  --prefix=$SOFTWARE_DIR/samtools_1.9 \
  --disable-bz2 \
  --disable-lzma \
  --without-curses
make
make install
cd ..
rm -rf ./samtools-1.9*
ln -sf $SOFTWARE_DIR/samtools_1.9/bin/samtools ~/bin/samtools
echo "export SAMTOOLS=$(which samtools)" >> ./longread_umi-AF-LSU_paths.txt

#Bcftools
echo "--------------- bcftools"
echo $PWD
wget "https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2"
tar -xjf ./bcftools-1.9.tar.bz2
cd bcftools-1.9 
./configure \
  --prefix=$SOFTWARE_DIR/bcftools_1.9 \
  --disable-bz2 \
  --disable-lzma
make
make install
cd ..
rm -r ./bcftools-1.9*
ln -sf $SOFTWARE_DIR/bcftools_1.9/bin/bcftools ~/bin/bcftools
echo "export BCFTOOLS=$(which bcftools)" >> ./longread_umi-AF-LSU_paths.txt

#Htslib
echo "--------------- htslib"
echo $PWD
wget "https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2"
tar -xjf ./htslib-1.9.tar.bz2
cd htslib-1.9 
./configure \
  --prefix=$SOFTWARE_DIR/htslib_1.9 \
  --disable-lzma \
  --disable-bz2 \
make
make install
cd ..
rm -r ./htslib-1.9*
ln -sf $SOFTWARE_DIR/htslib_1.9/bin/tabix ~/bin/tabix
ln -sf $SOFTWARE_DIR/htslib_1.9/bin/bgzip ~/bin/bgzip

# Medaka
echo "--------------- medaka"
echo $PWD
#conda create -c bioconda -n medaka medaka
conda create -n medaka -c conda-forge -c bioconda medaka
echo "export MEDAKA_ENV_START='eval \"\$(conda shell.bash hook)\"; conda activate medaka'" >> ./longread_umi-AF-LSU_paths.txt
echo "export MEDAKA_ENV_STOP='conda deactivate'" >> ./longread_umi-AF-LSU_paths.txt

# cutadapt
echo "--------------- cutadapt"
echo $PWD
pip3 install --user --upgrade cutadapt
echo "export CUTADAPT=$(which cutadapt)" >> ./longread_umi-AF-LSU_paths.txt

# Porechop
echo "--------------- porechop"
echo $PWD
git clone https://github.com/rrwick/Porechop.git
cd Porechop
make
cd ..
echo "export PORECHOP_UMI=$SOFTWARE_DIR/Porechop/porechop-runner.py" >> ./longread_umi-AF-LSU_paths.txt
mv $SOFTWARE_DIR/Porechop/porechop/adapters.py $SOFTWARE_DIR/Porechop/porechop/adapters_original.py
cp $SOFTWARE_DIR/longread_umi-AF-LSU/scripts/adapters.py $SOFTWARE_DIR/Porechop/porechop/

# Filtlong
echo "--------------- filtlong"
echo $PWD
git clone https://github.com/rrwick/Filtlong.git
cd Filtlong
make -j
cd ..
echo "export FILTLONG=$SOFTWARE_DIR/Filtlong/bin/filtlong" >> ./longread_umi-AF-LSU_paths.txt

#BWA
echo "--------------- bwa"
git clone https://github.com/lh3/bwa.git
cd bwa; make
cd ..
echo "export BWA=$SOFTWARE_DIR/bwa/bwa" >> ./longread_umi-AF-LSU_paths.txt

### Install dependencies manually

# Usearch
echo "--------------- usearch"
echo $PWD
mkdir -p $SOFTWARE_DIR/usearch
echo ""
echo "Download usearch from https://drive5.com/usearch/download.html and place in usearch folder"
echo ""
read -rsp $'Press any key to continue...\n' -n1 key
cp $SOFTWARE_DIR/longread_umi-AF-LSU/scripts/usearch $SOFTWARE_DIR/usearch/
chmod +x $SOFTWARE_DIR/usearch/usearch*
echo "export USEARCH=$(find $SOFTWARE_DIR/usearch/ -type f -name "usearch*")" >> ./longread_umi-AF-LSU_paths.txt

### Add depency paths to dependency.sh

echo "" >> ./longread_umi-AF-LSU_paths.txt
LEAD='^# Program paths$'
TAIL='^# longread_umi paths'

echo $PWD
cat ./longread_umi-AF-LSU_paths.txt
sed -i \
  -e "/$LEAD/,/$TAIL/{ /$LEAD/{p; r ./longread_umi-AF-LSU_paths.txt
        }; /$TAIL/p; d }"  $SOFTWARE_DIR/longread_umi-AF-LSU/scripts/dependencies.sh


### Test longread_umi-AF-LSU
#cd longread_umi-AF-LSU/test_data
#longread_umi nanopore_pipeline -d test_reads.fq -o . -v 30 -w rrna_operon -t 1 -q r941_min_high_g303
#longread_umi qc_pipeline -d test_reads.fq -c consensus_raconx3_medakax1.fa -r zymo_curated -t 1
