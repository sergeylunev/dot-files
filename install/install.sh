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
install_f nvim neovim
install_f kitty

# Containers - Podman everywhere instead of Docker (daemonless, rootless,
# free at any scale, docker-CLI-compatible)
install_f podman
install_f podman-compose

if [ "$OS_FAMILY" = "macos" ]; then
  # macOS has no native container support - Podman needs its little VM.
  if ! podman machine list --format '{{.Name}}' 2>/dev/null | grep -q .; then
    podman machine init
  fi
  podman machine start 2>/dev/null || true
fi

# Nerd Font, same download-and-extract mechanism on every OS
install_nerd_font JetBrainsMono v3.4.0

# Happ - VPN/proxy client, same GitHub-release install on every OS
install_happ

# --- OS-specific extras --------------------------------------------------
# Add machine/OS-specific software here as needed; these blocks are
# intentionally separate so one OS's extras never run on another.

case "$OS_FAMILY" in
  fedora)
    install_f gnome-tweaks

    ensure_flatpak
    flatpak_f app.zen_browser.zen        # browser (primary)
    flatpak_f org.chromium.Chromium      # browser (secondary; no clean Thorium package on Fedora)
    flatpak_f dev.zed.Zed                # editor
    flatpak_f com.bitwarden.desktop      # password manager
    flatpak_f org.telegram.desktop       # communication
    flatpak_f it.mijorus.gearlever       # AppImage integration
    flatpak_f com.valvesoftware.Steam    # gaming
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
    sudo snap install steam

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

    # Zen Browser and Zed - flatpak, same app IDs as Fedora
    ensure_flatpak
    flatpak_f app.zen_browser.zen
    flatpak_f dev.zed.Zed
    flatpak_f it.mijorus.gearlever       # AppImage integration, replaces AppImageLauncher

    # Thorium browser (secondary) - has an actual apt repo, unlike Fedora
    if ! which thorium-browser &> /dev/null; then
      sudo wget --no-hsts -O /etc/apt/sources.list.d/thorium.list http://dl.thorium.rocks/debian/dists/stable/thorium.list
      sudo apt update
      sudo apt install -y thorium-browser
    fi

    # Gnome Terminal profile
    dconf load /org/gnome/terminal/ < "$REPO_DIR/gnome-terminal-backup.txt"
    ;;

  macos)
    cask_f zen                # browser (primary)
    cask_f chromium           # browser (secondary; Thorium's cask is broken/deprecated)
    cask_f zed                # editor
    cask_f bitwarden          # password manager
    cask_f telegram           # communication
    cask_f steam              # gaming
    ;;
esac

# --- oh-my-zsh -----------------------------------------------------------

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended
fi

# --- Dotfiles symlinks -----------------------------------------------------

link_f "$REPO_DIR/zshrc" "$HOME/.zshrc"
mkdir -p "$HOME/.zsh"

if [ "$OS_FAMILY" = "macos" ]; then
  link_f "$REPO_DIR/kitty.conf" "$HOME/Library/Preferences/kitty/kitty.conf"
else
  link_f "$REPO_DIR/kitty.conf" "$HOME/.config/kitty/kitty.conf"
fi

# nvim/ from this repo is not wired in yet - Neovim above is installed as a
# bare binary only. See README.

# Set zsh as the default shell (takes effect after re-login)
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
fi

echo "Done."
