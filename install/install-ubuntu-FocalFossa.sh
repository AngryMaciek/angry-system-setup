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

SECONDS=0

SEP="############################################################"
echo $SEP

echo $(date)
echo "Script started"
echo $SEP

# check root privileges
if [[ $(id -u) -eq 0 ]]
    then
        echo $(date)
        echo "Do not run the script as root, run as a regular user"
        echo "Exiting..."
        echo $SEP
        exit 1
fi

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
install_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# work in home directory
cd $HOME

# snap
sudo snap install core

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
        mv .gitconfig backup/.gitconfig
fi
echo $SEP

# copy the dotflies
echo $(date)
echo "Copying configuration files"
cp $install_dir/../dotfiles/.gitconfig .gitconfig
cp $install_dir/../dotfiles/.pylintrc .pylintrc
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

# update apt-get package lists
echo $(date)
echo "Updating package lists"
sudo apt-get update --yes
echo $SEP

# fetch new versions of installed packages
echo $(date)
echo "Upgrading installed packages"
sudo snap refresh
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
echo "Installing important software"
sudo snap install code --classic
code --version
sudo apt-get install guake --yes
guake --version
sudo apt-get install htop --yes
htop --version
sudo apt-get install terminator --yes
terminator --version
sudo snap install tmux --classic
hash tmux
sudo apt-get install sshfs --yes
sshfs --version
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get install ./google-chrome-stable_current_amd64.deb --yes
google-chrome --version
rm -f google-chrome-stable_current_amd64.deb
sudo apt-get install vim --yes
vim --version
sudo snap install slack --classic
hash slack
sudo snap install bitwarden
hash bitwarden
sudo snap install gimp
gimp --version
sudo snap install inkscape
inkscape --version
# install Adobe Reader
sudo apt-get install \
gdebi-core \
libxml2:i386 \
libcanberra-gtk-module:i386 \
gtk2-engines-murrine:i386 \
libatk-adaptor:i386 \
--yes
wget ftp://ftp.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb
yes | sudo gdebi AdbeRdr9.5.5-1_i386linux_enu.deb & # workaround for this installer
sleep 180
rm -rf AdbeRdr9.5.5-1_i386linux_enu.deb
acroread -version
echo $SEP

# temporarily allow non-zero exit commands
set +e

# remove unnecessary software
echo $(date)
echo "Uninstalling unnecessary software"
sudo apt-get purge firefox* --yes
hash firefox 2>/dev/null &&libre
echo $SEP
#sudo apt-get clean
#sudo apt-get autoremove
# snap?

# exit on first non-zero exit status command
set -e

# install my textfile templates
# https://github.com/AngryMaciek/textfile-templates
echo $(date)
echo "Cloning textfile templates"
git clone https://github.com/AngryMaciek/textfile-templates.git
EXPORT_TEMPLATES="export PATH=$PATH\":$HOME/textfile-templates\""
echo $'\n' >> custom_bash/bashrc.local
echo $EXPORT_TEMPLATES >> custom_bash/bashrc.local
chmod +x textfile-templates/template
echo $SEP

# install my cookiecutters
# https://github.com/AngryMaciek/cookiecutters
echo $(date)
echo "Cloning cookiecutters"
git clone https://github.com/AngryMaciek/cookiecutters.git;
echo $SEP

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
bash conda-envs/Python_Jupyter/create-virtual-environment.sh
bash conda-envs/R/create-virtual-environment.sh
bash conda-envs/Snakemake/create-virtual-environment.sh
bash conda-envs/code_linting/create-virtual-environment.sh
# ...and add bash aliases:
ALIAS_NEXTFLOW="alias conda-nextflow=\"conda activate ~/conda-envs/Nextflow/env\""
echo $'\n' >> custom_bash/bashrc.local
echo $ALIAS_NEXTFLOW >> custom_bash/bashrc.local
ALIAS_PYTHON_JUPYTER="alias conda-jupyter=\"conda activate ~/conda-envs/Python_Jupyter/env\""
echo $'\n' >> custom_bash/bashrc.local
echo $ALIAS_PYTHON_JUPYTER >> custom_bash/bashrc.local
ALIAS_R="alias conda-r=\"conda activate ~/conda-envs/R/env\""
echo $'\n' >> custom_bash/bashrc.local
echo $ALIAS_R >> custom_bash/bashrc.local
ALIAS_SNAKEMAKE="alias conda-snakemake=\"conda activate ~/conda-envs/Snakemake/env\""
echo $'\n' >> custom_bash/bashrc.local
echo $ALIAS_SNAKEMAKE >> custom_bash/bashrc.local
ALIAS_CODE_LINT="alias conda-lint=\"conda activate ~/conda-envs/code_linting/env\""
echo $'\n' >> custom_bash/bashrc.local
echo $ALIAS_CODE_LINT >> custom_bash/bashrc.local
echo $SEP

# install my general data analytic env
# https://github.com/AngryMaciek/SC4DA
echo $(date)
echo "Building main development environment (SC4DA)"
git clone https://github.com/AngryMaciek/SC4DA.git
conda env create --prefix SC4DA/env --file SC4DA/conda_packages.yaml
echo $SEP

# clean conda: cache, lock files, unused packages and tarballs
echo $(date)
echo "Removing unused packages and cache from conda"
conda clean --all --yes
echo $SEP

# set a wallpaper
# https://askubuntu.com/questions/66914/how-to-change-desktop-background-from-command-line-in-unity
echo $(date)
echo "Setting a wallpaper"
#RESOLUTION=$(xdpyinfo | awk '/dimensions/{print $2}')
gsettings set org.gnome.desktop.background picture-uri \
file://$HOME/system-setup/ubuntu-wallpaper-3840x2160.jpg
echo $SEP

# Install GNOME Flashback desktop environment
echo $(date)
echo "Installing GNOME Flashback"
sudo apt-get install gnome-session-flashback --yes
echo $SEP

duration=$SECONDS
duration_h=$(($duration / 3600))
duration_m=$((($duration / 60) % 60))
duration_s=$(($duration % 60))

# finish with rebooting the system
echo $(date)
echo "Setup time: "$duration_h"h"$duration_m"m"$duration_s"s"
echo "Setup completed successfully!"
echo "System will reboot in 60s"
echo $SEP
sleep 60
#reboot


###############################################################################
#
# Future releases: 
#
# * gnome flashback as default desktop, clean icons and panels (gnome dotfile?)
# * vs code config - dotfiles? plugins?
# * .guake
# * .terminator
# * include new repo with vimrc
#
###############################################################################


# test pylintrc automatic detection $ test gitconfig and conda alias

# remember sudo for 5h

# order of install: gnome on top? update, purge, upgrade, intall?

# trap function

# #shellckech and lint this script at the end!
