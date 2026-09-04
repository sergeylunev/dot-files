# Git (`gitconfig`, `gitignore_global`)

Installed and linked automatically by `install/install.sh` on all three OSes.
To (re)link just these two: `install/link.sh git`. Or by hand:

```bash
ln -sf ~/PATH_TO_DOTFILES/configs/git/gitconfig ~/.gitconfig
ln -sf ~/PATH_TO_DOTFILES/configs/git/gitignore_global ~/.gitignore_global
```

## `gitconfig`

### User / identity

```
[user]
    email = sergey@lunyov.ru
    name = Sergey Lunev
```

### Core settings

```
[core]
    autocrlf = false
    safecrlf = true
    quotepath = false
    excludesfile = ~/.gitignore_global
```

- `autocrlf = false` / `safecrlf = true` — don't auto-convert line endings,
  but refuse a commit that would introduce an irreversible conversion.
- `quotepath = false` — print non-ASCII filenames as-is instead of
  octal-escaped.
- `excludesfile = ~/.gitignore_global` — portable path (works identically on
  Linux and macOS), resolved after `install.sh` symlinks
  `gitignore_global` there. See below.
- **`core.editor` is intentionally unset** — git falls back to `$EDITOR`,
  which `zshrc` sets to `nvim`. Keeping it unset here means the editor only
  has to be decided in one place.

### Credential helper

```
[credential "https://github.com"]
    helper =
    helper = !gh auth git-credential
[credential "https://gist.github.com"]
    helper =
    helper = !gh auth git-credential
```

Delegates HTTPS auth for GitHub to the `gh` CLI's own credential store
(`gh auth login` once, and every `git push`/`pull` over HTTPS reuses that
token) instead of prompting for a username/password or managing a separate
PAT. The empty `helper =` before it clears any credential helper inherited
from a higher-priority config file, so only `gh` handles these hosts.

### Aliases

| Alias | Expands to | Use |
|---|---|---|
| `git s` | `status -s` | short status |
| `git a` | `add` | |
| `git c` | `commit -va` | commit, staging tracked changes, opens `$EDITOR` for the message |
| `git u` | `reset HEAD` | unstage everything |
| `git b` | `branch -a` | list all branches, local + remote |
| `git bn` | `checkout -b` | create + switch to a new branch |
| `git co` | `checkout` | |
| `git m` | `mergetool` | |
| `git d` | diff since last commit, patch + stat, screen cleared first | `git d` |
| `git di <n>` | diff against `HEAD~<n>` | `git di 3` — diff vs. 3 commits ago |
| `git pl` | `pull --ff-only` | refuses to create a merge commit on pull |
| `git ps` | `push` | |
| `git h` | `log --oneline --graph` | compact graph log |
| `git hl` | full-history graph log, colored, with author/date | broader view across all branches |
| `git create-branch <name>` | push a new branch to `origin` and track it locally | `git create-branch feature/x` |
| `git delete-branch <name>` | delete a branch both locally and on `origin` | `git delete-branch feature/x` |
| `git merge-branch` | checkout `master`, pull, merge the previously-checked-out branch | run right after finishing work on a feature branch |
| `git squash-branch` | squash every commit unique to the current branch into one, keeping the **first** commit's full message (subject + body) | see below |
| `git unstage` | `reset HEAD --` | explicit-named twin of `u` |
| `git amend` | `commit --amend --no-edit` | fold staged changes into the last commit without touching its message |
| `git undo` | `reset --soft HEAD~1` | undo the last commit, keeping its changes staged |
| `git wip` | `commit -am "WIP"` | quick throwaway checkpoint of everything |
| `git last` | `log -1 HEAD --stat` | what changed in the last commit |
| `git aliases` | `config --get-regexp ^alias\.` | list every alias defined here |
| `git root` | `rev-parse --show-toplevel` | absolute path to the repo root |
| `git sync` | `fetch --all --prune && pull --ff-only` | refresh remote-tracking branches and fast-forward the current one in one step |
| `git branches` | `branch -vv` | branches with upstream tracking + ahead/behind status (more detail than `b`) |
| `git contributors` | `shortlog -sn` | commit counts per author |

#### `git squash-branch`

Squashes every commit the current branch has that its base branch doesn't,
down to a single commit — keeping the **first** of those commits' message
(subject + body), not the last.

1. Aborts if the working tree isn't clean (staged or unstaged changes) —
   `reset --soft` wouldn't touch them, but the result would be ambiguous.
2. Finds the base branch: `origin/HEAD` if the remote has one configured,
   falling back to a local `master` or `main`.
3. Finds the merge-base of that branch with `HEAD`, and the oldest commit
   after it — that commit's message is what survives.
4. `reset --soft` to the merge-base, then commits everything with that
   message.

```bash
git checkout feature/x
git squash-branch
```

No arguments; if the base branch can't be determined (no `origin/HEAD` and
neither `master` nor `main` exists locally), it aborts rather than guessing.

`zshrc` has its own shorter aliases (`gs`, `gc`, `gps`, ...) that wrap some
of these at the shell level — see `docs/shell.md`.

### Color / push

```
[color]
    ui     = true
    branch = auto
    diff   = auto
    status = auto
[push]
    default = current
```

`push.default = current` — a bare `git push` on a new local branch pushes
it to a same-named remote branch, instead of erroring out or needing
`-u origin <branch>` the first time.

## `gitignore_global`

Referenced from `gitconfig`'s `core.excludesfile`. Generic, cross-language
patterns — not tied to any particular stack:

```
# OS cruft
.DS_Store
Thumbs.db

# Editors / IDEs
.idea/
.vscode/
*.swp
*.swo
*~

# Env / secrets
.env
.env.local

# Logs
*.log

# Common dependency/build dirs
node_modules/
dist/
build/
.cache/
```

Kept deliberately generic (no PHP/Node/Python-specific entries) — a
per-project `.gitignore` is still the right place for stack-specific
patterns; this one only covers things that show up regardless of stack.
