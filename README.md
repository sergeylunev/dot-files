Dot Files
=========

System configuration files, for Fedora, Ubuntu and macOS.

## Quick install

```bash
bash -c "$(wget https://raw.githubusercontent.com/sergeylunev/dot-files/master/full-install.sh -O -)"
```

This clones the repo into `~/Projects/dot-files` and runs `install/install.sh`,
which detects your OS and:

- installs the base toolset and the default desktop apps — see
  [`docs/apps.md`](docs/apps.md);
- installs oh-my-zsh and its plugins — see [`docs/shell.md`](docs/shell.md);
- symlinks `zshrc`, `kitty.conf`, `gitconfig` and `gitignore_global`
  (backing up whatever was there first);
- sets zsh as the default shell.

Safe to re-run: every step checks whether it's already done before doing it,
and anything it's about to overwrite gets backed up first (`<file>.bak-<timestamp>`).
See [`docs/install.md`](docs/install.md) for how that's implemented.

## Docs

| File | Covers |
|---|---|
| [`docs/apps.md`](docs/apps.md) | Base toolset, default desktop apps per OS, what's *not* installed |
| [`docs/shell.md`](docs/shell.md) | `zshrc` — oh-my-zsh theme/plugins, aliases, env, history, completion, keybindings |
| [`docs/git.md`](docs/git.md) | `gitconfig` and `gitignore_global` — settings, credential helper, alias reference |
| [`docs/install.md`](docs/install.md) | How `install.sh`/`install_functions.sh`/`full-install.sh` work: OS detection, idempotency, structure |
| [`docs/to-review.md`](docs/to-review.md) | Shortlist of CLI tools worth reviewing by hand — not installed automatically |

## The end
End yes, its all for now.
