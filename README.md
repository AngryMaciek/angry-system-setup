# Setup instructions for a fresh OS
*Maciek Bak*  

[description]

## Install Git

[Git](https://git-scm.com/) is an open source version control system. In principle one can download this repository manually, as a compressed package, but I highly recommend to install `git` first and then use it to pull all the files automatically.  

Please install `git` with one of the following commands:

* Ubuntu-based Linux distributions (installation requires root privileges)
  ```bash
  sudo apt-get install git
  ```

## Clone the repository

Use `git` command to clone this repository into your local machine:
```bash
git clone https://github.com/AngryMaciek/system-setup.git
```

## Execute setup script

Depending on your operating system please execute one of the following installation scripts:

* Ubuntu-based Linux distributions (execution requires root privileges)
  ```bash
  bash system-setup/install-ubuntu.sh
  ```

## License

MIT License

## Future releases

* add instructions for macOS
