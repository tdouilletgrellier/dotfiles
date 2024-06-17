-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
local cyberdream = require("lualine.themes.cyberdream") --.get_theme()
require("lualine").setup({
  options = { theme = cyberdream },
})

vim.cmd("colorscheme cyberdream")

vim.cmd('highlight TelescopeBorder guibg=none')
vim.cmd('highlight TelescopeTitle guibg=none')

vim.api.nvim_set_hl(0,"TelescopeNormal",{bg="none"})