#!/bin/bash

. install_functions.sh

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
install_f zsh

sudo snap install bitwarden
sudo snap install telegram-desktop
sudo snap install code --classic
sudo snap install steam

# AppImageLauncher. Helps with installing and handling AppImages
cd $(realpath ~)/Downloads
wget https://github.com/TheAssassin/AppImageLauncher/releases/download/v3.0.0-beta-2/appimagelauncher_3.0.0-beta-2-gha280.e110527_amd64.deb
sudo gdebi --non-interactive appimagelauncher_3.0.0-beta-2-gha280.e110527_amd64.deb 
rm appimagelauncher_3.0.0-beta-2-gha280.e110527_amd64.deb
###

# BebraVPN client
# Need to install it manualy after from ~/Download directory
cd $(realpath ~)/Downloads
wget https://amazonvpn.s3.amazonaws.com/Bebra.AppImage
###

# Install JetBrains Nerd Font
cd $(realpath ~)/Downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
mkdir $(realpath ~)/.fonts
mv $(realpath JetBrainsMono.zip) $(realpath ~)/.fonts
cd $(realpath ~)/.fonts
unzip JetBrainsMono.zip
fc-cache -fv
###

# ZSH and OhMyZSH
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended
cd $(realpath ~)/Projects/dot-files/
ln -s $(realpath zshrc) $(realpath ~)/.zshrc
###

rm $(realpath ~)/.gitconfig
ln -s $(realpath gitconfig) $(realpath ~)/.gitconfig

dconf load /org/gnome/terminal/ < $(realpath ~)/Projects/dot-files/gnome-terminal-backup.txt

# Set zsh as default shell
chsh -s $(which zsh)
