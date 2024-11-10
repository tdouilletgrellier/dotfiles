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

-- Hardtime on
require("hardtime").setup()