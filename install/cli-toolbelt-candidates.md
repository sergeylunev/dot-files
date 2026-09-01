# CLI toolbelt candidates

Not installed by `install.sh` on purpose - this is a shortlist to review by
hand and pick from. Everything here is available in `dnf`, `apt` and `brew`
(package names may differ slightly; check before adding to `install.sh`).

Already installed today: `bat`, `jq`, `tmux`, `gh`.

## Search / navigation
- **fzf** - fuzzy finder; fuzzy history search (`^R`), fuzzy file/branch pickers.
- **ripgrep** (`rg`) - fast recursive text search, replaces `grep -r`.
- **fd** - fast, friendly `find` replacement.
- **zoxide** - `cd` that learns your most-used directories (`z foo`).

## Everyday replacements
- **eza** - `ls` replacement with icons, git status, tree view.
- **delta** - syntax-highlighted, side-by-side `git diff` pager.
- **duf** - friendlier `df`.
- **ncdu** - interactive disk usage explorer.

## git / dev workflow
- **lazygit** - terminal UI for git (stage, commit, branch, rebase).
- **direnv** - per-directory environment variables, auto-loaded on `cd`.

## Shell UX
- **starship** - fast, customizable prompt (works with zsh out of the box).
- **tldr** - short, example-first man pages.

## System monitoring
- **htop** or **btop** - interactive process viewer (btop is the fancier one).
- **fastfetch** - system info banner (successor to neofetch).

## Adding one to `install.sh`
Once you've picked some, add them next to the other base tools:

```bash
install_f rg ripgrep   # binary name differs from the package name
install_f fzf
```
