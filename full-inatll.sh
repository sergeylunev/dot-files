#!/usr/bin/bash

sudo apt install git --yes
cd $(ralpath ~)
mkdir Projects
cd Projects
git clone https://github.com/sergeylunev/dot-files
cd dot-files/ubuntu-install
bash install.sh