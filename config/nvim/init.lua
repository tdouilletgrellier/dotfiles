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
vim.o.cursorline = true -- does not enable cursor line
vim.o.cursorlineopt = number -- does not enable cursor line
vim.cmd("highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NON")
vim.cmd("highlight CursorLineNr cterm=bold term=bold gui=bold")

-- Mouse on
vim.o.mouse = "a" 

-- Hardtime on
require("hardtime").setup()
local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}
local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

vim.g.rainbow_delimiters = { highlight = highlight }
require("ibl").setup { scope = { highlight = highlight } }

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)