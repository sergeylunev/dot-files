#!/usr/bin/env bash
#
# Attach to the tmux session for the current project, creating it with a
# standard layout if it doesn't exist yet:
#   - "shell"    - a plain shell
#   - "nvim"     - starts `nvim`, but only if this is a git repo
#   - "opencode" - starts `opencode` automatically
#
# The session is named after the current directory, so running this from
# the same project dir always lands you back in the same session. See
# docs/tmux.md.

set -euo pipefail

# tmux uses ":" and "." to address windows/panes within a session name
# (e.g. "myproject:opencode"), so strip anything that would confuse that
# parsing out of the directory name.
session_name="$(basename "$PWD" | tr -c '[:alnum:]_-' '_')"

if tmux has-session -t "=$session_name" 2>/dev/null; then
  exec tmux attach-session -t "$session_name"
fi

tmux new-session -d -s "$session_name" -n shell -c "$PWD"

# `nvim` only when this is a git repo. `; exec $SHELL` keeps the window
# alive as a plain shell once `nvim` exits (or if it's missing from PATH).
if git -C "$PWD" rev-parse --git-dir >/dev/null 2>&1; then
  tmux new-window -t "$session_name" -n nvim -c "$PWD" 'nvim; exec $SHELL'
fi

# `; exec $SHELL` keeps the window alive as a plain shell once `opencode`
# exits (or if it's missing from PATH) - without it, tmux just closes the
# window the instant the command it ran finishes, silently.
tmux new-window -t "$session_name" -n opencode -c "$PWD" 'opencode; exec $SHELL'
tmux select-window -t "$session_name:shell"
exec tmux attach-session -t "$session_name"
