# Setup instructions for a fresh OS
*Maciek Bak*  

[description]

## Install Git

## Clone the repository

Use `git` command to clone this repository into your local machine:
```bash
git clone https://github.com/AngryMaciek/system-setup.git
```

## Execute installation script

Depending on your operating system please execute one of the following installation scripts.

Ubuntu-based Linux distributions:
```bash
bash system-setup/install-ubuntu.sh
```

## License

MIT License

## Future releases

* add instructions for macOS




# Pylint config file
*Maciej_Bak  
Swiss_Institute_of_Bioinformatics*

[Pylint](https://www.pylint.org/) is a very powerful software to rate the quality of your Python code.
This small repository contains just my configuration file for the analyses.
It was generated based on `pylint 2.3.1`.

In order to use it (assuming you have installed the tool itself): 

1. Clone the repository
   ```bash
   cd;
   git clone https://github.com/AngryMaciek/custom_pylintrc.git;
   ```

2. Provide the path to the config file for each `pylint` execution:

   ```bash
   pylint --rcfile=$HOME/custom_pylintrc/pylintrc {FILE}
   ```
