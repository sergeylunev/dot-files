# tmux (`tmux.conf`, `tmux-sessionize.sh`)

The second level of a two-level "tabs" workflow: a **kitty tab** is a
project, opened at that project's directory; inside it, a **tmux session**
(same project, same name) holds one window per process you care about for
that project - an agent, a plain shell, and whatever else you add. Kitty's
own window/layout system (see [`docs/kitty-keybindings.md`](kitty-keybindings.md))
is a separate, unrelated way to split a *single* tab into panes - the two
don't compete, you can use both.

Installed and linked automatically by `install/install.sh` on all three
OSes. To (re)link it by hand: `install/link.sh tmux`. Or manually:

```bash
ln -sf ~/PATH_TO_DOTFILES/configs/tmux/tmux.conf ~/.tmux.conf
ln -sf ~/PATH_TO_DOTFILES/configs/tmux/tmux-sessionize.sh ~/.local/bin/tmux-sessionize
```

## Starting a project session

`tm` (aliased in `zshrc` to `tmux-sessionize`) attaches to the tmux session
for the current directory, creating it first if it doesn't exist:

```bash
cd ~/Projects/some-project
tm
```

The session is named after the directory (non-alphanumeric characters
collapsed to `_`, so tmux's own `session:window` addressing never gets
confused by it). Running `tm` again from the same directory - in the same
kitty tab, a new one, or after a crash - always re-attaches to the same
session instead of creating a duplicate.

A freshly created session gets two windows:

| Window | What it does |
|---|---|
| `shell` | Plain shell, `cd`'d into the project directory. Selected as the active window on attach. |
| `agent` | Also `cd`'d into the project directory, but starts `claude` immediately - assumes the `claude` CLI is already on `PATH` (not installed by `install.sh`). If `claude` exits or isn't found, the window drops into a plain shell instead of closing - tmux would otherwise close a window the instant the command it ran exits, silently. |

Add more windows by hand as needed (`prefix c` for a new one, `prefix ,` to
rename it) - the two above are just the starting point, not a limit.

## Why no plugins / TPM

`tmux.conf` is a single, self-contained file - no [TPM](https://github.com/tmux-plugins/tpm)
or any other plugin manager. That rules out things like `tmux-resurrect`/
`tmux-continuum` (session persistence across reboots) and prebuilt themes,
but keeps the setup to "symlink one file" like everything else in this
repo, with no extra clone/bootstrap step and nothing that can drift out of
sync with an upstream plugin repo. Revisit if reboot-surviving sessions
becomes an actual need.

## Keybindings

The tmux prefix and every default binding are left exactly as tmux ships
them (`ctrl+b`) - nothing here overrides or removes a default, only adds
on top of it:

| Shortcut | Action |
|---|---|
| `prefix h` / `j` / `k` / `l` | Move to the pane left / below / above / right (vim-style, in addition to the default `prefix` + arrow keys) |

Everything else - new window (`prefix c`), next/previous window
(`prefix n`/`prefix p`), split panes (`prefix %`/`prefix "`), detach
(`prefix d`), etc. - is stock tmux. Run `prefix ?` inside a session for the
full list.

## Status bar

```
set -g status-left ""
set -g status-right ""
set -g status-position top
```

Just the built-in window list in the middle - it already highlights
whichever window is active, which is what tells you "which process, in
which project" at a glance when you're nested two levels deep. Nothing on
either side: no session name (that's in the kitty tab above it instead -
see below - repeating it here would just be noise), no clock, no hostname.

`status-position top` puts that window list right under the kitty tab
bar instead of at the bottom of the terminal, so the two levels of "tabs"
sit stacked on top of each other: kitty tabs (projects) above, tmux
windows (processes within the current project) directly below.

### Colors match the kitty tab bar

```
set -g status-style "bg=#dfe4cd,fg=#474b48"
set -g window-status-style "bg=#dfe4cd,fg=#474b48"
set -g window-status-current-style "bg=#7f8f8a,fg=#dfe4cd,bold"
```

Without this, tmux falls back to its own default status colors, which
have nothing to do with [Forest](../configs/kitty/forest.conf) (the theme
`kitty.conf` uses) - stacking the two bars on top of each other (see
above) made that mismatch obvious. These three lines pull from the same
Forest hex values kitty's active/inactive tab colors now use (see
`docs/apps.md`): the active window gets the theme's accent green
(`#7f8f8a`, the same color the cursor/selection/urls already use in
`forest.conf`) with light text, inactive windows sit flush with the bar's
background color so only the active one stands out - the same
active/inactive treatment as the kitty tabs above it.

## Kitty tab title = project name

```
set -g set-titles on
set -g set-titles-string "#{=/20/…:#{session_name}}"
```

tmux doesn't touch the outer terminal's title by default (`set-titles` is
off out of the box), so without this the kitty tab just shows whatever the
foreground process last set it to - `nvim`, `claude`, etc. - not the
project. These two options make tmux report the **session name** instead
(the project's directory name, from `tmux-sessionize.sh` - stable no
matter which window/pane you're in or which subdirectory you've `cd`'d
into), truncated to 20 characters with `…` so a long project name doesn't
stretch the kitty tab. No changes needed on the kitty side - `kitty.conf`'s
`tab_title_template` already just displays whatever title it's given.
