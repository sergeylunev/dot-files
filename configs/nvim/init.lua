-- =============================================================================
--  Neovim configuration (single-file)
--
--  Sections:
--    1. Leader key
--    2. Options
--    3. Keymaps
--    4. Autocommands
--    5. Plugins (lazy.nvim)
--    6. Colorscheme
-- =============================================================================

-- =============================================================================
-- 1. Leader key
-- =============================================================================

-- <space> is the leader key.
-- Must be set before any plugins are loaded (matters once we add lazy.nvim).
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed (used for plugin icons later).
vim.g.have_nerd_font = true

-- =============================================================================
-- 2. Options
-- =============================================================================
-- See `:help option-list` for the full list.

-- [[ General ]]
vim.opt.mouse = "a" -- enable mouse (also for resizing splits)
vim.opt.clipboard = "unnamedplus" -- sync yank/delete with the system clipboard
vim.opt.swapfile = false -- no swap files
vim.opt.backup = false -- no backup files
vim.opt.writebackup = false -- no backup on write
vim.opt.undofile = true -- persistent undo across sessions
vim.opt.timeoutlen = 300 -- wait time for mapped sequences (ms)
vim.opt.updatetime = 250 -- faster swap write + CursorHold triggers (ms)
vim.opt.confirm = true -- ask to save instead of erroring on :q

-- [[ Appearance ]]
vim.opt.termguicolors = true -- true color
vim.opt.number = true -- absolute line numbers
vim.opt.relativenumber = true -- relative line numbers for jumping
vim.opt.numberwidth = 4 -- width of the number column
vim.opt.signcolumn = "yes" -- always show the sign column (no layout shift)
vim.opt.cursorline = true -- highlight the current line
-- Mode is shown in the statusline (mini.statusline).
vim.opt.showmode = false
vim.opt.showtabline = 2 -- always show the tabline
vim.opt.cmdheight = 1 -- more room for command-line messages
vim.opt.pumheight = 10 -- completion popup menu height
vim.opt.scrolloff = 5 -- keep N lines above/below the cursor
vim.opt.sidescrolloff = 8 -- keep N columns left/right of the cursor
vim.opt.wrap = false -- do not soft-wrap long lines
vim.opt.conceallevel = 0 -- keep `` visible in Markdown
vim.opt.list = true -- show invisible characters
vim.opt.guifont = "JetBrainsMono:h17" -- font for GUI clients

-- [[ Indentation ]]
vim.opt.expandtab = true -- insert spaces instead of tabs
vim.opt.tabstop = 4 -- a tab is 4 columns wide
vim.opt.shiftwidth = 4 -- indent/outdent width
vim.opt.smartindent = true -- basic auto-indent (treesitter will handle this later)
vim.opt.breakindent = true -- wrap long lines with indent

-- [[ Search ]]
vim.opt.hlsearch = true -- highlight matches
vim.opt.ignorecase = true -- ignore case ...
vim.opt.smartcase = true -- ... unless the pattern has capital letters
vim.opt.inccommand = "split" -- live preview of :substitute

-- [[ Splits ]]
vim.opt.splitright = true -- vertical splits open to the right
vim.opt.splitbelow = true -- horizontal splits open below

-- [[ Encoding ]]
vim.opt.fileencoding = "utf-8" -- encoding written to files

-- [[ Misc ]]
vim.opt.shortmess:append("c") -- don't show all completion messages
-- Allow the cursor to wrap to the previous/next line at line edges.
-- (uses `set` because whichwrap contains '<'/'[' which confuse vim.opt type detection)
vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.opt.iskeyword:append({ "-" }) -- treat '-' as part of a word
-- Do not auto-insert comment leaders on newline / auto-continue comments.
vim.opt.formatoptions:remove({ "c", "r", "o" })

-- =============================================================================
-- 3. Keymaps
-- =============================================================================
-- Uses the modern vim.keymap.set (noremap + silent by default).

local map = function(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- [[ Disable F1 ]] (avoid accidental help popups)
map("n", "<F1>", "<nop>", "Disable F1")
map("i", "<F1>", "<nop>", "Disable F1")
map("v", "<F1>", "<nop>", "Disable F1")

-- [[ Search ]]
-- Clear highlights on <Esc> in normal mode.
map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")
map("n", "n", "nzzzv", "Next search result (centered)")
map("n", "N", "Nzzzv", "Previous search result (centered)")

-- [[ Window navigation ]] (Ctrl + hjkl)
map("n", "<C-h>", "<C-w>h", "Move to left window")
map("n", "<C-j>", "<C-w>j", "Move to lower window")
map("n", "<C-k>", "<C-w>k", "Move to upper window")
map("n", "<C-l>", "<C-w>l", "Move to right window")

-- Resize with Ctrl + arrows
map("n", "<C-Up>", "<cmd>resize -2<CR>", "Resize up")
map("n", "<C-Down>", "<cmd>resize +2<CR>", "Resize down")
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", "Resize left")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", "Resize right")

-- [[ Buffers ]]
map("n", "<S-h>", "<cmd>bprevious<CR>", "Previous buffer")
map("n", "<S-l>", "<cmd>bnext<CR>", "Next buffer")

-- [[ Splits ]]
map("n", "<leader>h", "<cmd>split<CR>", "Horizontal split")
map("n", "<leader>v", "<cmd>vsplit<CR>", "Vertical split")

-- [[ File tree ]]
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", "Toggle file tree")

-- [[ Move lines ]]
map("n", "<A-j>", "<cmd>m .+1<CR>==", "Move line down")
map("n", "<A-k>", "<cmd>m .-2<CR>==", "Move line up")
map("v", "<A-j>", ":m '>+1<CR>gv=gv", "Move selection down")
map("v", "<A-k>", ":m '<-2<CR>gv=gv", "Move selection up")

-- [[ Indent / paste in visual mode ]]
map("v", "<", "<gv", "Indent left (keep selection)")
map("v", ">", ">gv", "Indent right (keep selection)")
map("v", "p", '"_dP', "Paste without overwriting register")

-- [[ Visual block ]]
map("x", "J", ":move '>+1<CR>gv-gv", "Move block down")
map("x", "K", ":move '<-2<CR>gv-gv", "Move block up")
map("x", "<A-j>", ":move '>+1<CR>gv-gv", "Move block down")
map("x", "<A-k>", ":move '<-2<CR>gv-gv", "Move block up")

-- [[ Insert ]]
map("i", "jj", "<Esc>", "Exit insert mode")

-- [[ Diagnostics ]]
map("n", "<leader>q", vim.diagnostic.setloclist, "Open diagnostic quickfix")
map("n", "<leader>d", vim.diagnostic.open_float, "Open diagnostic float")
map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

-- [[ Terminal ]]
map("t", "<Esc><Esc>", "<C-\\><C-n>", "Exit terminal mode")

-- =============================================================================
-- 4. Autocommands
-- =============================================================================

-- Highlight text when yanking (copying).
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking",
	group = vim.api.nvim_create_augroup("config-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- =============================================================================
-- 5. Plugins (lazy.nvim)
-- =============================================================================

-- Bootstrap lazy.nvim (clones it on first run).
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specs go inside the table below. See `:help lazy.nvim`.
require("lazy").setup({
	-- File explorer (sidebar tree).
	-- Toggle with `<leader>e`. Default mappings inside the tree:
	--   <CR> open, a create, d delete, r rename, x cut, y copy, p paste.
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			-- Disable netrw, nvim-tree replaces it.
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			require("nvim-tree").setup({
				view = {
					width = 30,
					side = "left",
				},
			})
		end,
	},

	-- Statusline (from mini.nvim).
	-- Layout: mode + filename (left) | git · diagnostics · filetype · position (right).
	-- Git and diagnostics sections appear automatically once gitsigns / LSP are added.
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			local statusline = require("mini.statusline")
			statusline.setup({
				use_icons = vim.g.have_nerd_font,
				content = {
					active = function()
						local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
						local filename = statusline.section_filename({ trunc_width = 140 })
						local git = statusline.section_git({ trunc_width = 75 })
						local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
						local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
						local location = statusline.section_location({ trunc_width = 75 })

						return statusline.combine_groups({
							{ hl = mode_hl, strings = { mode } },
							{ hl = "MiniStatuslineFilename", strings = { filename } },
							"%<", -- truncation point (filename shrinks first)
							"%=", -- right-align everything after this
							{ hl = "MiniStatuslineGit", strings = { git } },
							{ hl = "MiniStatuslineDiagnostics", strings = { diagnostics } },
							{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
							{ hl = "MiniStatuslineLocation", strings = { location } },
						})
					end,
				},
			})
		end,
	},

	-- Syntax highlighting + indentation via tree-sitter.
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"go",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	-- LSP (Language Server Protocol): diagnostics, go-to-def, rename, hover, etc.
	-- Mason installs and manages the language servers and Go tooling.
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} }, -- LSP progress / status
			"saghen/blink.cmp", -- completion (provides LSP capabilities)
		},
		config = function()
			-- Keymaps + reference highlighting when a language server attaches.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("config-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, modes)
						modes = modes or { "n" }
						vim.keymap.set(modes, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("gra", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					map("grr", vim.lsp.buf.references, "[R]eferences")
					map("gri", vim.lsp.buf.implementation, "[I]mplementation")
					map("grd", vim.lsp.buf.definition, "[D]efinition")
					map("grD", vim.lsp.buf.declaration, "[D]eclaration")
					map("gO", vim.lsp.buf.document_symbol, "Document symbols")
					map("gW", vim.lsp.buf.workspace_symbol, "Workspace symbols")
					map("grt", vim.lsp.buf.type_definition, "[T]ype definition")
					map("K", vim.lsp.buf.hover, "Hover documentation")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

					local client = vim.lsp.get_client_by_id(event.data.client_id)

					-- Toggle inlay hints (if the server supports them).
					if
						client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle inlay [H]ints")
					end

					-- Highlight references under the cursor.
					if
						client
						and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
					then
						local group = vim.api.nvim_create_augroup("config-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = group,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = group,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			-- Diagnostics appearance.
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(d)
						return d.message
					end,
				},
			})

			-- Broadcast completion capabilities to the servers.
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local util = require("lspconfig/util")

			local servers = {
				gopls = {
					-- Use the gopls installed via `go install` (~/go/bin), not Mason's copy.
					cmd = { vim.fn.expand("~/go/bin/gopls") },
					filetypes = { "go", "gomod", "gowork", "gotmpl" },
					root_dir = util.root_pattern("go.work", "go.mod", ".git"),
					settings = {
						gopls = {
							completeUnimported = true,
							usePlaceholders = true,
							analyses = { unusedparams = true },
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = { completion = { callSnippet = "Replace" } },
					},
				},
			}

			-- Non-Go tools installed via Mason. Go tools (gopls, gofumpt, goimports,
			-- delve) are installed via `go install` into ~/go/bin (see `go env GOPATH`).
			require("mason-tool-installer").setup({
				ensure_installed = { "lua-language-server", "stylua" },
			})

			-- Set up each server directly: gopls comes from `go install`,
			-- lua_ls is found via Mason's bin dir on PATH.
			for name, server in pairs(servers) do
				server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
				require("lspconfig")[name].setup(server)
			end
		end,
	},

	-- Formatting: format on save + <leader>f.
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable format-on-save for languages without a stable style.
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				end
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "gofumpt", "goimports" },
			},
		},
	},

	-- Autocompletion.
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			{ "L3MON4D3/LuaSnip", version = "2.*" },
		},
		opts = {
			keymap = { preset = "default" },
			appearance = { nerd_font_variant = "mono" },
			completion = {
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},
			sources = {
				default = { "lsp", "path", "snippets" },
			},
			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "lua" },
			signature = { enabled = true },
		},
	},
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- =============================================================================
-- 6. Colorscheme
-- =============================================================================
-- Ash — a light, monochrome theme with a single red accent (see colors/ash.lua).
-- Variants: 'warm' | 'greige' (default) | 'neutral'.
-- Set LAST so it overrides plugin-defined highlights (e.g. nvim-tree).
vim.g.ash_variant = "greige"
vim.cmd.colorscheme("ash")
