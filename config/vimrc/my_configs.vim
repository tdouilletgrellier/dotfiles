" Relative line numbers
set number relativenumber

" Color scheme
colorscheme Tomorrow-Night-Bright 

" Transparent background
hi Normal guibg=NONE ctermbg=NONE

" Escape to desactive serach hl
nnoremap <Esc><Esc> :nohlsearch<CR>

" Custom colors for EPX
highlight epxNumber      ctermfg=red  guifg=#cd0000
highlight epxWord        ctermfg=white  guifg=#ffffff
highlight epxKeywords    ctermfg=blue  guifg=#386bd7
highlight epxKeywords0   ctermfg=green  guifg=#98d62d
highlight epxVariable    ctermfg=magenta  guifg=#db67e6
highlight epxEqual       ctermfg=green  guifg=#79ff0f
highlight epxString      ctermfg=yellow  guifg=#f3d64e
highlight epxComment     ctermfg=grey  guifg=#666666
highlight epxTitle       ctermfg=yellow  guifg=#ffbd5e
highlight epxDescBlock   ctermfg=grey  guifg=#666666


nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>
" ...and in command mode
cnoremap <Left>  <ESC>:echoe "Use h"<CR>
cnoremap <Right> <ESC>:echoe "Use l"<CR>
cnoremap <Up>    <ESC>:echoe "Use k"<CR>
cnoremap <Down>  <ESC>:echoe "Use j"<CR>
" ...and in visual mode
vnoremap <Left>  <ESC>:echoe "Use h"<CR>
vnoremap <Right> <ESC>:echoe "Use l"<CR>
vnoremap <Up>    <ESC>:echoe "Use k"<CR>
vnoremap <Down>  <ESC>:echoe "Use j"<CR>