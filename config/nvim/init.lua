-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Cyberdream lualine theme
local cyberdream = require("lualine.themes.cyberdream") --.get_theme()
require("lualine").setup({
  options = { theme = cyberdream },
})
vim.cmd("colorscheme cyberdream")

-- Vim theme (green on black)
-- vim.cmd("colorscheme vim")

-- Telescope transparency
vim.cmd("highlight TelescopeBorder guibg=none")
vim.cmd("highlight TelescopeTitle guibg=none")
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })

-- No cursor line, fomrating current line number
-- vim.o.cursorline = true -- does not enable cursor line
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.cursorlineopt = number -- does not enable cursor line
vim.cmd("highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE")
vim.cmd("highlight CursorLineNr cterm=bold term=bold gui=bold guifg=#e7bf00")
vim.cmd("highlight CursorLine guibg=#2a2a2a")
vim.cmd("highlight CursorColumn guibg=#2a2a2a")

-- Mouse on
vim.o.mouse = "a"

-- Hardtime on
-- require("hardtime").setup()
local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}
local hooks = require("ibl.hooks")
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#cd0000" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#e7bf00" })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#386bd7" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#ff8700" })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#79ff0f" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#db67e6" })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#79dff2" })
end)

vim.g.rainbow_delimiters = { highlight = highlight }
require("ibl").setup({ scope = { highlight = highlight } })

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
