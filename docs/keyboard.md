# Keyboard layouts

`install.sh` runs `setup_keyboard`, which picks a setup by
`$XDG_CURRENT_DESKTOP` (KDE, GNOME, Hyprland; anything else is skipped).
Same behaviour on all of them:

| Shortcut / setting | Effect |
|---|---|
| Layouts | `us` (plain) and `ru` |
| Capslock | Left Ctrl (`ctrl:nocaps`) |
| `alt+shift` | Cycles layouts (stock behaviour, kept) |
| `ctrl+shift+1` | Switch to English |
| `ctrl+shift+2` | Switch to Russian |

Every setup is idempotent: it sets absolute values, so re-running changes
nothing.

## KDE

`kwriteconfig6` writes `kxkbrc` (`LayoutList=us,ru`,
`Options=ctrl:nocaps,grp:alt_shift_toggle`) and the two shortcuts into
`kglobalshortcutsrc` (group `KDE Keyboard Layout Switcher`), then signals
`org.kde.keyboard` to reload. A re-login may be needed for the shortcuts.

## GNOME (Ubuntu) — not verified

Via `gsettings`: `org.gnome.desktop.input-sources` `sources` and
`xkb-options`, plus two custom media-keys shortcuts that run
`gsettings set org.gnome.desktop.input-sources current 0|1`.
**Written blind, not tested on a real GNOME machine** — expect tuning.

## Hyprland (omarchy) — not verified

`configs/hyprland/keyboard.conf` (`input` block + two `bind` lines using
`hyprctl switchxkblayout all 0|1`) is linked to
`~/.config/hypr/dotfiles-keyboard.conf` and sourced from `hyprland.conf`.
**Written blind, not tested on a real Hyprland machine**; omarchy's own
bindings/input settings may override or conflict with it.

## Conflict with kitty

`ctrl+shift+1` / `ctrl+shift+2` are also `kitty_mod+1/2` (go to tab 1/2, see
[`kitty-keybindings.md`](kitty-keybindings.md)). The global shortcut is
grabbed by the desktop first, so inside kitty those keys switch layout and
the kitty tab shortcuts stop firing; use the other tab shortcuts instead.
