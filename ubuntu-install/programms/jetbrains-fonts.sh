#!/bin/bash

dir=$PWD

cd ~/Downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
mkdir $(realpath ~)/.fonts
mv $(realpath JetBrainsMono.zip) $(realpath ~)/.fonts
cd $(realpath ~)/.fonts
unzip JetBrainsMono.zip
fc-cache -fv

cd dir