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

cd $HOME

# backup old configs
mkdir backup || exit_on_error "Dicectory 'backup' already exists."


# install my bash configuration
# https://github.com/AngryMaciek/custom_bash
#$ git clone https://github.com/AngryMaciek/custom_bash.git
# backup current bash configuration
#$ mv .bashrc .bashrc_backup
#$ ln -s custom_bash/bashrc .bashrc
#$ touch custom_bash/bashrc.local
# copy all the current local bash configs into bashrc.local

# install cool software:
# iterm
# terminator
# sshfs
# Chrome
# tmux
# visual studio vs sublime



# remove unnecessary software

# update and upgrade apt

# Ubuntu comes with gcc and gfortran compilers
# test that

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




# make symlinks to gitconfig dotfile

#sc4da
#custom pylintrc



#shellckech and lint this script at the end!
#trap? just like Alex does