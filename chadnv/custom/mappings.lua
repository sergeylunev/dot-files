local M = {}

M.custom = {
  n = {
    ["<F1>"] = {"<Esc>"},
    ["<C-Up>"] = {":resize -2<CR>", "Resize up"},
    ["<C-Down>"] = {":resize +2<CR>", "Resize down"},
    ["<C-Left>"] = {":vertical resize -2<CR>", "Resize left"},
    ["<C-Right>"] = {":vertical resize +2<CR>", "Resize right"},
    ["<A-j>"]  = { "<Esc>:m .+1<CR>==g", "Move text down" },
    ["<A-k>"]  = { "<Esc>:m .-2<CR>==g", "Move text up" },
    ["n"] = {"nzzzv", "Center cursor on search"},
    ["N"] = {"Nzzzv", "Center cursor on search"},
    ["<leader>h"] = { ":<C-u>split<CR>", "Split horizontal"},
    ["<leader>v"] = { ":<C-u>vsplit<CR>", "Split vertical"},
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<C-d>"] = { "<C-d>zz",  },
    ["<C-u>"] = { "<C-u>zz",  },
  },
  i = {
    ["<F1>"] = {"<Esc>"},
    ["jj"] = { "<Esc>", "escaping insert mode", opts = {nowait = true}}
  },
  v = {
    ["<F1>"] = {"<Esc>"},
    ["<"] = {"<gv"},
    [">"] = {">gv"},
  }
}
M.undotree = {
  n = {
    ["<leader>u"] = { vim.cmd.UndotreeToggle },
  }
}

return M
