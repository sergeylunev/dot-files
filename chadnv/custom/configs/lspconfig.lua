local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local utils = require("lspconfig/util")

lspconfig.gopls.setup {
  on_attach  = on_attach,
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = utils.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}

lspconfig.phpactor.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "phpactor", "language-server" },
  filetypes = { "php" },
  root_dir = utils.root_pattern("composer.json", ".git"),
}
