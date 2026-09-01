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
