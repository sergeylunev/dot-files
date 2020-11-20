#!/bin/bash

cd ~/Downloads
mkdir JetBrainsMono
cd JetBrainsMono
wget https://download.jetbrains.com/fonts/JetBrainsMono-2.001.zip
unzip JetBrainsMono-2.001.zip
cd ttf
mkdir ~/.local/share/fonts/
mv JetBrainsMono-*.ttf ~/.local/share/fonts/
cd ~/Downloads
rm -rf JetBrainsMono