" Relative line numbers
set number relativenumber

let mapleader = " "

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

" oo and OO to add new line
nmap oo o<Esc>
nmap OO O<Esc>

"" Make Y behave like C or D
"nmap Y y$
"
"" Keep window centered when going up/down
"nmap J mzJ`z
"nmap <C-d> <C-d>zz
"nmap <C-u> <C-u>zz
"nmap n nzzzv
"nmap N Nzzzv
"
"" Paste without overwriting register
"vmap p "_dP
"nmap p "_dP
"
"" Copy text to " register
"nmap <leader>y "+y
"vmap <leader>y "+y
"nmap <leader>Y "+Y
"
"" Delete text to " register
"nmap <leader>d "_d
"vmap <leader>d "_d
"
"" Navigate between quickfix items
"vnmap <leader>h <cmd>cnext<CR>zz
"vnmap <leader>; <cmd>cprev<CR>zz
"
"" Navigate between location list items
"nmap <leader>k <cmd>lnext<CR>zz
"nmap <leader>j <cmd>lprev<CR>zz
"
"" Replace word under cursor across entire buffer
"nmap <leader>sf :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
"
"" Visual "
"" Stay in indent mode
"vmap < <gv
"vmap > >gv
"
"" Move block
"vmap J :m '>+1<CR>gv=gv
"vmap K :m '<-2<CR>gv=gv

" Disable arrow keys in normal mode
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