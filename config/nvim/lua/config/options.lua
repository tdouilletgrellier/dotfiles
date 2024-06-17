-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here


-- Custom syntax highlighting  colors for EPX
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

-- EPX syntax detection
vim.cmd("au BufRead,BufNewFile *.epx set filetype=epx")

-- FIxed form Fortran by default
vim.cmd("let b:fortran_fixed_source = 1")