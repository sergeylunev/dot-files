#!/usr/bin/env bash
#
# One-liner bootstrap: clones this repo and runs install/install.sh.
# Requires git to already be on PATH.

set -euo pipefail

if ! which git &> /dev/null; then
  case "$(uname -s)" in
    Darwin) brew install git ;;
    Linux)
      if [ -f /etc/os-release ] && grep -q '^ID=fedora' /etc/os-release; then
        sudo dnf install -y git
      else
        sudo apt install -y git
      fi
      ;;
    *) echo "git not found and OS not recognized; install it manually first." >&2; exit 1 ;;
  esac
fi

cd "$(realpath ~)"
mkdir -p Projects
cd Projects

if [ ! -d dot-files ]; then
  git clone https://github.com/sergeylunev/dot-files
fi

cd dot-files/install
bash install.sh
