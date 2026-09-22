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

# detect_os exits on unknown OSes, but linking works anywhere - OS_FAMILY is
# only used for OS-specific link targets, so fall back to unset.
(detect_os > /dev/null 2>&1) && detect_os || echo "Unrecognised OS, linking with generic paths" >&2

link_configs "$@"

echo "Done."
