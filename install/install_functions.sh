#!/bin/bash
#
# Shared helpers for install.sh. Sourced, not executed directly.

# Detects the current OS and, on Linux, the distro family.
# Sets the global OS_FAMILY to one of: fedora, ubuntu, arch, macos.
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
          arch) OS_FAMILY="arch" ;;
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
    arch)   sudo pacman -S --needed --noconfirm "$pkg_name" ;;
    macos)  brew install "$pkg_name" ;;
  esac
}

# Installs an AUR package with yay (Arch/omarchy only), skipping it if
# already installed. Usage: aur_f <package-name>
function aur_f {
  local pkg_name="$1"

  if pacman -Qq "$pkg_name" &> /dev/null; then
    echo "Already installed (aur): ${pkg_name}"
    return 0
  fi

  echo "Installing (aur): ${pkg_name}..."
  yay -S --needed --noconfirm "$pkg_name"
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

# Returns success if $1 is among the remaining args.
function _array_contains {
  local needle="$1"
  shift
  local x
  for x in "$@"; do
    [ "$x" = "$needle" ] && return 0
  done
  return 1
}

# Symlinks this repo's configs/ into $HOME, one app at a time. Safe to
# re-run (see link_f) - relinking an app doesn't touch the others, and
# relinking everything is a no-op wherever a link is already correct.
# Relies on REPO_DIR being set by the caller.
# Usage: link_configs [app...]  - with no app names, links all of them.
function link_configs {
  local known_apps=(zsh git kitty zed tmux nvim vscode)
  local apps=("$@")
  local configs_dir="$REPO_DIR/configs"

  if [ ${#apps[@]} -eq 0 ]; then
    apps=("${known_apps[@]}")
  fi

  local a
  for a in "${apps[@]}"; do
    if ! _array_contains "$a" "${known_apps[@]}"; then
      echo "Unknown app: ${a} (known: ${known_apps[*]})" >&2
      exit 1
    fi
  done

  if _array_contains zsh "${apps[@]}"; then
    link_f "$configs_dir/zsh/zshrc" "$HOME/.zshrc"
    mkdir -p "$HOME/.zsh"
  fi

  if _array_contains git "${apps[@]}"; then
    link_f "$configs_dir/git/gitconfig" "$HOME/.gitconfig"
    link_f "$configs_dir/git/gitignore_global" "$HOME/.gitignore_global"
  fi

  if _array_contains kitty "${apps[@]}"; then
    # kitty on macOS is documented to also check ~/Library/Preferences/kitty,
    # but in practice it unreliably resolves symlinks placed there (see
    # https://github.com/kovidgoyal/kitty/issues/1331) - ~/.config/kitty is
    # the path that actually works, on macOS same as Linux.
    local kitty_config_dir="$HOME/.config/kitty"
    link_f "$configs_dir/kitty/kitty.conf" "$kitty_config_dir/kitty.conf"
    # kitty resolves `include` paths relative to kitty.conf's own directory
    # without following symlinks, so every file it includes needs its own
    # symlink alongside it too - see docs/apps.md.
    # Forest is skipped on Arch/omarchy (theme there is decided later);
    # kitty ignores an `include` of a missing file.
    if [ "${OS_FAMILY:-}" != "arch" ]; then
      link_f "$configs_dir/kitty/forest.conf" "$kitty_config_dir/forest.conf"
    fi
    link_f "$configs_dir/kitty/keybindings-macos.conf" "$kitty_config_dir/keybindings-macos.conf"
    link_f "$configs_dir/kitty/keybindings-linux.conf" "$kitty_config_dir/keybindings-linux.conf"
  fi

  if _array_contains zed "${apps[@]}"; then
    # Zed uses ~/.config/zed on every OS, macOS included - no OS branching
    # needed here (unlike kitty).
    link_f "$configs_dir/zed/settings.json" "$HOME/.config/zed/settings.json"
    link_f "$configs_dir/zed/themes/forest.json" "$HOME/.config/zed/themes/forest.json"
  fi

  if _array_contains tmux "${apps[@]}"; then
    link_f "$configs_dir/tmux/tmux.conf" "$HOME/.tmux.conf"
    # ~/.local/bin is already on PATH via zshrc.
    mkdir -p "$HOME/.local/bin"
    link_f "$configs_dir/tmux/tmux-sessionize.sh" "$HOME/.local/bin/tmux-sessionize"
  fi

  if _array_contains nvim "${apps[@]}"; then
    link_f "$configs_dir/nvim" "$HOME/.config/nvim"
  fi

  if _array_contains vscode "${apps[@]}"; then
    local vscode_user_dir
    if [ "${OS_FAMILY:-}" = "macos" ]; then
      vscode_user_dir="$HOME/Library/Application Support/Code/User"
    else
      vscode_user_dir="$HOME/.config/Code/User"
    fi
    link_f "$configs_dir/vscode/settings.json" "$vscode_user_dir/settings.json"
    # Local theme extension: VSCode picks up any folder in ~/.vscode/extensions.
    link_f "$configs_dir/vscode/customforest" "$HOME/.vscode/extensions/local.customforest-0.0.1"
  fi
}

# Installs VSCode natively (no flatpak) via the OS's own mechanism:
# Microsoft's repo on Fedora/Ubuntu, AUR on Arch, a cask on macOS.
# Idempotent: skips if `code` is already on PATH.
function install_vscode {
  if which code &> /dev/null; then
    echo "Already installed: code"
    return 0
  fi

  echo "Installing: vscode..."
  case "$OS_FAMILY" in
    fedora)
      sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
      printf '[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n' \
        | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
      sudo dnf install -y code
      ;;
    ubuntu)
      sudo mkdir -p -m 755 /etc/apt/keyrings
      wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/packages.microsoft.gpg > /dev/null
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
      sudo apt update
      sudo apt install -y code
      ;;
    arch)
      aur_f visual-studio-code-bin
      ;;
    macos)
      cask_f visual-studio-code
      ;;
  esac
}

# Installs every extension listed in configs/vscode/extensions.txt (one ID
# per line, # comments allowed) that isn't installed yet.
# Relies on REPO_DIR. No-op if `code` isn't on PATH.
function install_vscode_extensions {
  local list="$REPO_DIR/configs/vscode/extensions.txt"

  if ! which code &> /dev/null; then
    echo "code not on PATH, skipping VSCode extensions" >&2
    return 0
  fi

  local installed ext
  installed="$(code --list-extensions)"
  while read -r ext; do
    ext="${ext%%#*}"
    ext="$(echo "$ext" | xargs)"
    [ -z "$ext" ] && continue
    if echo "$installed" | grep -qixF "$ext"; then
      echo "Already installed (vscode ext): ${ext}"
    else
      code --install-extension "$ext"
    fi
  done < "$list"
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
  tmp_zip="$(mktemp "${TMPDIR:-/tmp}/dotfiles-font.XXXXXX.zip")"
  curl -fsSL -o "$tmp_zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/${font_name}.zip"
  mkdir -p "$dest_dir"
  unzip -oq "$tmp_zip" -d "$dest_dir"
  rm "$tmp_zip"

  if [ "$OS_FAMILY" != "macos" ]; then
    fc-cache -f "$dest_dir" > /dev/null
  fi
}

# Installs Happ (Xray-based proxy/VPN client). No flatpak/cask/repo exists
# for it - only .deb/.rpm/.dmg on its GitHub releases - so this pulls the
# latest release asset for the current OS directly.
function install_happ {
  if which happ &> /dev/null || [ -d "/Applications/Happ.app" ]; then
    echo "Already installed: happ"
    return 0
  fi

  echo "Installing: happ..."
  local base_url="https://github.com/Happ-proxy/happ-desktop/releases/latest/download"

  case "$OS_FAMILY" in
    fedora)
      local tmp_rpm
      tmp_rpm="$(mktemp "${TMPDIR:-/tmp}/dotfiles-happ.XXXXXX.rpm")"
      curl -fsSL -o "$tmp_rpm" "${base_url}/Happ.linux.x64.rpm"
      sudo dnf install -y "$tmp_rpm"
      rm "$tmp_rpm"
      ;;
    ubuntu)
      local tmp_deb
      tmp_deb="$(mktemp "${TMPDIR:-/tmp}/dotfiles-happ.XXXXXX.deb")"
      curl -fsSL -o "$tmp_deb" "${base_url}/Happ.linux.x64.deb"
      sudo apt install -y "$tmp_deb"
      rm "$tmp_deb"
      ;;
    macos)
      local tmp_dmg mount_point
      tmp_dmg="$(mktemp "${TMPDIR:-/tmp}/dotfiles-happ.XXXXXX.dmg")"
      curl -fsSL -o "$tmp_dmg" "${base_url}/Happ.macOS.universal.dmg"
      mount_point="$(mktemp -d)"
      hdiutil attach "$tmp_dmg" -mountpoint "$mount_point" -nobrowse -quiet
      cp -R "$mount_point"/Happ.app /Applications/
      hdiutil detach "$mount_point" -quiet
      rm "$tmp_dmg"
      rmdir "$mount_point"
      ;;
  esac
}

# --- Keyboard layouts ------------------------------------------------------
# Same behaviour everywhere: layouts us + ru, capslock as left Ctrl,
# alt+shift cycles layouts, ctrl+shift+1 -> us, ctrl+shift+2 -> ru.
# See docs/keyboard.md.

function setup_keyboard_kde {
  local kwrite
  kwrite="$(which kwriteconfig6 2> /dev/null || which kwriteconfig5 2> /dev/null || true)"
  if [ -z "$kwrite" ]; then
    echo "kwriteconfig not found, skipping KDE keyboard setup" >&2
    return 0
  fi

  "$kwrite" --file kxkbrc --group Layout --key Use true
  "$kwrite" --file kxkbrc --group Layout --key LayoutList us,ru
  "$kwrite" --file kxkbrc --group Layout --key VariantList ,
  "$kwrite" --file kxkbrc --group Layout --key ResetOldOptions true
  "$kwrite" --file kxkbrc --group Layout --key Options ctrl:nocaps,grp:alt_shift_toggle

  "$kwrite" --file kglobalshortcutsrc --group "KDE Keyboard Layout Switcher" \
    --key "Switch keyboard layout to English (US)" "Ctrl+Shift+1,none,Switch keyboard layout to English (US)"
  "$kwrite" --file kglobalshortcutsrc --group "KDE Keyboard Layout Switcher" \
    --key "Switch keyboard layout to Russian" "Ctrl+Shift+2,none,Switch keyboard layout to Russian"

  # Ask the running session to pick the new config up; harmless if it fails.
  dbus-send --session --type=signal /Layouts org.kde.keyboard.reloadConfig 2> /dev/null || true
}

# Written blind - not verifiable on the dev machine (see docs/keyboard.md).
function setup_keyboard_gnome {
  if ! which gsettings &> /dev/null; then
    echo "gsettings not found, skipping GNOME keyboard setup" >&2
    return 0
  fi

  gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ru')]"
  gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps', 'grp:alt_shift_toggle']"

  # ctrl+shift+1/2 as custom shortcuts that select the layout by index.
  local base="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
  local schema="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"
  local name binding idx
  local existing
  existing="$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)"
  local paths="$existing"

  for idx in 0 1; do
    if [ "$idx" = 0 ]; then name="dotfiles-kbd-us"; binding="<Primary><Shift>1"; else name="dotfiles-kbd-ru"; binding="<Primary><Shift>2"; fi
    gsettings set "$schema:$base/$name/" name "Layout $name"
    gsettings set "$schema:$base/$name/" command "gsettings set org.gnome.desktop.input-sources current $idx"
    gsettings set "$schema:$base/$name/" binding "$binding"
    if ! echo "$paths" | grep -q "$base/$name/"; then
      if [ "$paths" = "@as []" ] || [ "$paths" = "[]" ]; then
        paths="['$base/$name/']"
      else
        paths="${paths%]}, '$base/$name/']"
      fi
    fi
  done

  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$paths"
}

# Written blind - not verifiable on the dev machine (see docs/keyboard.md).
function setup_keyboard_hyprland {
  local hypr_dir="$HOME/.config/hypr"
  local main_conf="$hypr_dir/hyprland.conf"
  local snippet="$hypr_dir/dotfiles-keyboard.conf"
  local source_line="source = $snippet"

  link_f "$REPO_DIR/configs/hyprland/keyboard.conf" "$snippet"

  if [ ! -f "$main_conf" ]; then
    echo "WARNING: $main_conf not found - keyboard.conf is linked but NOT loaded; add '${source_line}' by hand" >&2
  elif ! grep -qxF "$source_line" "$main_conf"; then
    echo "$source_line" >> "$main_conf"
    echo "Added to hyprland.conf: ${source_line}"
  fi

  if grep -rhE '^\s*bind\s*=\s*(CTRL SHIFT|SHIFT CTRL|CONTROL SHIFT), *[12]\b' "$hypr_dir" --include='*.conf' --exclude=dotfiles-keyboard.conf 2> /dev/null | grep -q .; then
    echo "WARNING: existing Hyprland binds on ctrl+shift+1/2 found in $hypr_dir - they may conflict" >&2
  fi

  if which hyprctl &> /dev/null && [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    hyprctl reload > /dev/null || true
  fi
}

# Picks the right setup by the running desktop; unknown desktops are skipped.
function setup_keyboard {
  case "${XDG_CURRENT_DESKTOP:-}" in
    *KDE*)      setup_keyboard_kde ;;
    *GNOME*)    setup_keyboard_gnome ;;
    *Hyprland*) setup_keyboard_hyprland ;;
    *) echo "No keyboard setup for desktop '${XDG_CURRENT_DESKTOP:-unknown}', skipping" ;;
  esac
}
