-- Options loaded before LazyVim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- ========================
-- Custom Syntax Highlighting for EPX
-- ========================
-- Load the custom palette
local palette = require("colors.palette_custom")

-- Define the highlights using the custom palette
local highlights = {
  epxNumber = { fg = palette.red }, -- Use 'red' from custom palette
  epxWord = { fg = palette.fg }, -- Use 'fg' (foreground) for general words
  epxKeywords = { fg = palette.blue }, -- Use 'blue' for primary keywords
  epxKeywords0 = { fg = palette.green }, -- Use 'successGreen' for alternate keywords
  epxVariable = { fg = palette.magenta }, -- Use 'magenta' for variables
  epxEqual = { fg = palette.green }, -- Use 'green' for equality operators
  epxString = { fg = palette.yellow }, -- Use 'neonYellow' for strings
  epxComment = { fg = palette.bgHighlight }, -- Use 'bgHighlight' for comments
  epxTitle = { fg = palette.orange }, -- Use 'orange' for titles
  epxDescBlock = { fg = palette.grey }, -- Use 'grey' for descriptive blocks
}

-- Apply the highlights
for group, style in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, style)
end

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

-- Disable all snacks animations
vim.g.snacks_animate = false
