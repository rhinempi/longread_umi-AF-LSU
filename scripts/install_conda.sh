#!/bin/bash
# DESCRIPTION
#    Install longread_umi as conda environment.
#
# IMPLEMENTATION
#    author   Søren Karst (sorenkarst@gmail.com)
#             Ryan Ziels (ziels@mail.ubc.ca)
#    license  GNU General Public License

# Terminal input
BRANCH=${1:-master} # Default to master branch

# Check conda installation ----------------------------------------------------
if [[ -z $(which conda) ]]; then
  # Ask to install
  read -t 1 -n 10000 discard # Clears stdin before read
  read \
    -n 1 \
    -p "Conda not found. Install miniconda3 (y/n)? " \
    ASK_CONDA_INSTALL    
  
  if [ "$ASK_CONDA_INSTALL" == "y" ]; then
    # Install conda
    [ -f Miniconda3-latest-Linux-x86_64.sh ] ||\
      wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    bash ./Miniconda3-latest-Linux-x86_64.sh   
  else
    echo ""
	echo "Installation aborted..."
    echo ""
    exit 1 
  fi
else
  echo ""
  echo "Conda found"
  echo "version: $(conda -V)"
  echo ""
fi