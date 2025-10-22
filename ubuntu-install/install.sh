#!/bin/bash

. install_functions.sh

dir=$PWD

sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

sudo apt install nala -y
sudo nala fetch --ubuntu --auto --fetches=5

install_f git
install_f apt-transport-https
install_f ca-certificates
install_f curl
install_f wget
install_f software-properties-common
install_f gnome-tweaks
install_f gnome-shell-extension-manager
install_f gdebi
install_f unrar
install_f unzip
install_f gcc 
install_f make 
install_f bzip2
install_f tar

sudo snap install bitwarden
sudo snap install telegram-desktop
sudo snap install spotify
sudo snap install code --classic
sudo snap install steam

for f in programms/*.sh; do bash "$f" -H; done

rm $(realpath ~)/.gitconfig
ln -s $(realpath gitconfig) $(realpath ~)/.gitconfig

cd dir
dconf load /org/gnome/terminal/ < gnome-terminal-backup.txt

# Set zsh as default shell
chsh -s $(which zsh)
