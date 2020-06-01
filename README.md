# Setup instructions for a fresh OS
*Maciek Bak*  

This is a very small repository of mine which allows me to quickly re-create my working environment completely from scratch.  
Contains config files, external repos, software installation commands and much more!  
No more pain after re-installing the operating system :wink:

## Install Git

[Git](https://git-scm.com/) is an open source version control system. In principle one can download this repository manually, as a compressed package, but I highly recommend to install `git` first and then use it to pull all the files automatically.  

Depending on your operating system please install `git` with one of the following commands:

* Ubuntu-based Linux distributions (installation requires root privileges)
  ```bash
  sudo apt-get install git --yes
  ```

## Clone the repository

Use `git` command to clone this repository into your local machine:
```bash
git clone https://github.com/AngryMaciek/system-setup.git
```

## Execute setup script

Depending on your operating system please execute one of the following installation scripts (requires root privileges):

* Linux: Ubuntu Focal Fossa (20.04 LTS)  
  **Installation requires at least 6GB of RAM and 30GB free disk space**  
  ```bash
  sudo bash system-setup/UbuntuFocalFossa/install.sh 2>&1 | tee system-setup/setup.log
  ```

## License

MIT License
