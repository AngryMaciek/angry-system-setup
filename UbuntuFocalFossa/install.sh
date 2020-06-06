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
    # remove all new dotfiles
    rm -f .bashrc .gitconfig .pylintrc .config/htop/htoprc #.vimrc
    # restore old dotfiles
    cp Backup/.bashrc .bashrc
    if [[ -f Backup/.gitconfig ]]
    then
        mv Backup/.gitconfig .gitconfig
    fi
    #if [[ -f Backup/.vimrc ]]
    #    then
    #        mv Backup/.vimrc .vimrc
    #fi
    # remove all new directories from $USER_HOME
    chattr -i Backup
    rm -rf Backup
    rm -rf custom-bash
    #rm -rf custom_vim
    rm -rf google-chrome-stable_current_amd64.deb
    rm -rf AdbeRdr9.5.5-1_i386linux_enu.deb
    rm -rf textfile-templates
    rm -rf cookiecutters
    rm -rf Miniconda3-latest-Linux-x86_64.sh
    rm -rf miniconda3 .conda .condarc
    rm -f conda-init-bash.sh
    rm -f conda-init-zsh.sh
    rm -f conda-config-change-PS1.sh
    rm -f conda-clean.sh
    rm -rf small-dotfiles
    rm -rf conda-envs
    rm -rf SC4DA
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
if [[ -f .gitconfig ]]
then
    mv .gitconfig Backup/.gitconfig
fi
#if [[ -f .vimrc ]]
#    then
#        mv .vimrc Backup/.vimrc
#fi
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
# https://github.com/AngryMaciek/custom-bash
date
echo "Configuring bash"
sudo -u "$SUDO_USER" git clone https://github.com/AngryMaciek/custom-bash.git
sudo -u "$SUDO_USER" rm -f .bashrc
sudo -u "$SUDO_USER" ln -s custom-bash/bashrc .bashrc
# bashrc.local is an additional space for all local bash configuration
sudo -u "$SUDO_USER" touch custom-bash/bashrc.local
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

# Install GNOME Flashback desktop environment
date
echo "Installing GNOME Flashback"
apt-get install gnome-session-flashback -qq
apt-get install gnome-applets -qq
sed -i 's/XSession=/XSession=gnome-flashback-metacity/g' /var/lib/AccountsService/users/$SUDO_USER
echo $SEP

# install important software:
date
echo "Installing important software"
apt-get install gparted -qq
hash gparted
apt-get install gnome-tweaks -qq
gnome-tweaks --version
snap install tree
tree --version
apt-get install zsh -qq
zsh --version
apt-get install stow -qq
stow --version
snap install code --classic
sudo -u "$SUDO_USER" code --version
sudo -u "$SUDO_USER" code --install-extension ms-azuretools.vscode-docker
sudo -u "$SUDO_USER" code --install-extension ms-python.anaconda-extension-pack
sudo -u "$SUDO_USER" code --install-extension yzhang.markdown-all-in-one
sudo -u "$SUDO_USER" code --install-extension dunstontc.viml
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

# remove unnecessary software
date
echo "Uninstalling unnecessary software"
apt-get purge firefox* -qq
apt-get clean
apt-get autoremove -qq
echo $SEP

# Clone Vim Configuration
# https://github.com/AngryMaciek/custom_vim
#date
#echo "Cloning Vim configuration"
#sudo -u "$SUDO_USER" git clone https://github.com/AngryMaciek/custom_vim.git
#sudo -u "$SUDO_USER" rm -f .vimrc
#sudo -u "$SUDO_USER" ln -s custom_vim/vimrc .vimrc
#echo $SEP

# install my personal dotfiles
# https://github.com/AngryMaciek/small-dotfiles
date
echo "Cloning configuration files"
sudo -u "$SUDO_USER" git clone https://github.com/AngryMaciek/small-dotfiles.git
rm -f .gitconfig .pylintrc .config/htop/htoprc
cd small-dotfiles/dotfiles
sudo -u "$SUDO_USER" stow -vSt $USER_HOME git pylint htop
cd $USER_HOME

echo $SEP

# install my textfile templates
# https://github.com/AngryMaciek/textfile-templates
date
echo "Cloning textfile templates"
sudo -u "$SUDO_USER" git clone https://github.com/AngryMaciek/textfile-templates.git
EXPORT_TEMPLATES="export PATH=$PATH\":$USER_HOME/textfile-templates\""
echo $'' | sudo -u "$SUDO_USER" tee -a custom-bash/bashrc.local > /dev/null
echo "$EXPORT_TEMPLATES" | sudo -u "$SUDO_USER" tee -a custom-bash/bashrc.local > /dev/null
sudo -u "$SUDO_USER" chmod +x textfile-templates/template
echo $SEP

# clone my cookiecutters
# https://github.com/AngryMaciek/cookiecutters
date
echo "Cloning cookiecutters"
sudo -u "$SUDO_USER" git clone https://github.com/AngryMaciek/cookiecutters.git;
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

# install my conda env recipes
# https://github.com/AngryMaciek/conda-envs
date
echo "Building conda environments"
sudo -u "$SUDO_USER" git clone https://github.com/AngryMaciek/conda-envs.git
sudo -i -u "$SUDO_USER" bash -i conda-envs/Nextflow/create-virtual-environment.sh
sudo -i -u "$SUDO_USER" bash -i conda-envs/Python_Jupyter/create-virtual-environment.sh
# adjust syntax for env to work under zsh:
# ---
sudo -i -u "$SUDO_USER" sed -i '7s/\[/\[\[/' conda-envs/Python_Jupyter/env/etc/conda/activate.d/java_home.sh
sudo -i -u "$SUDO_USER" sed -i '7s/\]/\]\]/' conda-envs/Python_Jupyter/env/etc/conda/activate.d/java_home.sh
# ---
sudo -i -u "$SUDO_USER" bash -i conda-envs/Python_DL/create-virtual-environment.sh
sudo -i -u "$SUDO_USER" bash -i conda-envs/R/create-virtual-environment.sh
sudo -i -u "$SUDO_USER" bash -i conda-envs/Snakemake/create-virtual-environment.sh
sudo -i -u "$SUDO_USER" bash -i conda-envs/code_linting/create-virtual-environment.sh
# ...and add bash aliases:
ALIAS_NEXTFLOW="alias conda-nextflow=\"conda activate ~/conda-envs/Nextflow/env\""
echo $'' | sudo -u "$SUDO_USER" tee -a custom-bash/bashrc.local > /dev/null
echo "$ALIAS_NEXTFLOW" | sudo -u "$SUDO_USER" tee -a custom-bash/bashrc.local > /dev/null
ALIAS_PYTHON_JUPYTER="alias conda-jupyter=\"conda activate ~/conda-envs/Python_Jupyter/env\""
echo "$ALIAS_PYTHON_JUPYTER" | sudo -u "$SUDO_USER" tee -a custom-bash/bashrc.local > /dev/null
ALIAS_PYTHON_DL="alias conda-dl=\"conda activate ~/conda-envs/Python_DL/env\""
echo "$ALIAS_PYTHON_DL" | sudo -u "$SUDO_USER" tee -a custom-bash/bashrc.local > /dev/null
ALIAS_R="alias conda-r=\"conda activate ~/conda-envs/R/env\""
echo "$ALIAS_R" | sudo -u "$SUDO_USER" tee -a custom-bash/bashrc.local > /dev/null
ALIAS_SNAKEMAKE="alias conda-snakemake=\"conda activate ~/conda-envs/Snakemake/env\""
echo "$ALIAS_SNAKEMAKE" | sudo -u "$SUDO_USER" tee -a custom-bash/bashrc.local > /dev/null
ALIAS_CODE_LINT="alias conda-lint=\"conda activate ~/conda-envs/code_linting/env\""
echo "$ALIAS_CODE_LINT" | sudo -u "$SUDO_USER" tee -a custom-bash/bashrc.local > /dev/null
# clean conda: cache, lock files, unused packages and tarballs
sudo -u "$SUDO_USER" echo "conda clean --all --yes" > conda-clean.sh
sudo -i -u "$SUDO_USER" bash -i conda-clean.sh
echo $SEP

# install my general data analytic env
# https://github.com/AngryMaciek/SC4DA
date
echo "Building main development environment (SC4DA)"
sudo -u "$SUDO_USER" git clone https://github.com/AngryMaciek/SC4DA.git
sudo -i -u "$SUDO_USER" bash -i SC4DA/create-conda-virtual-environment.sh
# adjust syntax for env to work under zsh:
# ---
sudo -i -u "$SUDO_USER" sed -i '7s/\[/\[\[/' SC4DA/env/etc/conda/activate.d/java_home.sh
sudo -i -u "$SUDO_USER" sed -i '7s/\]/\]\]/' SC4DA/env/etc/conda/activate.d/java_home.sh
# ---
ALIAS_SC4DA="alias sc4da=\"conda activate ~/SC4DA/env\""
echo "$ALIAS_SC4DA" | sudo -u "$SUDO_USER" tee -a custom-bash/bashrc.local > /dev/null
# clean conda: cache, lock files, unused packages and tarballs
sudo -i -u "$SUDO_USER" bash -i conda-clean.sh
rm -f conda-clean.sh
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
echo $'' | sudo -u "$SUDO_USER" tee -a .zshrc > /dev/null
echo "$ALIAS_NEXTFLOW" | sudo -u "$SUDO_USER" tee -a .zshrc > /dev/null
echo "$ALIAS_PYTHON_JUPYTER" | sudo -u "$SUDO_USER" tee -a .zshrc > /dev/null
echo "$ALIAS_PYTHON_DL" | sudo -u "$SUDO_USER" tee -a .zshrc > /dev/null
echo "$ALIAS_R" | sudo -u "$SUDO_USER" tee -a .zshrc > /dev/null
echo "$ALIAS_SNAKEMAKE" | sudo -u "$SUDO_USER" tee -a .zshrc > /dev/null
echo "$ALIAS_CODE_LINT" | sudo -u "$SUDO_USER" tee -a .zshrc > /dev/null
echo "$ALIAS_SC4DA" | sudo -u "$SUDO_USER" tee -a .zshrc > /dev/null
echo $SEP

# prepare the desktop environment
date
echo "Preparing desktop environment"
#RESOLUTION=$(xdpyinfo | awk '/dimensions/{print $2}')
sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.interface icon-theme Adwaita
sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.screensaver picture-uri \
    file://"$INSTALL_DIR"/../ubuntu-wallpaper-3840x2160.jpg
sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.background picture-uri \
    file://"$INSTALL_DIR"/../ubuntu-wallpaper-3840x2160.jpg
sudo -u "$SUDO_USER" gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
sudo -u "$SUDO_USER" gsettings set org.gnome.nautilus.list-view default-zoom-level 'small'
sudo -u "$SUDO_USER" gsettings set org.gnome.gnome-flashback.desktop.icons show-home false
sudo -u "$SUDO_USER" gsettings set org.gnome.gnome-flashback.desktop.icons show-trash false
cp "$INSTALL_DIR"/maciek-gnome-flashback.layout /usr/share/gnome-panel/layouts/maciek-gnome-flashback.layout
sudo -u "$SUDO_USER" dconf reset -f /org/gnome/gnome-panel/
sudo -u "$SUDO_USER" gsettings set org.gnome.gnome-panel.general default-layout "maciek-gnome-flashback"
echo $SEP

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


###############################################################################
# Future releases:
# * add repo with vim configuration (shellcheck all -> GitHub Release)
###############################################################################
