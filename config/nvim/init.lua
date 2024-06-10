-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.cmd("colorscheme cyberdream") -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
-- vim.cmd("colorscheme catppuccin") -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

vim.cmd("highlight epxNumber      ctermfg=red  guifg=#cd0000")
vim.cmd("highlight epxWord        ctermfg=white  guifg=#ffffff")
vim.cmd("highlight epxKeywords    ctermfg=blue  guifg=#386bd7")
vim.cmd("highlight epxKeywords0   ctermfg=green  guifg=#98d62d")
vim.cmd("highlight epxVariable    ctermfg=magenta  guifg=#db67e6")
vim.cmd("highlight epxEqual       ctermfg=green  guifg=#79ff0f")
vim.cmd("highlight epxString      ctermfg=yellow  guifg=#f3d64e")
vim.cmd("highlight epxComment     ctermfg=grey  guifg=#666666")
vim.cmd("highlight epxTitle       ctermfg=yellow  guifg=#ffbd5e")
vim.cmd("highlight epxDescBlock   ctermfg=grey  guifg=#666666")

vim.cmd("au BufRead,BufNewFile *.epx set filetype=epx")

vim.cmd("let b:fortran_fixed_source = 1")