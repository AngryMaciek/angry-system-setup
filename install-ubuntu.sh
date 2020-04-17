#!/usr/bin/env bash

###############################################################################
#
#   Working environment setup for fresh operating system
#
#   AUTHOR: Maciej_Bak
#   AFFILIATION: Swiss_Institute_of_Bioinformatics
#   CONTACT: wsciekly.maciek@gmail.com
#   CREATED: 16-04-2020
#   LICENSE: MIT
#   USAGE: sudo bash install-ubuntu.sh
#
###############################################################################

SEP="############################################################"
echo $SEP

echo $(date)
echo "Script Started"
echo $SEP

# check for root privileges
if [[ $(id -u) -ne 0 ]]
    then
        echo $(date)
        echo "Please run the script as root."
        echo "Exiting..."
        echo $SEP
        exit 1
fi



#CPU_arch=$(uname -m)
#if [ CPU_arch == "x86_64" ]; then
#fi


#cleanup () {
#    rc=$?
#    rm -rf backup
#    cd "$user_dir"
#    echo "Exit status: $rc"
#}
#trap cleanup EXIT




# exit script on first non-zero exit-status command
# exit script when unset variables are used
# do not mask the return code
set -euo pipefail

# remember paths
user_dir=$PWD
repository_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# work in home directory
cd $HOME

# install git if it has not been already installed
# (the newest version available)
echo $(date)
echo "Installing Git version control system"
apt-get install git --yes
echo $SEP





# backup old configs
#mkdir backup || echo "Directory 'backup' already exists."
#cp .bashrc backup/.bashrc # always present
#cp .gitconfig backup/.gitconfig # present after git installation





# install my bash configuration
# https://github.com/AngryMaciek/custom_bash
#git clone https://github.com/AngryMaciek/custom_bash.git
#ln -s custom_bash/bashrc .bashrc
# place all the local bash configs into bashrc.local
#touch custom_bash/bashrc.local
#source .bashrc







# update package lists
echo $(date)
echo "Updating package lists"
apt-get update --yes
echo $SEP

# fetch new versions of installed packages
echo $(date)
echo "Upgrading installed packages"
apt-get upgrade --yes
echo $SEP

# install compilers
echo $(date)
echo "Installing GCC, G++, GFORTRAN compilers"
apt-get install gcc --yes
apt-get install g++ --yes
apt-get install gfortran --yes
echo $SEP

# install important software:
echo $(date)
echo "Installing specified software"
apt-get install wget --yes
apt-get install guake --yes
apt-get install terminator --yes
apt-get install tmux --yes
apt-get install sshfs --yes
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get install ./google-chrome-stable_current_amd64.deb
rf -f google-chrome-stable_current_amd64.deb
echo $SEP
# sublime
# https://linuxize.com/post/how-to-install-sublime-text-3-on-ubuntu-18-04/











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

# test commands at the end! add --version afer every install?
