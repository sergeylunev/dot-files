Dot Files
=========

System configuration files, for Fedora, Ubuntu and macOS.

## Quick install

```bash
bash -c "$(wget https://raw.githubusercontent.com/sergeylunev/dot-files/master/full-install.sh -O -)"
```

This clones the repo into `~/Projects/dot-files` and runs `install/install.sh`,
which detects your OS and:

- installs the base toolset (git, zsh, vim, neovim, kitty, curl, wget, gh,
  podman, ...) through the right package manager (`dnf` / `apt` via `nala` /
  `brew`);
- installs the default desktop apps (see table below);
- installs oh-my-zsh if it isn't already there;
- symlinks `zshrc`, `kitty.conf`, `gitconfig` and `gitignore_global`
  (backing up whatever was there first);
- sets zsh as the default shell.

Safe to re-run: every step checks whether it's already done before doing it,
and anything it's about to overwrite gets backed up first (`<file>.bak-<timestamp>`).

### Default desktop apps

| Category | Fedora (KDE) | Ubuntu (GNOME) | macOS |
|---|---|---|---|
| Browser (primary) | Zen (flatpak) | Zen (flatpak) | Zen (brew cask) |
| Browser (secondary) | Chromium (flatpak) | Thorium (apt repo) | Chromium (brew cask) |
| Editor | Zed (flatpak) + bare Neovim | Zed (flatpak) + bare Neovim | Zed (brew cask) + bare Neovim |
| Password manager | Bitwarden (flatpak) | Bitwarden (snap) | Bitwarden (brew cask) |
| Communication | Telegram (flatpak) | Telegram (snap) | Telegram (brew cask) |
| AppImage integration | Gear Lever (flatpak) | Gear Lever (flatpak) | — |
| Containers | Podman + podman-compose | Podman + podman-compose | Podman + podman-compose (+ `podman machine`) |
| Gaming | Steam (flatpak) | Steam (snap) | Steam (brew cask) |
| VPN/proxy | Happ (GitHub release .rpm) | Happ (GitHub release .deb) | Happ (GitHub release .dmg) |
| Font | JetBrains Mono Nerd Font (same download-and-extract on all three) | same | same |

Thorium has no clean Fedora or macOS package (no Flathub flatpak, and its
Homebrew cask is broken/deprecated), so those two fall back to Chromium as
the secondary browser.

Not installed by default: Obsidian, Discord/Slack, Docker (Podman replaces
it), LibreOffice, VLC. `install/cli-toolbelt-candidates.md`
has a shortlist of modern CLI tools (fzf, ripgrep, eza, lazygit, ...) worth
reviewing by hand — none of them are installed automatically either.

## What's in here

### `zshrc`
zsh config, built on [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh). Installed
automatically by `install/install.sh`. To link it by hand:

    ln -sf ~/PATH_TO_DOTFILES/zshrc ~/.zshrc
    mkdir -p ~/.zsh

### `gitconfig`
Git config — aliases, user info, and the `gh` credential helper for
`github.com`/`gist.github.com`. Installed and linked by `install/install.sh`
on all three OSes. `core.editor` is intentionally unset — git falls back to
`$EDITOR`, set in `zshrc`. To link it by hand:

    ln -sf ~/PATH_TO_DOTFILES/gitconfig ~/.gitconfig

### `gitignore_global`
Global gitignore (OS cruft, editor files, common build dirs). Referenced from
`gitconfig`'s `core.excludesfile` as `~/.gitignore_global`. Installed and
linked by `install/install.sh` on all three OSes.

### `kitty.conf`
Config for the [kitty](https://sw.kovidgoyal.net/kitty/) terminal, the default
terminal emulator. Installed and linked by `install/install.sh` on all three
OSes. To link it by hand:

    ln -sf ~/PATH_TO_DOTFILES/kitty.conf ~/.config/kitty/kitty.conf   # Linux
    ln -sf ~/PATH_TO_DOTFILES/kitty.conf ~/Library/Preferences/kitty/kitty.conf   # macOS

### `nvim/`
Neovim config (lsp, cmp, telescope, treesitter, ...). `install/install.sh`
installs the bare `neovim` binary on all three OSes, but does **not** link
this config yet — it needs a pass to bring it up to date first. To link it
by hand once it's ready:

    ln -sf ~/PATH_TO_DOTFILES/nvim ~/.config/nvim

### `install/cli-toolbelt-candidates.md`
A shortlist of modern CLI tools (fzf, ripgrep, eza, zoxide, lazygit,
starship, ...) worth considering for the base toolset — not installed
automatically, just notes to review by hand.

### `gnome-terminal-backup.txt`
A `dconf` dump of GNOME Terminal profiles/settings. Restored automatically by
`install/install.sh` on Ubuntu. To load by hand:

    dconf load /org/gnome/terminal/ < gnome-terminal-backup.txt

### `rmod_kvm.sh`
Small helper to unload the `kvm`/`kvm_intel` kernel modules (e.g. before
starting a VM manager that wants exclusive access to virtualization).

### `install/install.sh` and `install/install_functions.sh`
The OS-aware installer described above. `full-install.sh` at the repo root is
the one-liner bootstrap that clones this repo and kicks it off on a fresh
machine.

## The end
End yes, its all for now.
