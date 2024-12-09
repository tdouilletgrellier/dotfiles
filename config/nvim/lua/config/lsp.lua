-- lua/config/lsp.lua
-- Load LSP configurations

-- C/C++ LSP setup with clangd
require("lspconfig").clangd.setup({
  cmd = { "clangd" },
  filetypes = { "c", "cpp" },
})

-- Fortran LSP setup with fortls
require("lspconfig").fortls.setup({
  cmd = { "fortls" },
  filetypes = { "fortran" },
  settings = { fortran = { format = { indent = 2 } } },
})

-- Python LSP setup with pyright
require("lspconfig").pyright.setup({
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
})

-- CMake LSP setup with cmake-language-server
require("lspconfig").cmake.setup({
  cmd = { "cmake-language-server" },
  filetypes = { "cmake" },
})

-- Bash LSP setup with bashls
require("lspconfig").bashls.setup({
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh" },
})

-- Load custom color palette
local palette = require("colors.palette_custom")

-- Highlight group for LSP references
vim.api.nvim_set_hl(0, "LspReferenceText", { bg = palette.bgAlt, fg = palette.fg }) -- Text references
vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = palette.bgAlt, fg = palette.green }) -- Read references
vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = palette.bgAlt, fg = palette.orange }) -- Write references
