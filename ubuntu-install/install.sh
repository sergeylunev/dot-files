#!/bin/bash

. install_functions.sh

dir=$PWD

install git
install apt-transport-https
install ca-certificates
install curl
install software-properties-common
install gnome-tweak-tool
install vim
install tmux

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
