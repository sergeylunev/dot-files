#!/bin/bash
#
# Shared helpers for install.sh. Sourced, not executed directly.

# Detects the current OS and, on Linux, the distro family.
# Sets the global OS_FAMILY to one of: fedora, ubuntu, macos.
# Exits with an error on anything else, so the rest of the script
# never has to guess.
function detect_os {
  case "$(uname -s)" in
    Darwin)
      OS_FAMILY="macos"
      ;;
    Linux)
      if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
          fedora) OS_FAMILY="fedora" ;;
          ubuntu) OS_FAMILY="ubuntu" ;;
          *)
            echo "Unsupported Linux distro: $ID" >&2
            exit 1
            ;;
        esac
      else
        echo "Cannot detect Linux distro: /etc/os-release missing" >&2
        exit 1
      fi
      ;;
    *)
      echo "Unsupported OS: $(uname -s)" >&2
      exit 1
      ;;
  esac

  echo "Detected OS: ${OS_FAMILY}"
}

# Installs a package with the package manager for the detected OS,
# skipping it if a binary with the same name is already on PATH.
# Usage: install_f <binary-name-to-check> [package-name-if-different]
function install_f {
  local bin_name="$1"
  local pkg_name="${2:-$1}"

  if which "$bin_name" &> /dev/null; then
    echo "Already installed: ${bin_name}"
    return 0
  fi

  echo "Installing: ${pkg_name}..."
  case "$OS_FAMILY" in
    fedora) sudo dnf install -y "$pkg_name" ;;
    ubuntu) sudo nala install -y "$pkg_name" ;;
    macos)  brew install "$pkg_name" ;;
  esac
}

# Symlinks $1 -> $2, backing up whatever is already at $2 (file, dir,
# or stale symlink) to $2.bak-<timestamp> first. Safe to re-run: if
# $2 already points at $1, it's a no-op.
function link_f {
  local src="$1"
  local dest="$2"

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "Already linked: ${dest}"
    return 0
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local backup="${dest}.bak-$(date +%Y%m%d%H%M%S)"
    echo "Backing up existing ${dest} -> ${backup}"
    mv "$dest" "$backup"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "Linked: ${dest} -> ${src}"
}

# Makes sure flatpak itself (and the Flathub remote) are set up.
# Linux-only; no-op if OS_FAMILY is macos.
function ensure_flatpak {
  [ "$OS_FAMILY" = "macos" ] && return 0

  install_f flatpak
  if ! flatpak remote-list | grep -q '^flathub'; then
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  fi
}

# Installs a Flatpak app by its application ID, skipping it if already
# installed. Usage: flatpak_f <app-id>
function flatpak_f {
  local app_id="$1"

  if flatpak list --app --columns=application | grep -qx "$app_id"; then
    echo "Already installed (flatpak): ${app_id}"
    return 0
  fi

  echo "Installing (flatpak): ${app_id}..."
  flatpak install -y flathub "$app_id"
}

# Installs a Homebrew cask, skipping it if already installed.
# macOS-only. Usage: cask_f <cask-name>
function cask_f {
  local cask="$1"

  if brew list --cask "$cask" &> /dev/null; then
    echo "Already installed (cask): ${cask}"
    return 0
  fi

  echo "Installing (cask): ${cask}..."
  brew install --cask "$cask"
}

# Downloads and installs a Nerd Font from the upstream GitHub release zip.
# Same mechanism on every OS - no COPR/tap dependency. Idempotent: skips
# if the font's directory already exists.
# Usage: install_nerd_font <name-in-release-url, e.g. JetBrainsMono> <version, e.g. v3.4.0>
function install_nerd_font {
  local font_name="$1"
  local version="$2"
  local dest_dir

  if [ "$OS_FAMILY" = "macos" ]; then
    dest_dir="$HOME/Library/Fonts/${font_name}NerdFont"
  else
    dest_dir="$HOME/.local/share/fonts/${font_name}NerdFont"
  fi

  if [ -d "$dest_dir" ]; then
    echo "Already installed (font): ${font_name}"
    return 0
  fi

  echo "Installing (font): ${font_name}..."
  local tmp_zip
  tmp_zip="$(mktemp --suffix=.zip)"
  curl -fsSL -o "$tmp_zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/${font_name}.zip"
  mkdir -p "$dest_dir"
  unzip -oq "$tmp_zip" -d "$dest_dir"
  rm "$tmp_zip"

  if [ "$OS_FAMILY" != "macos" ]; then
    fc-cache -f "$dest_dir" > /dev/null
  fi
}
