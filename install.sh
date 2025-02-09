#!/bin/bash
export FEDSCALE_HOME=$PWD


isPackageNotInstalled() {
  $1 --version &> /dev/null
  if [ $? -eq 0 ]; then
    echo "$1: Already installed"
  else 
    install_dir=$HOME/anaconda3
    wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh
    bash Anaconda3-2020.11-Linux-x86_64.sh -b -p  $install_dir
    export PATH=$install_dir/bin:$PATH    
  fi
}

# un-comment to install anaconda
isPackageNotInstalled conda


# create conda env
conda init bash
. ~/.bashrc
conda env create -f environment.yml # Install dependencies
conda activate fedscale


if [ "$1" == "--cuda" ]; then
  wget https://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_440.33.01_linux.run
  sudo apt-get purge nvidia-* -y
  sudo sh -c "echo 'blacklist nouveau\noptions nouveau modeset=0' > /etc/modprobe.d/blacklist-nouveau.conf"
  sudo update-initramfs -u
  sudo sh cuda_10.2.89_440.33.01_linux.run --override --driver --toolkit --samples --silent
  export PATH=$PATH:/usr/local/cuda-10.2/
  conda install cudatoolkit=10.2 -y
fi

