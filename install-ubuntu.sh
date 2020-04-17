#!/usr/bin/env bash

###############################################################################
#
#   [TITLE, DESCRIPTION]
#
#   AUTHOR: Maciej_Bak
#   AFFILIATION: Swiss_Institute_of_Bioinformatics
#   CONTACT: wsciekly.maciek@gmail.com
#   CREATED: 16-04-2020
#   LICENSE: MIT
#   USAGE: bash install-ubuntu.sh
#
###############################################################################

SEP="##################################################"
echo $SEP

echo $(date)
echo "Script Started"
echo $SEP





#cleanup () {
#    rc=$?
#    rm -rf backup
#    cd "$user_dir"
#    echo "Exit status: $rc"
#}
#trap cleanup EXIT

#set -eo pipefail  # ensures that script exits at first command that exits with non-zero status
#set -u  # ensures that script exits when unset variables are used
#set -x  # facilitates debugging by printing out executed commands

set -euo pipefail

#user_dir=$PWD
#pipeline_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
#cd "$pipeline_dir"




# work in home directory
cd $HOME

# install git if it has not been already installed
# (the newest version available)
echo $(date)
echo "Installing Git version control system"
apt-get install git --yes
echo $SEP

# backup old configs
#mkdir backup || echo "Dicectory 'backup' already exists."
#cp .bashrc backup/.bashrc # always present
#cp .gitconfig backup/.gitconfig

# install my bash configuration
# https://github.com/AngryMaciek/custom_bash
#git clone https://github.com/AngryMaciek/custom_bash.git
#ln -s custom_bash/bashrc .bashrc
# place all the local bash configs into bashrc.local
#touch custom_bash/bashrc.local
#source .bashrc

# update and upgrade ????
apt-get update
apt-get upgrade --yes

# install compilers
echo $(date)
echo "Installing GCC, G++, GFORTRAN compilers"
apt-get install gcc
apt-get install g++
apt-get install gfortran
echo $SEP


# install important software:
#apt-get install guake
#apt-get install terminator
#apt-get install tmux
#apt-get install sshfs


# Chrome
# visual studio vs sublime






# remove unnecessary software

# download miniconda

#CPU_arch=$(uname -m)
#if [ CPU_arch == "x86_64" ]; then
#  Miniconda_installer="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
#elif [ CPU_arch == "i386" ] | [ CPU_arch == "i686" ]; then
#  Miniconda_installer="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86.sh"
#fi
#wget Miniconda_installer

# install miniconda

#if [ CPU_arch == "x86_64" ]; then
#  bash Miniconda3-latest-Linux-x86_64.sh
#elif [ CPU_arch == "i386" ] | [ CPU_arch == "i686" ]; then
#  bash Miniconda3-latest-Linux-x86.sh
#fi

#rm -f Miniconda3-latest-Linux-x86_64.sh
#rm -f Miniconda3-latest-Linux-x86.sh

#source .bashrc

# what should I have in conda base? nothing!








# install my textfile templates
# https://github.com/AngryMaciek/textfile-templates
#git clone https://github.com/AngryMaciek/textfile-templates.git;

#vim .bash_profle
# add the following line into the profile file:
# export PATH=$PATH":$HOME/textfile-templates"

#vim textfile-templates/template

#chmod +x textfile-templates/template

#source .bashrc




# install my cookiecutters
# https://github.com/AngryMaciek/cookiecutters
#conda install -c conda-forge cookiecutter
#git clone https://github.com/AngryMaciek/cookiecutters.git;

# install my conda env recipes
# https://github.com/AngryMaciek/conda-envs
#git clone https://github.com/AngryMaciek/conda-envs.git


# copy mi .gitfconfig

#sc4da
#custom pylintrc merge that repo into this one

# create alias
# pylint --rcfile=$HOME/custom_pylintrc/pylintrc {FILE}

# redirecting stdout and stderr to separate files

# install gnome shell
# restart!

# if some step goes wrong redirect a message to a log file

#shellckech and lint this script at the end!

# test commands at the end!
