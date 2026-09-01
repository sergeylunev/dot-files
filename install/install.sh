#!/bin/bash
#
# Bootstraps a Fedora, Ubuntu or macOS machine from this dot-files repo.
# Safe to re-run: every step either checks "already done" or backs up
# whatever it's about to replace.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

. "$SCRIPT_DIR/install_functions.sh"

detect_os

# --- System package manager update -----------------------------------

case "$OS_FAMILY" in
  fedora)
    sudo dnf upgrade -y
    ;;
  ubuntu)
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt autoremove -y
    sudo apt install nala -y
    sudo nala fetch --ubuntu --auto --fetches=5
    ;;
  macos)
    if ! which brew &> /dev/null; then
      echo "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew update
    ;;
esac

# --- Base tools, same set on every OS ----------------------------------

install_f git
install_f curl
install_f wget
install_f zsh
install_f vim
install_f unzip
install_f gcc
install_f make
install_f gh

# --- OS-specific extras --------------------------------------------------
# Add machine/OS-specific software here as needed; these blocks are
# intentionally separate so one OS's extras never run on another.

case "$OS_FAMILY" in
  fedora)
    install_f gnome-tweaks
    ;;

  ubuntu)
    install_f apt-transport-https
    install_f ca-certificates
    install_f software-properties-common
    install_f gdebi
    install_f unrar
    install_f bzip2
    install_f tar
    install_f gnome-tweaks
    sudo apt install -y gnome-shell-extension-manager

    sudo snap install go --classic
    sudo snap install bitwarden
    sudo snap install telegram-desktop
    sudo snap install code --classic
    sudo snap install obsidian --classic
    sudo snap install steam

    # Docker
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    if ! which docker-desktop &> /dev/null; then
      tmp_deb="$(mktemp --suffix=.deb)"
      wget -O "$tmp_deb" https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb
      sudo gdebi --non-interactive "$tmp_deb"
      rm "$tmp_deb"
      systemctl --user enable docker-desktop
    fi

    # GitHub CLI apt repo (install_f alone won't add the repo)
    if ! which gh &> /dev/null; then
      sudo mkdir -p -m 755 /etc/apt/keyrings
      out=$(mktemp)
      wget -nv -O "$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg
      cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
      sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
      sudo mkdir -p -m 755 /etc/apt/sources.list.d
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
      sudo apt update
      sudo apt install gh -y
    fi

    # AppImageLauncher
    if ! dpkg -l appimagelauncher &> /dev/null; then
      tmp_deb="$(mktemp --suffix=.deb)"
      wget -O "$tmp_deb" https://github.com/TheAssassin/AppImageLauncher/releases/download/v3.0.0-beta-2/appimagelauncher_3.0.0-beta-2-gha280.e110527_amd64.deb
      sudo gdebi --non-interactive "$tmp_deb"
      rm "$tmp_deb"
    fi

    # BebraVPN client - download only, needs manual install from ~/Downloads
    mkdir -p "$HOME/Downloads"
    wget -O "$HOME/Downloads/Bebra.AppImage" https://amazonvpn.s3.amazonaws.com/Bebra.AppImage

    # Gnome Terminal profile
    dconf load /org/gnome/terminal/ < "$REPO_DIR/gnome-terminal-backup.txt"

    # JetBrains Nerd Font
    if [ ! -d "$HOME/.fonts/JetBrainsMono" ]; then
      tmp_zip="$(mktemp --suffix=.zip)"
      wget -O "$tmp_zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
      mkdir -p "$HOME/.fonts/JetBrainsMono"
      unzip -o "$tmp_zip" -d "$HOME/.fonts/JetBrainsMono"
      rm "$tmp_zip"
      fc-cache -fv
    fi
    ;;

  macos)
    # brew cask apps go here, e.g.:
    # brew install --cask bitwarden telegram visual-studio-code obsidian steam
    ;;
esac

# --- oh-my-zsh -----------------------------------------------------------

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended
fi

# --- Dotfiles symlinks -----------------------------------------------------

link_f "$REPO_DIR/zshrc" "$HOME/.zshrc"
mkdir -p "$HOME/.zsh"

# Set zsh as the default shell (takes effect after re-login)
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
fi

echo "Done."
