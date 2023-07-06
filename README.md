# Setup instructions for a fresh AngryOS
*Maciek Bak*  

This repository allows me to quickly re-create my working environment completely from scratch.  
Contains config files, external repos, software installation commands and much more!  
No more pain after re-installing the operating system :wink:

## Install Git

Ubuntu-based Linux distributions (installation requires root privileges)
```bash
sudo apt-get install git --yes
```

## Clone the repository

Use `git` command to clone this repository into your local machine:
```bash
git clone https://github.com/AngryMaciek/angry-system-setup.git
```

## Execute setup script

* Linux: Ubuntu Focal Fossa (20.04 LTS)  
  **Installation requires at least 4GB of RAM**  
  ```bash
  sudo bash angry-system-setup/UbuntuFocalFossa/install.sh 2>&1 | tee angry-system-setup/setup.log
  ```

## License

MIT License
