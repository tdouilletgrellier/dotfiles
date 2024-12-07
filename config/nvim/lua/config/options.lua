-- Options loaded before LazyVim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- ========================
-- Custom Syntax Highlighting for EPX
-- ========================
local highlights = {
  epxNumber    = { fg = "#cd0000" },
  epxWord      = { fg = "#ffffff" },
  epxKeywords  = { fg = "#386bd7" },
  epxKeywords0 = { fg = "#98d62d" },
  epxVariable  = { fg = "#db67e6" },
  epxEqual     = { fg = "#79ff0f" },
  epxString    = { fg = "#f3d64e" },
  epxComment   = { fg = "#666666" },
  epxTitle     = { fg = "#ffbd5e" },
  epxDescBlock = { fg = "#666666" },
}

for group, settings in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, settings)
end

-- ========================
-- Filetype Detection and Settings
-- ========================
-- Detect EPX files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.epx",
  callback = function()
    vim.bo.filetype = "epx"
  end,
})

-- Fixed-form Fortran by default
vim.g.fortran_fixed_source = 1

-- ========================
-- Diagnostics and Mouse
-- ========================
-- Disable diagnostics by default (<leader>ud to toggle in LazyVim)
vim.diagnostic.enable(false)

-- Mouse support
vim.opt.mouse = "a"

-- Disable "copy on select"
vim.g.overrideCopy = false
