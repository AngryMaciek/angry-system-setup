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
#   USAGE: sudo bash install.sh
#
###############################################################################

SECONDS=0

SEP="############################################################"
echo $SEP

date
echo "Script started"
echo $SEP

# check root privileges
if [[ $(id -u) -ne 0 ]]
then
    date
    echo "Please run this script with root privileges."
    echo "Exiting..."
    echo $SEP
    exit 1
fi

# check the CPU architecture
CPU_arch=$(uname -m)
if [[ $CPU_arch != "x86_64" ]]
then
    date
    echo "This script only works on 64bit systems, sorry!"
    echo "Exiting..."
    echo $SEP
    exit 1
fi

# remember paths
USER_DIR=$PWD
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# work in "$SUDO_USER" home directory
USER_HOME=$(sudo -u "$SUDO_USER" -H -s eval 'echo $HOME')
cd "$USER_HOME" || exit 1

# prepare a clean-up function to call on non-zero exit signal
cleanup () {
    rc=$?
    cd $USER_HOME
    # remove all new rcfiles
    rm -f .bashrc .vimrc
    # restore old dotfiles
    cp Backup/.bashrc .bashrc
    # remove all new directories from $USER_HOME
    chattr -i Backup
    rm -rf Backup
    rm -rf angry-bash
    rm -rf angry-vim
    rm -rf google-chrome-stable_current_amd64.deb
    rm -rf AdbeRdr9.5.5-1_i386linux_enu.deb
    rm -rf angry-skeletor
    rm -rf Miniconda3-latest-Linux-x86_64.sh
    rm -rf miniconda3 .conda .condarc
    rm -f conda-init-bash.sh
    rm -f conda-init-zsh.sh
    rm -f conda-config-change-PS1.sh
    rm -rf angry-conda-environments
    rm -rf bin
    rm -rf .zprezto
    rm -f .zlogin .zlogout .zpreztorc .zprofile .zshenv .zshrc
    cd "$USER_DIR" || exit 1
    echo "Installation aborted!"
    echo "Exit status: $rc"
    echo $SEP
    exit $rc
}

# unset variables are errors when substituting
# do not mask the return code
set -uo pipefail

# backup old configs
date
echo "Backing up old config files"
if [[ -d "Backup" ]]
then
    echo "Directory '~/Backup' already exists!"
    echo "Exiting..."
    echo $SEP
    exit 1
fi
mkdir Backup
cp .bashrc Backup/.bashrc # .bashrc is always present
chattr +i Backup
echo $SEP

# from this point use cleanup() on errors
trap cleanup ERR SIGINT SIGTERM

# snap
snap install core

# install git if it has not been already installed
# (the newest version available)
date
echo "Installing Git version control system"
apt-get install git -qq
echo $SEP

# install my bash configuration
# https://github.com/AngryMaciek/angry-bash
date
echo "Configuring bash"
sudo -u "$SUDO_USER" git clone https://github.com/AngryMaciek/angry-bash.git
sudo -u "$SUDO_USER" rm -f .bashrc
sudo -u "$SUDO_USER" ln -s angry-bash/bashrc .bashrc
# bashrc.local is an additional space for all local bash configuration
sudo -u "$SUDO_USER" touch angry-bash/bashrc.local
echo $SEP

# update apt-get package lists
date
echo "Updating package lists"
apt-get update --yes
echo $SEP

# fetch new versions of installed packages
date
echo "Upgrading installed packages"
snap refresh
apt-get upgrade --yes
echo $SEP

# install compilers
date
echo "Installing GCC, G++, GFORTRAN compilers"
apt-get install gcc -qq
gcc --version
apt-get install g++ -qq
g++ --version
apt-get install gfortran -qq
gfortran --version
echo $SEP

# install important software:
date
echo "Installing important software"
apt-get install gparted -qq
hash gparted
snap install tree
tree --version
apt-get install zsh -qq
zsh --version
snap install code --classic
sudo -u "$SUDO_USER" code --version
sudo -u "$SUDO_USER" code --install-extension ms-azuretools.vscode-docker
sudo -u "$SUDO_USER" code --install-extension ms-python.anaconda-extension-pack
sudo -u "$SUDO_USER" code --install-extension yzhang.markdown-all-in-one
sudo -u "$SUDO_USER" code --install-extension dunstontc.viml
apt-get install make -qq
make --version
apt-get install guake -qq
guake --version
apt-get install htop -qq
htop --version
apt-get install terminator -qq
terminator --version
snap install tmux --classic
hash tmux
apt-get install sshfs -qq
sshfs --version
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get install ./google-chrome-stable_current_amd64.deb -qq
google-chrome --version
rm -f google-chrome-stable_current_amd64.deb
apt-get install vim -qq
vim --version
snap install slack --classic
hash slack
snap install bitwarden
hash bitwarden
snap install gimp
gimp --version
snap install inkscape
sudo -u "$SUDO_USER" inkscape --version
# install Adobe Reader:
apt-get install \
    gdebi-core \
    libxml2:i386 \
    libcanberra-gtk-module:i386 \
    gtk2-engines-murrine:i386 \
    libatk-adaptor:i386 \
    -qq
wget ftp://ftp.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb
yes | gdebi AdbeRdr9.5.5-1_i386linux_enu.deb & # workaround for this installer
sleep 180
rm -rf AdbeRdr9.5.5-1_i386linux_enu.deb
acroread -version
echo $SEP

# clean up
date
echo "System: apt-get cleanup"
apt-get clean
apt-get autoremove -qq
echo $SEP

# Clone Vim Configuration
# https://github.com/AngryMaciek/angry-vim
date
echo "Cloning Vim configuration"
sudo -u "$SUDO_USER" git clone https://github.com/AngryMaciek/angry-vim.git
sudo -u "$SUDO_USER" rm -f .vimrc
sudo -u "$SUDO_USER" bash angry-vim/setup.sh
echo $SEP

# install my textfile templates
# https://github.com/AngryMaciek/angry-skeletor
date
echo "Cloning textfile templates"
sudo -u "$SUDO_USER" git clone https://github.com/AngryMaciek/angry-skeletor.git
EXPORT_TEMPLATES="export PATH=$PATH\":$USER_HOME/angry-skeletor\""
echo $'' | sudo -u "$SUDO_USER" tee -a angry-bash/bashrc.local > /dev/null
echo "$EXPORT_TEMPLATES" | sudo -u "$SUDO_USER" tee -a angry-bash/bashrc.local > /dev/null
sudo -u "$SUDO_USER" chmod +x angry-skeletor/template
echo $SEP

# download and install Miniconda3
date
echo "Installing Miniconda3"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sudo -u "$SUDO_USER" bash Miniconda3-latest-Linux-x86_64.sh -b -p miniconda3
sudo -u "$SUDO_USER" echo 'eval "$($HOME/miniconda3/bin/conda shell.bash hook)"' > conda-init-bash.sh
sudo -u "$SUDO_USER" echo "conda init bash" >> conda-init-bash.sh
sudo -i -u "$SUDO_USER" bash -i conda-init-bash.sh
rm -f conda-init-bash.sh
rm -f Miniconda3-latest-Linux-x86_64.sh
echo $SEP

# Clone and set up Prezto (Zsh Configuration)
# https://github.com/AngryMaciek/prezto
date
echo "Cloning Prezto"
EXPORT_CONDA_DEFAULT_ENV="export CONDA_DEFAULT_ENV=base"
sudo -u "$SUDO_USER" git clone --recursive https://github.com/AngryMaciek/prezto.git .zprezto
sudo -u "$SUDO_USER" ln -s .zprezto/runcoms/zlogin .zlogin
sudo -u "$SUDO_USER" ln -s .zprezto/runcoms/zlogout .zlogout
sudo -u "$SUDO_USER" ln -s .zprezto/runcoms/zpreztorc .zpreztorc
sudo -u "$SUDO_USER" ln -s .zprezto/runcoms/zprofile .zprofile
sudo -u "$SUDO_USER" ln -s .zprezto/runcoms/zshenv .zshenv
sudo -u "$SUDO_USER" ln -s .zprezto/runcoms/zshrc .zshrc
sudo -u "$SUDO_USER" echo "conda init zsh" > conda-init-zsh.sh
sudo -i -u "$SUDO_USER" bash -i conda-init-zsh.sh
rm -f conda-init-zsh.sh
sudo -u "$SUDO_USER" echo "conda config --set changeps1 False" > conda-config-change-PS1.sh
sudo -i -u "$SUDO_USER" bash -i conda-config-change-PS1.sh
rm -f conda-config-change-PS1.sh
# add all the bashrc.local modifications to .zshrc as well:
echo $'' | sudo -u "$SUDO_USER" tee -a .zshrc > /dev/null
echo "$EXPORT_TEMPLATES" | sudo -u "$SUDO_USER" tee -a .zshrc > /dev/null
echo $'' | sudo -u "$SUDO_USER" tee -a .zshrc > /dev/null
echo "$EXPORT_CONDA_DEFAULT_ENV" | sudo -u "$SUDO_USER" tee -a .zshrc > /dev/null
echo $SEP

# hide desktop icons
sudo -u "$SUDO_USER" gsettings set org.gnome.shell.extensions.desktop-icons show-home false
sudo -u "$SUDO_USER" gsettings set org.gnome.shell.extensions.desktop-icons show-trash false

DURATION=$SECONDS
DURATION_H=$((DURATION / 3600))
DURATION_M=$(((DURATION / 60) % 60))
DURATION_S=$((DURATION % 60))

# finish with rebooting the system
date
echo "Setup time: ${DURATION_H}h${DURATION_M}m${DURATION_S}s"
echo "Setup completed successfully!"
echo "System will reboot in 60s"
echo $SEP
sleep 60
reboot
