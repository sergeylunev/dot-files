# What gets installed

Everything below is installed by `install/install.sh`, which is safe to
re-run: every step checks whether it's already done before doing it, and
anything it's about to overwrite gets backed up first
(`<file>.bak-<timestamp>`).

## Base toolset (same on every OS)

Installed through the right package manager for the detected OS (`dnf` on
Fedora, `apt` via `nala` on Ubuntu, `brew` on macOS):

`git`, `curl`, `wget`, `zsh`, `vim`, `unzip`, `gcc`, `make`, `gh`, `go`
(package name differs: `golang` / `golang-go` / `go`), bare `neovim`,
`kitty`.

- **`kitty`** — the default terminal emulator on all three OSes. Config is
  `kitty.conf` in the repo root, symlinked to
  `~/.config/kitty/kitty.conf` (Linux) or
  `~/Library/Preferences/kitty/kitty.conf` (macOS). Sets JetBrains Mono
  Nerd Font as the terminal font, among other tweaks — see the file itself
  (heavily commented, organized in foldable sections). Color scheme is
  `forest.conf`, pulled in via `include forest.conf` — a port of the
  [CustomForest iTerm2 theme](https://github.com/sergeylunev/CustomForestTheme)
  (ansi colors, background/foreground, cursor, selection, URL color; iTerm
  fields with no kitty equivalent — badge, cursor guide, search-match
  background — are dropped). It's a separate file rather than inlined so it
  can be swapped for another `kitten themes` scheme later without touching
  the rest of `kitty.conf`. kitty resolves `include` paths relative to
  `kitty.conf`'s own directory *without following symlinks*, so
  `install.sh` symlinks every file `kitty.conf` includes into the same
  config directory, not just `kitty.conf` itself — that's `forest.conf`
  plus `keybindings-macos.conf`/`keybindings-linux.conf`, the OS-specific
  keyboard shortcuts (`cmd` on macOS, `ctrl`-based equivalents on Linux,
  picked automatically via kitty's `${KITTY_OS}` include-path expansion —
  no OS branching needed in `install.sh` itself for *which* file to use).
  Fully documented in
  [`docs/kitty-keybindings.md`](kitty-keybindings.md).
- **Neovim** — installed as a bare binary everywhere. The `nvim/` config in
  this repo (lsp, cmp, telescope, treesitter, ...) is **not** linked yet —
  it needs a pass to bring it up to date first. To link it by hand once
  it's ready:

  ```bash
  ln -sf ~/PATH_TO_DOTFILES/nvim ~/.config/nvim
  ```

### Containers — Podman, not Docker

`podman` + `podman-compose` on every OS. Podman was chosen over Docker
Desktop because it's daemonless, rootless, free at any scale, and
docker-CLI-compatible — no license to worry about, no background daemon
running as root. On macOS (no native container support), `install.sh` also
runs `podman machine init`/`start` since Podman needs its own lightweight
VM there.

### Font

JetBrains Mono Nerd Font, same download-and-extract mechanism on every OS
(pulls the release zip straight from
[ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts) — no
COPR/tap dependency). Installed to `~/.local/share/fonts/` (Linux, with an
`fc-cache` refresh) or `~/Library/Fonts/` (macOS).

### VPN / proxy — Happ

[Happ](https://github.com/Happ-proxy/happ-desktop) has no flatpak, cask, or
apt/dnf repo — only GitHub release assets — so `install.sh` pulls the
latest `.rpm`/`.deb`/`.dmg` directly from
`github.com/Happ-proxy/happ-desktop/releases/latest/download/`.

## Default desktop apps

| Category | Fedora (KDE) | Ubuntu (GNOME) | macOS |
|---|---|---|---|
| Browser (primary) | Zen (flatpak) | Zen (flatpak) | Zen (brew cask) |
| Browser (secondary) | Chromium (flatpak) | Thorium (apt repo) | Chromium (brew cask) |
| Editor | Zed (flatpak) + bare Neovim | Zed (flatpak) + bare Neovim | Zed (brew cask) + bare Neovim |
| Password manager | Bitwarden (flatpak) | Bitwarden (snap) | Bitwarden (brew cask) |
| Communication | Telegram (flatpak) | Telegram (snap) | Telegram (brew cask) |
| AppImage integration | Gear Lever (flatpak) | Gear Lever (flatpak) | — |
| Gaming | Steam (flatpak) | Steam (snap) | Steam (brew cask) |

Thorium has no clean Fedora or macOS package (no Flathub flatpak, and its
Homebrew cask is broken/deprecated), so those two fall back to Chromium as
the secondary browser.

On Fedora and Ubuntu, GUI apps go through Flatpak/Flathub first
(`ensure_flatpak` sets up the `flathub` remote if it isn't there yet); a few
Ubuntu-specific ones use snap or an apt repo instead where that's the more
reliable path (Bitwarden/Telegram/Steam via snap, Thorium via its own apt
repo, `gh` via its official apt repo). On macOS everything goes through a
Homebrew cask.

Ubuntu also restores a GNOME Terminal profile from `gnome-terminal-backup.txt`
(a `dconf` dump) — see `docs/install.md`.

## Not installed by default

Obsidian, Discord/Slack, Docker (Podman replaces it), LibreOffice, VLC.

`docs/to-review.md` has a shortlist of modern CLI tools (fzf, ripgrep, eza,
lazygit, starship, ...) worth reviewing by hand — none of them are
installed automatically either.
