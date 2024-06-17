-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
local cyberdream = require("lualine.themes.cyberdream") --.get_theme()
require("lualine").setup({
  options = { theme = cyberdream },
})

vim.cmd("colorscheme cyberdream") 


