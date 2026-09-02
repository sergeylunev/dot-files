# Shell (`zshrc`)

zsh config, built on [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh). Installed
and linked automatically by `install/install.sh` on all three OSes. To link it
by hand:

```bash
ln -sf ~/PATH_TO_DOTFILES/zshrc ~/.zshrc
mkdir -p ~/.zsh
```

## What's installed

- **oh-my-zsh** itself — installed unattended if `~/.oh-my-zsh` doesn't
  already exist.
- **`zsh-autosuggestions`** and **`zsh-syntax-highlighting`** — not bundled
  with oh-my-zsh, so `install.sh` git-clones them into
  `$ZSH_CUSTOM/plugins/` separately (idempotent: skipped if the directory
  already exists).

## Theme and plugins

`ZSH_THEME="bira"` — a plain powerline-style theme, no icons. If it ever
feels limiting, `docs/to-review.md` has `starship` as a simpler alternative
that would make use of the Nerd Font already installed by default.

```
plugins=(git history extract command-not-found zsh-autosuggestions zsh-syntax-highlighting)
```

| Plugin | Source | What it does |
|---|---|---|
| `git` | bundled | git-related aliases/completions from oh-my-zsh |
| `history` | bundled | shortcuts for browsing shell history |
| `extract` | bundled | `extract <file>` unpacks any archive format (`.tar.gz`, `.zip`, `.rar`, ...) without remembering flags per format |
| `command-not-found` | bundled | on Fedora/Ubuntu, suggests which package to install when a command isn't found |
| `zsh-autosuggestions` | external, cloned by `install.sh` | ghost-text suggestion of the rest of a command, predicted from history — accept with `→` |
| `zsh-syntax-highlighting` | external, cloned by `install.sh`, **must stay last** in the list | colors commands as you type (green = valid, red = not) |

`zsh-syntax-highlighting` has to be the last plugin loaded — it wraps `zle`
widgets, and loading it before other plugins define theirs breaks their
highlighting.

## Aliases

```
alias v='vim'
alias gs='git status -s'
alias gps='git push'
alias gpl='git pull --ff-only'
alias gc='git commit -va'
alias gu='git stash && git pull --ff-only && git stash pop'
alias gsm='git add -A && git commit -va && git push'
alias s='git add -A && git stash && git commit -va && git push'
alias gcb='git remote update origin --prune && git branch --merged | grep -v "*" | xargs git branch -D'
alias mkdir='mkdir -p'
alias sudo='sudo '   # lets an aliased command after `sudo` still expand
```

These deliberately overlap with the `git` aliases in `docs/git.md` (`git s`,
`git c`, ...) — `gs`/`gc` are just faster to type than `git s`/`git c`, and
having both doesn't conflict.

On macOS only (gated behind `uname -s == Darwin`):

```
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
```

Toggles hidden-file visibility in Finder.

Global aliases (usable anywhere in a command line, not just at the start):

```
alias -g G="| grep"
alias -g L="| less"
```

E.g. `ls -la G foo` → `ls -la | grep foo`.

## Environment

- `PATH` picks up `/usr/local/bin`, `/usr/local/sbin`, `/usr/local/go/bin`,
  `~/go/bin`, `~/bin`, `~/.local/bin` on every OS; `/opt/local/{bin,sbin}`
  (MacPorts) additionally on macOS only.
- `EDITOR` / `GIT_EDITOR` are set to `nvim` — the base editor installed on
  every OS (see `docs/apps.md`). `gitconfig` intentionally has no
  `core.editor`, so it inherits this.

## History

```
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh/history
```

Plus a handful of `setopt`s that keep the history file sane:
`inc_append_history` (write immediately, not just on shell exit),
`hist_ignore_all_dups` / `hist_save_no_dups` / `hist_find_no_dups` (collapse
duplicate entries so raising `HISTSIZE` doesn't just mean more repeats),
`hist_reduce_blanks`, `hist_ignore_space` (a command prefixed with a space
isn't recorded — handy for one-off commands with secrets in them),
`hist_no_store`, `hist_no_functions`, `no_hist_beep`.

## Directory navigation

```
setopt auto_cd          # typing a bare directory name cd's into it
setopt rmstarsilent      # `rm *` doesn't ask "are you sure" every time
setopt autopushd         # every cd is pushed onto the directory stack
setopt pushd_ignore_dups # ...without piling up duplicates
```

With `autopushd`, `cd -<Tab>` lists recently visited directories to jump
back to; `dirs -v` shows the stack.

## Completion

```
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
```

`matcher-list` makes tab-completion case-insensitive (`cd doc<Tab>` matches
`Documents`); `menu select` turns completion into an arrow-key-navigable
menu instead of cycling through matches one Tab press at a time.

## Keybindings

```
bindkey "^R" history-incremental-search-backward
bindkey "^F" forward-word
bindkey "^B" backward-word
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
```

`^F`/`^B` are deliberately remapped from their emacs-mode default
(character-wise movement) to word-wise movement — a conscious choice for
faster navigation, not an emacs-compatibility concern.
