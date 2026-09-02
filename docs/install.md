# How the installer works

Three files, one job each:

- **`full-install.sh`** (repo root) — the one-liner bootstrap. Detects
  whether `git` is present (installs it via brew/dnf/apt if not), clones
  this repo to `~/Projects/dot-files` if it isn't already there, and hands
  off to `install/install.sh`.
- **`install/install_functions.sh`** — shared helper library, sourced (not
  executed) by `install.sh`.
- **`install/install.sh`** — the actual installer: OS detection, package
  manager bootstrap, base toolset, OS-specific extras, oh-my-zsh, and
  dotfile symlinks, in that order.

## OS detection

```bash
function detect_os {
  # uname -s == Darwin -> macos
  # uname -s == Linux -> read ID from /etc/os-release -> fedora | ubuntu
  # anything else -> exit 1
}
```

Sets `OS_FAMILY` to one of `fedora` / `ubuntu` / `macos`. Everything else in
the script branches on this variable rather than re-detecting anything.
Unsupported OSes fail loudly instead of silently doing the wrong thing.

## Package manager abstraction

`install_functions.sh` wraps every install-a-thing operation in a function
that's idempotent (checks first, skips if already done) and dispatches to
the right tool for `$OS_FAMILY`:

| Function | Checks | Installs via |
|---|---|---|
| `install_f <bin> [pkg]` | `which <bin>` | `dnf` / `nala` / `brew` |
| `link_f <src> <dest>` | `readlink dest == src` | symlink, backing up whatever was at `dest` first |
| `ensure_flatpak` | (Linux only) | installs `flatpak`, adds the `flathub` remote if missing |
| `flatpak_f <app-id>` | `flatpak list` | `flatpak install flathub <app-id>` |
| `cask_f <cask>` | `brew list --cask` | `brew install --cask <cask>` (macOS only) |
| `install_nerd_font <name> <version>` | destination dir exists | downloads + unzips the GitHub release, `fc-cache` on Linux |
| `install_happ` | `which happ` / `/Applications/Happ.app` | downloads the latest `.rpm`/`.deb`/`.dmg` from GitHub releases |

`install.sh` itself calls these functions rather than shelling out to
`dnf`/`brew`/`flatpak` directly wherever the outcome needs to be
OS-independent and idempotent — package names that differ between OSes
(e.g. Go: `golang` / `golang-go` / `go`) are picked with a small `case` on
`$OS_FAMILY` right before the call, keeping the function itself unaware of
naming differences.

## Idempotency and safety

The whole script is meant to be safe to run repeatedly on a machine that's
already been set up, or to bring a partially-set-up machine the rest of the
way:

- `set -euo pipefail` at the top — stop on the first real error instead of
  plowing on with a broken state.
- Every `install_f`/`flatpak_f`/`cask_f`/`install_nerd_font`/`install_happ`
  call checks "is this already here?" before doing anything.
- `link_f` never blindly overwrites: if `$dest` is already the right
  symlink, it's a no-op; if something else is there (a real file, a
  directory, a stale symlink), it gets moved to
  `$dest.bak-<timestamp>` before the new symlink goes in — nothing is ever
  silently lost.

## Structure of `install.sh`

1. Resolve `SCRIPT_DIR`/`REPO_DIR`, source `install_functions.sh`, call
   `detect_os`.
2. System package manager bootstrap (`dnf upgrade`, or
   `apt update && upgrade && autoremove` + install `nala`, or install/update
   Homebrew).
3. Base toolset — same on every OS (see `docs/apps.md`).
4. OS-specific extras — a `case "$OS_FAMILY" in ...` block, kept
   intentionally separate per OS so one OS's extras can never accidentally
   run on another (see `docs/apps.md` for what each branch installs).
5. oh-my-zsh + external zsh plugins (see `docs/shell.md`).
6. Dotfile symlinks: `zshrc`, `gitconfig`, `gitignore_global`, `kitty.conf`.
7. `nvim/` is deliberately *not* symlinked yet (see `docs/apps.md`).
8. `chsh -s $(which zsh)` if zsh isn't already the login shell.

## Other files

### `gnome-terminal-backup.txt`

A `dconf` dump of GNOME Terminal profiles/settings, Ubuntu-only. Restored
automatically by `install.sh`'s Ubuntu branch. To load by hand:

```bash
dconf load /org/gnome/terminal/ < gnome-terminal-backup.txt
```

### `rmod_kvm.sh`

Small standalone helper, not called from `install.sh`. Unloads the
`kvm`/`kvm_intel` kernel modules — useful before starting a VM manager that
wants exclusive access to hardware virtualization.
