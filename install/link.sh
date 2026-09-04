#!/bin/bash
#
# Symlinks this repo's configs/ into $HOME - nothing else install.sh does
# (no package installs, no oh-my-zsh, no OS-specific extras). Safe to
# re-run: see link_f in install_functions.sh.
#
# Usage:
#   install/link.sh            # link every app's configs
#   install/link.sh kitty      # link only kitty's configs
#   install/link.sh git zsh    # link only git's and zsh's configs

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

. "$SCRIPT_DIR/install_functions.sh"

link_configs "$@"

echo "Done."
