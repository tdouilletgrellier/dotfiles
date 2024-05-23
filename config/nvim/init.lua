-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.g.aurora_darker = true
vim.g.aurora_bold = true
vim.g.aurora_transparent = true
vim.cmd 'colorscheme aurora' -- if the above fails, then use default
