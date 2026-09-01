Dot Files
=========

System configuration files, for Fedora, Ubuntu and macOS.

## Quick install

```bash
bash -c "$(wget https://raw.githubusercontent.com/sergeylunev/dot-files/master/full-install.sh -O -)"
```

This clones the repo into `~/Projects/dot-files` and runs `install/install.sh`,
which detects your OS and:

- installs the base toolset (git, zsh, vim, curl, wget, gh, ...) through the
  right package manager (`dnf` / `apt` via `nala` / `brew`);
- runs any OS-specific extras (see `install/install.sh` for what each OS gets);
- installs oh-my-zsh if it isn't already there;
- symlinks `zshrc` to `~/.zshrc` (backing up whatever was there first);
- sets zsh as the default shell.

Safe to re-run: every step checks whether it's already done before doing it,
and anything it's about to overwrite gets backed up first (`<file>.bak-<timestamp>`).

## What's in here

### `zshrc`
zsh config, built on [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh). Installed
automatically by `install/install.sh`. To link it by hand:

    ln -sf ~/PATH_TO_DOTFILES/zshrc ~/.zshrc
    mkdir -p ~/.zsh

### `gitconfig`
Git config — aliases, user info. Not currently wired into `install/install.sh`
(it needs a pass to catch up with the machine's actual git setup first). To
link it by hand:

    ln -sf ~/PATH_TO_DOTFILES/gitconfig ~/.gitconfig

### `gitignore_global`
Global gitignore (OS cruft, editor files, common build dirs). Referenced from
`gitconfig`'s `core.excludesfile`, so it only takes effect once `gitconfig` is
linked in.

### `kitty.conf`
Config for the [kitty](https://sw.kovidgoyal.net/kitty/) terminal. Kept for
future use — not currently installed or linked by `install/install.sh`.

    ln -sf ~/PATH_TO_DOTFILES/kitty.conf ~/.config/kitty/kitty.conf

### `nvim/`
Neovim config (lsp, cmp, telescope, treesitter, ...). Kept for future use —
Neovim isn't currently installed or linked by `install/install.sh`.

    ln -sf ~/PATH_TO_DOTFILES/nvim ~/.config/nvim

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
