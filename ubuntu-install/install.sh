#!/bin/bash

. install_functions.sh

dir=$PWD

install_f git
install_f apt-transport-https
install_f ca-certificates
install_f curl
install_f software-properties-common
install_f gnome-tweak-tool
install_f vim
install_f tmux

sudo snap install bitwarden
sudo snap install telegram-desktop
sudo snap install kontena-lens --classic
sudo snap install spotify
sudo snap install phpstorm --classic
sudo snap install code --classic

for f in programs/*.sh; do bash "$f" -H; done

sudo apt upgrade -y
sudo apt autoremove -y

rm $(realpath ~)/.gitconfig
ln -s $(realpath gitconfig) $(realpath ~)/.gitconfig

# Set zsh as default shell
chsh -s $(which zsh)
