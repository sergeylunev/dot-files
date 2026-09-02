# kitty keyboard shortcuts

`kitty.conf` sets `kitty_mod ctrl+shift` and `clear_all_shortcuts no`. That
second setting matters: nothing in `kitty.conf` *removes* kitty's built-in
shortcuts — the custom `map` lines only *add* extra bindings on top of them.
So every shortcut below is live at the same time: kitty's defaults (mostly
`kitty_mod+...`) and this repo's additions (mostly `cmd+...`, ported from
iTerm2/macOS muscle memory).

## A caveat about `cmd`

kitty treats `cmd` as a plain alias for `super` — on macOS that's the
Command key, but **on Linux it's literally the Super/Windows key**, not a
macOS-only binding that quietly does nothing elsewhere. So every `cmd+...`
line in `kitty.conf` is live on Fedora and Ubuntu too.

The catch: desktop environments often grab the Super key themselves before
it reaches any application — GNOME uses it to open Activities, KDE often
uses it for the application launcher/Overview. If a `cmd+...` shortcut below
doesn't seem to fire, that's the most likely reason; it's a DE keybinding
conflict, not a kitty config bug. `kitty_mod+...` (`ctrl+shift+...`)
shortcuts don't have this problem — check the DE's keyboard shortcut
settings if a `cmd+` one seems dead.

## Custom shortcuts (added by this repo's `kitty.conf`)

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
| `kitty_mod+]` | Next window *(same as kitty's default, restated explicitly)* |
| `kitty_mod+[` | Previous window *(same as kitty's default, restated explicitly)* |

### Tab management

| Shortcut | Action |
|---|---|
| `ctrl+tab` | Next tab |
| `ctrl+shift+tab` | Previous tab |
| `cmd+t` | New tab |
| `cmd+w` | Close tab |
| `shift+cmd+w` | Close OS window |
| `shift+cmd+i` | Set tab title |
| `cmd+1` … `cmd+5` | Go to tab 1–5 |
| `cmd+p` | Go to the previously active tab |

### Miscellaneous

| Shortcut | Action |
|---|---|
| `kitty_mod+f1` | Show kitty documentation overview |
| `ctrl+cmd+f` | Toggle fullscreen |
| `kitty_mod+f10` | Toggle maximized |
| `cmd+,` | Edit `kitty.conf` |
| `ctrl+cmd+,` | Reload `kitty.conf` |
| `cmd+ctrl+l` | Clear terminal up to the cursor, scrolling cleared lines into scrollback |
| `cmd+m` | Minimize window (macOS) |
| `cmd+q` | Quit kitty |

### Mouse

| Action | Behavior |
|---|---|
| `copy_on_select a1` | Selecting text with the mouse copies it into buffer `a1` (not the system clipboard) — paste it back with `shift+cmd+v` |

## kitty defaults worth knowing (still active, not overridden)

These aren't in `kitty.conf` at all — they're kitty's built-in bindings,
listed here because they're genuinely useful day to day and easy to miss
since the file doesn't mention them.

| Shortcut | Action |
|---|---|
| `kitty_mod+equal` / `kitty_mod+minus` | Increase / decrease font size |
| `kitty_mod+backspace` | Reset font size |
| `kitty_mod+enter` | New window (in addition to `cmd+enter` above) |
| `kitty_mod+t` | New tab (in addition to `cmd+t` above) |
| `kitty_mod+w` | Close window |
| `kitty_mod+q` | Close tab |
| `kitty_mod+right` / `kitty_mod+left` | Next / previous tab (in addition to `ctrl+tab`/`ctrl+shift+tab` above) |
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
| `kitty_mod+f2` | Edit `kitty.conf` (in addition to `cmd+,` above) |
| `kitty_mod+f5` | Reload `kitty.conf` (in addition to `ctrl+cmd+,` above) |
| `kitty_mod+f6` | Debug config — dumps kitty's actual running configuration, useful for troubleshooting a shortcut that "isn't working" |
| `kitty_mod+escape` | Open the kitty shell (control kitty itself via commands) |
| `kitty_mod+delete` | Reset the terminal |
| `kitty_mod+u` | Unicode character input |

The **command palette** (`kitty_mod+f3`) is the fastest way to discover
anything not listed here — it fuzzy-searches every action kitty knows about,
whether or not it has a shortcut assigned.
