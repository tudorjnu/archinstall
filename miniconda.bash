#!/bin/bash

# miniconda
read -p "Do you want to install Miniconda using curl? [y/N]: " install_miniconda
if [[ $install_miniconda =~ ^[Yy] ]]; then
    echo "Installing Miniconda..."

  # installing miniconda
  mkdir -p ~/.miniconda3
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/.miniconda3/miniconda.sh
  bash ~/.miniconda3/miniconda.sh -b -u -p ~/.miniconda3
  rm -rf ~/.miniconda3/miniconda.sh
  ~/.miniconda3/bin/conda init bash
  source .bashrc
  conda config --set auto_activate_base false

    echo "Miniconda installation complete."
else
    echo "Skipping Miniconda installation."
fi
