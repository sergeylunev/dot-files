-- ash.lua — Ash colorscheme for Neovim.
--
-- A light, high-contrast monochrome theme with a single red accent.
-- Three variants (all light): 'warm', 'greige' (default), 'neutral'.
--
-- Select with:
--   vim.g.ash_variant = 'greige'   -- 'warm' | 'greige' | 'neutral'
--   vim.cmd.colorscheme 'ash'
--
-- Source of truth: ~/Projects/AshTheme (generate.py, Zed, OpenCode).

local palettes = {
  warm = {
    bg = '#f4efe6',
    surface = '#ece6da', -- panels, statusline, current line
    elevated = '#f7f3ec', -- floats, popups
    fg = '#2f2a24',
    strong = '#221e19',
    muted = '#8a8275', -- comments, muted text
    disabled = '#a99f8e', -- line numbers, placeholders
    border = '#c4baa8',
    border_variant = '#d6cdbd',
    border_focused = '#6b6459',
    accent = '#b53424', -- red
    accent_bright = '#c94a3a',
    accent_dim = '#93291d',
    num = '#3a352d', -- numbers, constants, functions
    op = '#6b6459', -- operators, punctuation
    prop = '#57514a', -- types, properties
    term = {
      '#2f2a24', '#b53424', '#4a443b', '#57514a', '#6b6459', '#8a8275',
      '#a99f8e', '#f4efe6', '#221e19', '#c94a3a', '#3a352d', '#4a443b',
      '#57514a', '#8a8275', '#c4baa8', '#f7f3ec',
    },
  },
  greige = {
    bg = '#f4f2ed',
    surface = '#eceae4',
    elevated = '#f8f6f2',
    fg = '#2a2724',
    strong = '#1e1c1a',
    muted = '#8a8680',
    disabled = '#a8a49b',
    border = '#c6c1b8',
    border_variant = '#d6d2ca',
    border_focused = '#686560',
    accent = '#ba3226',
    accent_bright = '#ce4538',
    accent_dim = '#96271e',
    num = '#363430',
    op = '#686560',
    prop = '#524f4c',
    term = {
      '#2a2724', '#ba3226', '#44403c', '#524f4c', '#686560', '#8a8680',
      '#a8a49b', '#f4f2ed', '#1e1c1a', '#ce4538', '#363430', '#46433e',
      '#575450', '#928e88', '#c6c1b8', '#f8f6f2',
    },
  },
  neutral = {
    bg = '#f4f4f4',
    surface = '#ececec',
    elevated = '#f8f8f8',
    fg = '#242424',
    strong = '#1a1a1a',
    muted = '#8a8a8a',
    disabled = '#a8a8a8',
    border = '#c8c8c8',
    border_variant = '#d6d6d6',
    border_focused = '#666666',
    accent = '#c02f27',
    accent_bright = '#d24037',
    accent_dim = '#99251f',
    num = '#333333',
    op = '#666666',
    prop = '#4d4d4d',
    term = {
      '#242424', '#c02f27', '#3d3d3d', '#4d4d4d', '#666666', '#8a8a8a',
      '#a8a8a8', '#f4f4f4', '#1a1a1a', '#d24037', '#333333', '#424242',
      '#575757', '#9a9a9a', '#c8c8c8', '#f8f8f8',
    },
  },
}

-- Standard colorscheme preamble.
vim.cmd 'highlight clear'
if vim.fn.exists 'syntax_on' then
  vim.cmd 'syntax reset'
end
vim.o.background = 'light'
vim.g.colors_name = 'ash'

local p = palettes[vim.g.ash_variant] or palettes.greige

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

local function link(group, target)
  vim.api.nvim_set_hl(0, group, { link = target })
end

-- Set terminal colors (for :terminal).
for i = 0, 15 do
  vim.g['terminal_color_' .. i] = p.term[i + 1]
end

-- ---------------------------------------------------------------------------
-- UI
-- ---------------------------------------------------------------------------
hl('Normal', { fg = p.fg, bg = p.bg })
hl('NormalFloat', { fg = p.fg, bg = p.elevated })
hl('NormalNC', { fg = p.fg, bg = p.bg })
hl('FloatBorder', { fg = p.border })
hl('FloatTitle', { fg = p.fg, bold = true })

hl('Cursor', { fg = p.bg, bg = p.fg })
hl('lCursor', { fg = p.bg, bg = p.fg })
hl('TermCursor', { fg = p.bg, bg = p.fg })
hl('CursorIM', { fg = p.bg, bg = p.fg })

hl('CursorLine', { bg = p.surface })
hl('CursorColumn', { bg = p.surface })
hl('ColorColumn', { bg = p.surface })
hl('CursorLineNr', { fg = p.border_focused })

hl('LineNr', { fg = p.disabled })
hl('SignColumn', { bg = p.bg })
hl('FoldColumn', { fg = p.muted, bg = p.bg })

hl('Folded', { fg = p.muted, bg = p.surface })
hl('FoldEnd', { fg = p.border })

hl('Conceal', { fg = p.muted })
hl('NonText', { fg = p.border })
hl('Whitespace', { fg = p.border_variant })
hl('SpecialKey', { fg = p.border_variant })
hl('EndOfBuffer', { fg = p.bg })

hl('WinSeparator', { fg = p.border })
hl('VertSplit', { fg = p.border })

-- Statusline / tabline
hl('StatusLine', { fg = p.fg, bg = p.surface })
hl('StatusLineNC', { fg = p.muted, bg = p.surface })
hl('TabLine', { fg = p.muted, bg = p.surface })
hl('TabLineFill', { fg = p.muted, bg = p.surface })
hl('TabLineSel', { fg = p.fg, bg = p.bg, bold = true })

-- Popup / completion menu
hl('Pmenu', { fg = p.fg, bg = p.elevated })
hl('PmenuSel', { fg = p.fg, bg = p.border_variant, bold = true })
hl('PmenuSbar', { bg = p.border_variant })
hl('PmenuThumb', { bg = p.border_focused })
hl('WildMenu', { fg = p.fg, bg = p.border_variant })

-- Messages
hl('ErrorMsg', { fg = p.accent, bold = true })
hl('WarningMsg', { fg = p.prop, bold = true })
hl('ModeMsg', { fg = p.fg, bold = true })
hl('MoreMsg', { fg = p.fg, bold = true })
hl('Question', { fg = p.accent, bold = true })
hl('Title', { fg = p.fg, bold = true })

hl('Directory', { fg = p.prop })
hl('QuickFixLine', { bg = p.surface })
hl('Visual', { bg = p.border_variant })
hl('VisualNOS', { bg = p.border_variant })

hl('Search', { bg = p.border_variant })
hl('IncSearch', { fg = p.bg, bg = p.border_focused })
hl('CurSearch', { fg = p.bg, bg = p.accent })
hl('MatchParen', { fg = p.accent, bg = p.border_variant, bold = true })

hl('DiffAdd', { bg = p.border_variant })
hl('DiffChange', { bg = p.border_variant })
hl('DiffDelete', { fg = p.accent, bg = p.border_variant })
hl('DiffText', { bg = p.border_focused })

-- ---------------------------------------------------------------------------
-- Syntax (standard groups)
-- ---------------------------------------------------------------------------
hl('Comment', { fg = p.muted, italic = true })
hl('SpecialComment', { fg = p.muted, italic = true })

hl('Constant', { fg = p.num })
hl('String', { fg = p.accent })
hl('Character', { fg = p.accent })
hl('Number', { fg = p.num })
hl('Boolean', { fg = p.num })
hl('Float', { fg = p.num })

hl('Identifier', { fg = p.fg })
hl('Function', { fg = p.num })

hl('Statement', { fg = p.fg, bold = true })
hl('Conditional', { fg = p.fg, bold = true })
hl('Repeat', { fg = p.fg, bold = true })
hl('Label', { fg = p.fg, bold = true })
hl('Keyword', { fg = p.fg, bold = true })
hl('Exception', { fg = p.fg, bold = true })
hl('Operator', { fg = p.op })

hl('PreProc', { fg = p.muted })
hl('Include', { fg = p.muted })
hl('Define', { fg = p.muted })
hl('Macro', { fg = p.muted })
hl('PreCondit', { fg = p.muted })

hl('Type', { fg = p.prop })
hl('StorageClass', { fg = p.prop })
hl('Structure', { fg = p.prop })
hl('Typedef', { fg = p.prop })

hl('Special', { fg = p.op })
hl('SpecialChar', { fg = p.op })
hl('Tag', { fg = p.fg })
hl('Delimiter', { fg = p.op })
hl('Debug', { fg = p.op })

hl('Underlined', { fg = p.accent, italic = true })
hl('Bold', { bold = true })
hl('Italic', { italic = true })
hl('Ignore', { fg = p.disabled })

hl('Error', { fg = p.accent, bold = true })
hl('Todo', { fg = p.accent, bold = true })

-- ---------------------------------------------------------------------------
-- Tree-sitter (used once nvim-treesitter is added)
-- ---------------------------------------------------------------------------
link('@comment', 'Comment')
link('@comment.documentation', 'Comment')

hl('@string', { fg = p.accent })
hl('@string.escape', { fg = p.accent })
hl('@string.regex', { fg = p.accent })
hl('@string.special', { fg = p.accent })
hl('@character', { fg = p.accent })
hl('@character.special', { fg = p.accent })

hl('@number', { fg = p.num })
hl('@float', { fg = p.num })
hl('@boolean', { fg = p.num })
hl('@constant', { fg = p.num })
hl('@constant.builtin', { fg = p.num })
hl('@constant.macro', { fg = p.num })

hl('@keyword', { fg = p.fg, bold = true })
hl('@keyword.function', { fg = p.fg, bold = true })
hl('@conditional', { fg = p.fg, bold = true })
hl('@repeat', { fg = p.fg, bold = true })
hl('@label', { fg = p.fg, bold = true })
hl('@exception', { fg = p.fg, bold = true })

hl('@function', { fg = p.num })
hl('@function.builtin', { fg = p.num })
hl('@function.method', { fg = p.num })
hl('@function.call', { fg = p.num })
hl('@method', { fg = p.num })
hl('@constructor', { fg = p.prop })

hl('@variable', { fg = p.fg })
hl('@variable.builtin', { fg = p.num })
hl('@variable.parameter', { fg = p.fg })
hl('@variable.member', { fg = p.prop })
hl('@field', { fg = p.prop })
hl('@property', { fg = p.prop })

hl('@type', { fg = p.prop })
hl('@type.builtin', { fg = p.prop })
hl('@type.definition', { fg = p.prop })
hl('@struct', { fg = p.prop })
hl('@namespace', { fg = p.prop })
hl('@module', { fg = p.prop })
hl('@attribute', { fg = p.prop })

hl('@operator', { fg = p.op })
hl('@punctuation.bracket', { fg = p.op })
hl('@punctuation.delimiter', { fg = p.op })
hl('@punctuation.special', { fg = p.op })

hl('@tag', { fg = p.fg })
hl('@tag.attribute', { fg = p.prop })
hl('@tag.delimiter', { fg = p.op })

hl('@preproc', { fg = p.muted })
hl('@define', { fg = p.muted })
hl('@macro', { fg = p.muted })
hl('@include', { fg = p.muted })
hl('@annotation', { fg = p.muted })
hl('@parameter', { fg = p.fg })

hl('@text', { fg = p.fg })
hl('@text.reference', { fg = p.accent, italic = true })
hl('@text.uri', { fg = p.accent, italic = true })
hl('@text.title', { fg = p.fg, bold = true })
hl('@text.emphasis', { italic = true })
hl('@text.strong', { bold = true })
hl('@text.literal', { fg = p.num })
hl('@text.danger', { fg = p.accent })
hl('@text.warning', { fg = p.accent })

-- ---------------------------------------------------------------------------
-- Diagnostics (LSP)
-- ---------------------------------------------------------------------------
hl('DiagnosticError', { fg = p.accent })
hl('DiagnosticWarn', { fg = p.prop })
hl('DiagnosticInfo', { fg = p.op })
hl('DiagnosticHint', { fg = p.muted })
hl('DiagnosticOk', { fg = p.op })

link('DiagnosticSignError', 'DiagnosticError')
link('DiagnosticSignWarn', 'DiagnosticWarn')
link('DiagnosticSignInfo', 'DiagnosticInfo')
link('DiagnosticSignHint', 'DiagnosticHint')
link('DiagnosticVirtualTextError', 'DiagnosticError')
link('DiagnosticVirtualTextWarn', 'DiagnosticWarn')
link('DiagnosticVirtualTextInfo', 'DiagnosticInfo')
link('DiagnosticVirtualTextHint', 'DiagnosticHint')
link('DiagnosticFloatingError', 'DiagnosticError')
link('DiagnosticFloatingWarn', 'DiagnosticWarn')
link('DiagnosticFloatingInfo', 'DiagnosticInfo')
link('DiagnosticFloatingHint', 'DiagnosticHint')

hl('DiagnosticUnderlineError', { sp = p.accent, underline = true })
hl('DiagnosticUnderlineWarn', { sp = p.prop, underline = true })
hl('DiagnosticUnderlineInfo', { sp = p.op, underline = true })
hl('DiagnosticUnderlineHint', { sp = p.muted, underline = true })

-- ---------------------------------------------------------------------------
-- nvim-tree
-- ---------------------------------------------------------------------------
hl('NvimTreeNormal', { fg = p.fg, bg = p.surface })
hl('NvimTreeNormalNC', { fg = p.fg, bg = p.surface })
hl('NvimTreeRootFolder', { fg = p.fg, bold = true })
hl('NvimTreeFolderName', { fg = p.prop })
hl('NvimTreeFolderIcon', { fg = p.prop })
hl('NvimTreeOpenedFolderName', { fg = p.prop })
hl('NvimTreeEmptyFolderName', { fg = p.muted })
hl('NvimTreeIndentMarker', { fg = p.border })
hl('NvimTreeSymlink', { fg = p.accent })
hl('NvimTreeExecFile', { fg = p.fg })
hl('NvimTreeSpecialFile', { fg = p.accent })
hl('NvimTreeImageFile', { fg = p.prop })
hl('NvimTreeCursorLine', { bg = p.border_variant })
hl('NvimTreeWinSeparator', { fg = p.border })
hl('NvimTreeEndOfBuffer', { fg = p.bg })
hl('NvimTreeStatusLine', { fg = p.fg, bg = p.surface })

-- Git status: red reserved for deletions/conflicts, everything else grey.
hl('NvimTreeGitDirty', { fg = p.prop })
hl('NvimTreeGitStaged', { fg = p.prop })
hl('NvimTreeGitNew', { fg = p.prop })
hl('NvimTreeGitDeleted', { fg = p.accent })
hl('NvimTreeGitRenamed', { fg = p.prop })
hl('NvimTreeGitMerge', { fg = p.prop })
hl('NvimTreeGitIgnored', { fg = p.muted })
hl('NvimTreeGitConflict', { fg = p.accent })

-- ---------------------------------------------------------------------------
-- gitsigns (used once added)
-- ---------------------------------------------------------------------------
hl('GitSignsAdd', { fg = p.op })
hl('GitSignsChange', { fg = p.op })
hl('GitSignsDelete', { fg = p.accent })
hl('GitSignsChangedelete', { fg = p.accent })
hl('GitSignsTopdelete', { fg = p.accent })
hl('GitSignsUntracked', { fg = p.muted })

-- ---------------------------------------------------------------------------
-- mini.statusline
-- ---------------------------------------------------------------------------
hl('MiniStatuslineNormal', { fg = p.fg, bg = p.surface })
hl('MiniStatuslineInactive', { fg = p.muted, bg = p.surface })
hl('MiniStatuslineFilename', { fg = p.fg, bg = p.surface })
hl('MiniStatuslineFileinfo', { fg = p.muted, bg = p.surface })
hl('MiniStatuslineGit', { fg = p.prop, bg = p.surface })
hl('MiniStatuslineDiagnostics', { fg = p.op, bg = p.surface })
hl('MiniStatuslineLocation', { fg = p.muted, bg = p.surface })
hl('MiniStatuslineDevinfo', { fg = p.muted, bg = p.surface })

-- Modes stay monochrome (bold), red is reserved for errors/strings in Ash.
hl('MiniStatuslineModeNormal', { fg = p.fg, bg = p.surface, bold = true })
hl('MiniStatuslineModeInsert', { fg = p.fg, bg = p.surface, bold = true })
hl('MiniStatuslineModeVisual', { fg = p.fg, bg = p.surface, bold = true })
hl('MiniStatuslineModeReplace', { fg = p.fg, bg = p.surface, bold = true })
hl('MiniStatuslineModeCommand', { fg = p.fg, bg = p.surface, bold = true })
hl('MiniStatuslineModeOther', { fg = p.fg, bg = p.surface, bold = true })
