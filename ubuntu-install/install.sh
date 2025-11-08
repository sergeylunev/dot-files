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
install_f vim

sudo snap install go --classic
sudo snap install bitwarden
sudo snap install telegram-desktop
sudo snap install code --classic
sudo snap install obsidian --classic
sudo snap install steam

# Docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

cd $(realpath ~)/Downloads
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb
sudo gdebi --non-interactive docker-desktop-amd64.deb
rm docker-desktop-amd64.deb
# Enable to start on startup
systemctl --user enable docker-desktop
###

# NeoVim install and configure
sudo snap install nvim --classic
git clone https://github.com/sergeylunev/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
###

# GH - github cli tool
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
###

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
rm $(realpath ~)/.zshrc
ln -s $(realpath zshrc) $(realpath ~)/.zshrc
###

# Git config
cd $(realpath ~)/Projects/dot-files/
ln -s $(realpath gitconfig) $(realpath ~)/.gitconfig
###

# Gnome Terminal Config
dconf load /org/gnome/terminal/ < $(realpath ~)/Projects/dot-files/gnome-terminal-backup.txt
###

# Set zsh as default shell
# Will take afect after restart
chsh -s $(which zsh)
