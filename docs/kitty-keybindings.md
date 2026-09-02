# kitty keyboard shortcuts

`kitty.conf` sets `kitty_mod ctrl+shift` and `clear_all_shortcuts no`. That
second setting matters: nothing in `kitty.conf` *removes* kitty's built-in
shortcuts — every `map` line here only *adds* a binding on top of them. So
every shortcut below is live at the same time: kitty's own defaults (mostly
`kitty_mod+...`) plus whatever this repo adds.

## OS-specific bindings: `keybindings-macos.conf` / `keybindings-linux.conf`

`kitty.conf` has:

```
include keybindings-${KITTY_OS}.conf
```

kitty expands `${KITTY_OS}` itself (`macos`/`linux`/`bsd`) when resolving
`include` paths — no shell scripting involved, no need for `install.sh` to
pick a file. `install.sh` just symlinks both files into the same directory
as `kitty.conf` (kitty resolves `include` relative to `kitty.conf`'s own
directory *without following symlinks*, so every included file needs its
own symlink there too — same reason `forest.conf` does).

**`keybindings-macos.conf`** carries the `cmd+...` shortcuts ported from
iTerm2/macOS muscle memory — see the table below.

**`keybindings-linux.conf`** only carries three of those, ported to Linux:

| Shortcut | Action | Why not `ctrl+shift+<letter>` (`kitty_mod`) |
|---|---|---|
| `ctrl+1` … `ctrl+5` | Go to tab 1–5 | n/a — plain `ctrl+<digit>` is safe as-is (see caveat below) |
| `ctrl+alt+w` | Close OS window | `kitty_mod+w` is already "close window" (not OS window) |
| `ctrl+alt+q` | Quit kitty | `kitty_mod+q` is already "close tab", and there's no other cross-platform default for quitting |

Everything else in `keybindings-macos.conf` isn't ported to Linux, either
because kitty's own `kitty_mod` default already covers the same action
(see the table below for which), or because it has no Linux equivalent at
all (`cmd+m` minimize — window minimizing is the window manager's job on
Linux, not the terminal's). "Go to the previous tab" (`cmd+p` on macOS) is
deliberately left unported too — no Linux binding for it currently.

### Two things that make blindly porting `cmd+<letter>` → `ctrl+<letter>` unsafe

1. **Shell/readline control characters.** kitty fully captures a mapped key
   combo before it ever reaches the shell — so mapping a bare `ctrl+<letter>`
   to a kitty action doesn't just add a shortcut, it **replaces** whatever
   that combo already does in zsh/readline. A few of the macOS bindings
   would be genuinely destructive if ported as bare `ctrl+<letter>`:

   | macOS binding | Bare `ctrl+` equivalent | What it would break |
   |---|---|---|
   | `cmd+c` (copy) | `ctrl+c` | **SIGINT** — interrupting a running process |
   | `cmd+v` (paste) | `ctrl+v` | quoted-insert in zle |
   | `cmd+w` (close tab) | `ctrl+w` | backward-kill-word in zle |
   | `cmd+t` (new tab) | `ctrl+t` | transpose-chars in zle |
   | `cmd+n` (new OS window) | `ctrl+n` | down-history in zle |
   | `cmd+p` (previous tab) | `ctrl+p` | up-history in zle |
   | `cmd+m` (minimize) | `ctrl+m` | **this *is* the Enter/CR key code** |

   Plain `ctrl+<digit>` doesn't have this problem — digits aren't
   shell/readline control characters, which is why `ctrl+1`…`ctrl+5` above
   are safe as bare `ctrl+`.

2. **Collisions with kitty's own `kitty_mod` defaults.** `kitty_mod` is
   `ctrl+shift`, so `ctrl+shift+<letter>` isn't free real estate either —
   kitty already binds most letters by default. That's exactly why
   `close_os_window` and `quit` above use `ctrl+alt+` instead: their natural
   `ctrl+shift+w` / `ctrl+shift+q` are already taken by `close_window` and
   `close_tab` respectively (see the defaults table below).

## `keybindings-macos.conf`

### Clipboard

| Shortcut | Action |
|---|---|
| `cmd+c` | Copy to clipboard |
| `cmd+v` | Paste from clipboard |
| `shift+cmd+v` | Paste from buffer `a1` (see `copy_on_select a1` below) |

### Scrolling

| Shortcut | Action |
|---|---|
| `cmd+up` | Scroll line up |
| `cmd+down` | Scroll line down |

### Window management

| Shortcut | Action |
|---|---|
| `cmd+enter` | New window |
| `cmd+n` | New OS window |
| `shift+cmd+d` | Close window |

### Tab management

| Shortcut | Action |
|---|---|
| `cmd+t` | New tab |
| `cmd+w` | Close tab |
| `shift+cmd+w` | Close OS window |
| `shift+cmd+i` | Set tab title |
| `cmd+1` … `cmd+5` | Go to tab 1–5 |
| `cmd+p` | Go to the previously active tab |

### Miscellaneous

| Shortcut | Action |
|---|---|
| `ctrl+cmd+f` | Toggle fullscreen |
| `cmd+,` | Edit `kitty.conf` |
| `ctrl+cmd+,` | Reload `kitty.conf` |
| `cmd+ctrl+l` | Clear terminal up to the cursor, scrolling cleared lines into scrollback |
| `cmd+m` | Minimize window |
| `cmd+q` | Quit kitty |

### Mouse

| Action | Behavior |
|---|---|
| `copy_on_select a1` | Selecting text with the mouse copies it into buffer `a1` (not the system clipboard) — paste it back with `shift+cmd+v` |

## Cross-platform bindings (in `kitty.conf` itself, all OSes)

| Shortcut | Action |
|---|---|
| `ctrl+tab` | Next tab |
| `ctrl+shift+tab` | Previous tab |
| `kitty_mod+]` | Next window *(same as kitty's default, restated explicitly)* |
| `kitty_mod+[` | Previous window *(same as kitty's default, restated explicitly)* |
| `kitty_mod+f1` | Show kitty documentation overview |
| `kitty_mod+f10` | Toggle maximized |

## kitty defaults worth knowing (still active, not overridden)

These aren't in `kitty.conf` at all — they're kitty's built-in bindings,
listed here because they're genuinely useful day to day, easy to miss since
no file in this repo mentions them, and because several are the reason a
macOS shortcut above *wasn't* ported to Linux (it's already covered).

| Shortcut | Action |
|---|---|
| `kitty_mod+equal` / `kitty_mod+minus` | Increase / decrease font size |
| `kitty_mod+backspace` | Reset font size |
| `kitty_mod+c` / `kitty_mod+v` | Copy / paste (same as `cmd+c`/`cmd+v` on macOS) |
| `kitty_mod+enter` | New window (same as `cmd+enter` on macOS) |
| `kitty_mod+n` | New OS window (same as `cmd+n` on macOS) |
| `kitty_mod+t` | New tab (same as `cmd+t` on macOS) |
| `kitty_mod+w` | Close window (same as `shift+cmd+d` on macOS) |
| `kitty_mod+q` | Close tab (same as `cmd+w` on macOS) |
| `kitty_mod+f11` | Toggle fullscreen (same as `ctrl+cmd+f` on macOS) |
| `kitty_mod+f2` | Edit `kitty.conf` (same as `cmd+,` on macOS) |
| `kitty_mod+f5` | Reload `kitty.conf` (same as `ctrl+cmd+,` on macOS) |
| `kitty_mod+alt+t` | Set tab title (same as `shift+cmd+i` on macOS) |
| `kitty_mod+right` / `kitty_mod+left` | Next / previous tab (in addition to `ctrl+tab`/`ctrl+shift+tab` above) |
| `kitty_mod+1` … `kitty_mod+9`/`0` | Focus window 1–10 *(not the same as "go to tab" above)* |
| `kitty_mod+f` | Move window forward (in the current layout) |
| `kitty_mod+b` | Move window backward |
| `kitty_mod+r` | Start resizing the active window |
| `kitty_mod+l` | Next layout |
| `kitty_mod+e` | Open a URL visible on screen, picked via on-screen hints |
| `kitty_mod+p` then `f`/`l`/`w`/`h`/`n`/`y` | Hints kitten: select and insert a path/line/word/hash/`file:line`/hyperlink from on-screen text |
| `kitty_mod+h` | Browse the scrollback buffer in a pager |
| `kitty_mod+g` | Browse the output of the last shell command (needs shell integration) |
| `kitty_mod+z` / `kitty_mod+x` | Scroll to previous / next shell prompt (needs shell integration) |
| `kitty_mod+f3` | Command palette — fuzzy-search every kitty action by name |
| `kitty_mod+f6` | Debug config — dumps kitty's actual running configuration, useful for troubleshooting a shortcut that "isn't working" |
| `kitty_mod+escape` | Open the kitty shell (control kitty itself via commands) |
| `kitty_mod+delete` | Reset the terminal |
| `kitty_mod+u` | Unicode character input |

The **command palette** (`kitty_mod+f3`) is the fastest way to discover
anything not listed here — it fuzzy-searches every action kitty knows about,
whether or not it has a shortcut assigned.
