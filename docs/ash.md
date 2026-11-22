# Ash theme

Ash is a light, monochrome theme with a single red accent. All the color
comes from a neutral grey ramp; red is reserved for strings, links and
errors, so it reads as a deliberate accent rather than decoration. Three
variants are defined:

| Variant | Background | Foreground | Accent (red) |
|---|---|---|---|
| Ash Warm | `#f4efe6` | `#2f2a24` | `#b53424` |
| **Ash Greige** (default) | `#f4f2ed` | `#2a2724` | `#ba3226` |
| Ash Neutral | `#f4f4f4` | `#242424` | `#c02f27` |

The repo uses **Ash Greige** wherever an app can only be configured with a
single palette (kitty, tmux). Apps that can hold several themes get all
three variants (Zed, VSCode, Neovim, OpenCode).

The source of truth is `~/Projects/AshTheme` (`generate.py`, plus its
iTerm2/Zed/OpenCode outputs). The files here are copies, so this repo stays
self-contained: regenerate upstream and re-copy when the palette changes.

## Where it lives

| App | File | Variants |
|---|---|---|
| kitty | [`configs/kitty/ash.conf`](../configs/kitty/ash.conf) | Greige only |
| tmux | status-bar colors inline in [`configs/tmux/tmux.conf`](../configs/tmux/tmux.conf) | Greige only |
| Zed | [`configs/zed/themes/ash.json`](../configs/zed/themes/ash.json) | all three |
| Neovim | [`configs/nvim/colors/ash.lua`](../configs/nvim/colors/ash.lua) | all three, via `vim.g.ash_variant` |
| VSCode | [`configs/vscode/customash/`](../configs/vscode/customash) | all three |
| OpenCode | [`configs/opencode/themes/`](../configs/opencode/themes) | all three |

## Switching variants

- **Zed** — theme picker (`cmd-k cmd-t`) → *Ash Warm* / *Ash Greige* /
  *Ash Neutral*. `settings.json` already selects Ash Greige for light and
  Forest Dark for dark.
- **VSCode** — `workbench.colorTheme` in
  [`configs/vscode/settings.json`](../configs/vscode/settings.json); the
  `customash` extension contributes all three labels.
- **Neovim** — `vim.g.ash_variant = "warm" | "greige" | "neutral"` in
  [`configs/nvim/init.lua`](../configs/nvim/init.lua) (default `"greige"`).
- **OpenCode** — `theme.name` in
  [`configs/opencode/cli.json`](../configs/opencode/cli.json)
  (`ash-warm` / `ash-greige` / `ash-neutral`).
- **kitty / tmux** — a single palette each; edit the hex values, or add
  another `.conf` and switch the `include`/`source-file`.

## Forest is still available

Forest files remain in the repo as an alternative: `configs/kitty/forest.conf`,
`configs/zed/themes/forest.json`, `configs/vscode/customforest/` and
`configs/opencode/themes/forest.json`. The Zed dark appearance still uses
Forest Dark.
