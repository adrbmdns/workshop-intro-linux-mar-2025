# Step 2 - Installing software needed for the variant calling pipeline

* Install Anaconda
* Create a conda environment
* Install packages using conda
* Download data 
* Install IGV 

## Install Anaconda

__Anaconda__ is an open-source package and environment management system commonly used in data science, scientific computing, and machine learning projects. It allows you to install, update, and manage software packages and dependencies for your projects. It supports packages written in various programming languages, with a focus on Python packages. 

We will use Anaconda as the software management system to install all the packages that are needed for our variant calling workflow. 

__For Windows Users:__

You need to download and install Anaconda in __WSL__. So the first step is to open the Ubuntu App. Then, run the following commands:

```sh 
# change directory to home 
cd ~

# wget is a command to download files from the internet
wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh

# run the installer to install 
bash Anaconda3-2024.10-1-Linux-x86_64.sh 
```

You will be prompted with some questions in the installation process, press `enter` or type `yes` then `enter` to continue. When you see `--MORE--` at the bottom of the terminal, press `space` bar to move to the next page of the document. When you are asked to decide the installation location, just press `enter` to use the default path. After the installation finishes, use `exit` command to exit the terminal and restart a new one.

In the terminal, run the following command to check if conda has been successfully installed:

```sh
conda --version
```

You should see `conda 24.10.1` printed on the screen.

__For MacOS Users:__

Go to this [page](https://www.anaconda.com/download/success) and pick the suitable installer for your device, choose the graphical installer. Follow the instructions to install, when it asks you to select destination, please chosse `Install for me only`. 

After installation, open a new terminal and run the following code to check if Anaconda has been successfully installed. 

```sh
conda --version 
```

You should see a version number printed on your screen. 

## Set up conda channels 

A __Conda channel__ is a repository where conda packages are stored and from which conda downloads and installs packages. Channels are hosted on platforms like __Anaconda Cloud__ and can contain different versions of software for various platforms. Popular channels include `defaults`, `conda-forge`, and `bioconda`. We are going to set up our conda channels to the order of `conda-forge -> bioconda -> defaults`. 

__First, check your current channels:__

```sh
conda config --show channels
```

Output might look like this:

```
channels:
  - defaults
```
__Add new channels:__

We are going to add both `conda-forge` and `bioconda`.

```sh
conda config --add channels bioconda
conda config --add channels conda-forge
```

Now, check again:

```sh
conda config --show channels
```

Expected output:

```
channels:
  - conda-forge
  - bioconda
  - defaults
```

Channels are checked in order from top to bottom, so `conda-forge` will be prioritised. 

## Create a new conda environment 

A conda environment is a self-contained directory that contains a specific collection of software packages, along with the necessary dependencies and their respective versions. Using conda environments can avoid conflicts between projects or applications that may require different versions of libraries or dependencies. This isolation ensures that your projects have a consistent and reproducible environment, making it easier to share and collaborate with others. 

In this workshop, we will work on a small project where we find the variants of some DNA sequencing data of *E.coli.* This bioinformatic process is called variant calling. So, we can create a new conda environment called `ecoli-vc`, and install the needed packages in this environment. 

__Run the following to create a conda environment:__

```sh
conda create --name ecoli-vc
```