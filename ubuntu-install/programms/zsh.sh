#!/bin/bash

sudo apt install zsh --yes
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended
cd ..
rm $(realpath ~)/.zshrc
ln -s $(realpath zshrc) $(realpath ~)/.zshrc