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

echo "Please type root password:"
sudo echo "Password correct"

SEP="############################################################"
echo $SEP

echo $(date)
echo "Script Started"
echo $SEP

# check for root privileges
#if [[ $(id -u) -ne 0 ]]
#    then
#        echo $(date)
#        echo "Please run the script as root"
#        echo "Exiting..."
#        echo $SEP
#        exit 1
#fi

# check the CPU architecture
CPU_arch=$(uname -m)
if [[ $CPU_arch != "x86_64" ]]
    then
        echo $(date)
        echo "This script only works on 64bit systems, sorry!"
        echo "Exiting..."
        echo $SEP
        exit 1
fi




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
sudo apt-get install git --yes
echo $SEP

# backup old configs
echo $(date)
echo "Backing up old config files"
if [[ -d "backup" ]]
    then
        echo "Directory '~/backup' already exists!"
        echo "Exiting..."
        echo $SEP
        exit 1
fi
mkdir backup
cp .bashrc backup/.bashrc # .bashrc is always present
if [[ -f .gitconfig ]]
    then
        cp .gitconfig backup/.gitconfig
fi
echo $SEP

# install my bash configuration
# https://github.com/AngryMaciek/custom_bash
echo $(date)
echo "Configuring bash"
git clone https://github.com/AngryMaciek/custom_bash.git
rm -f .bashrc
ln -s custom_bash/bashrc .bashrc
# bashrc.local is an additional space for all local bash configuration
touch custom_bash/bashrc.local
echo $SEP

# update package lists
echo $(date)
echo "Updating package lists"
sudo apt-get update --yes
echo $SEP

# fetch new versions of installed packages
echo $(date)
echo "Upgrading installed packages"
sudo apt-get upgrade --yes
echo $SEP

# install compilers
echo $(date)
echo "Installing GCC, G++, GFORTRAN compilers"
sudo apt-get install gcc --yes
gcc --version
sudo apt-get install g++ --yes
g++ --version
sudo apt-get install gfortran --yes
gfortran --version
echo $SEP

# install important software:
echo $(date)
echo "Installing specified software"
sudo apt-get install wget --yes
wget --version
sudo apt-get install guake --yes
guake --help
sudo apt-get install terminator --yes
terminator --version
sudo apt-get install tmux --yes
hash tmux
sudo apt-get install sshfs --yes
sshfs --version
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get install ./google-chrome-stable_current_amd64.deb --yes
google-chrome --version
rm -f google-chrome-stable_current_amd64.deb
sudo apt-get install vim --yes
vim --version
echo $SEP
# sublime
# https://linuxize.com/post/how-to-install-sublime-text-3-on-ubuntu-18-04/

# temporarily allow non-zero exit commands
set +e

# remove unnecessary software
echo $(date)
echo "Uninstalling unnecessary software"
sudo apt-get purge rhythmbox --yes
sudo apt-get purge rhythmbox-data --yes
hash rhythmbox 2>/dev/null && exit 1
sudo apt-get purge thunderbird --yes
hash thunderbird 2>/dev/null && exit 1
sudo apt-get purge firefox --yes
sudo apt-get purge firefox-locale-en --yes
hash firefox 2>/dev/null && exit 1
echo $SEP

# exit on first non-zero exit status command
set -e

# download and install Miniconda3
echo $(date)
echo "Installing Miniconda3"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p miniconda3
eval "$($HOME/miniconda3/bin/conda shell.bash hook)"
conda init
conda --version
rm -f Miniconda3-latest-Linux-x86_64.sh
echo $SEP

# install my conda env recipes
# https://github.com/AngryMaciek/conda-envs
echo $(date)
echo "Building conda environments"
git clone https://github.com/AngryMaciek/conda-envs.git
bash conda-envs/Nextflow/create-virtual-environment.sh
echo $SEP



# add sudo
# conda create env?
























# install my textfile templates
# https://github.com/AngryMaciek/textfile-templates
#git clone https://github.com/AngryMaciek/textfile-templates.git
#EXPORT_LINE="export PATH=$PATH\":$HOME/textfile-templates\""
#echo $'\n\n' >> custom_bash/bashrc.local
#echo $EXPORT_LINE >> custom_bash/bashrc.local
#chmod +x textfile-templates/template









# install my cookiecutters
# https://github.com/AngryMaciek/cookiecutters
#conda install -c conda-forge cookiecutter
#git clone https://github.com/AngryMaciek/cookiecutters.git;








#sc4da

#custom pylintrc merge that repo into this one
# create alias
# pylint --rcfile=$HOME/custom_pylintrc/pylintrc {FILE}


# finish with rebooting the system
echo $(date)
echo "Setup completed successfully!"
echo "System will reboot in 60s"
echo $SEP
sleep 60
#reboot


#======================================

# todo:
# remove other unnecessary software
# trap function
# install sublime
# install gnome 3 shell
# if some step goes wrong redirect a message to a log file, redirecting stdout and stderr to separate files
# #shellckech and lint this script at the end!
# set a wallpaper, screen resolution: xdpyinfo | awk '/dimensions/{print $2}'
# move icons!
# https://askubuntu.com/questions/66914/how-to-change-desktop-background-from-command-line-in-unity