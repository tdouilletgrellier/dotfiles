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

-- Mappings

-- <C> -> Ctrl
-- <leader> -> Space
-- <A> -> alt
-- <S> -> shift
-- <M> -> meta (cmd key on mac)
-- <D> -> super (windows key on windows)
-- <kPoint> -> Keypad Point (.)
-- <kEqual> -> Keypad Equal (=)
-- <kPlus> -> Keypad Plus (+)
-- <kMinus> -> Keypad Minus (-)

--[[vim.keymap.set("n", "<A-/>", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "  Toggle comment"})]]

-- NewLine with Shift+Enter
vim.keymap.set("n", "o", "o<ESC>", { desc = " New line Below" })
vim.keymap.set("n", "O", "O<ESC>", { desc = " New line Above" })


-- Move line up and down
vim.keymap.set("i", "<A-Up>", "<CMD>m .-2<CR>==", { desc = "󰜸 Move line up" })
vim.keymap.set("i", "<A-Down>", "<CMD>m .+1<CR>==", { desc = "󰜸 Move line down" })

-- Navigate (insert)
vim.keymap.set("i", "<A-Left>", "<ESC>I", { desc = " Move to beginning of line" })
vim.keymap.set("i", "<A-Right>", "<ESC>A", { desc = " Move to end of line" })
-- vim.keymap.set("i", "<A-d>", "<ESC>diw", { desc = " Delete word" })

vim.keymap.set("n", "<A-Left>", "<ESC>_", { desc = "󰜲 Move to beginning of line" })
vim.keymap.set("n", "<A-Right>", "<ESC>$", { desc = "󰜵 Move to end of line" })
vim.keymap.set("n", "<C-a>", "gg0vG", { desc = " Select all" })
-- vim.keymap.set("n", "<F3>", "nzzzv", { desc = " Next" })
-- vim.keymap.set("n", "<S-F3>", "Nzzzv", { desc = " Previous" })
vim.keymap.set("n", "<C-z>", "<ESC><CMD>u<CR>", { desc = "󰕌 Undo" })
vim.keymap.set("n", "<C-r>", "<ESC><CMD>redo<CR>", { desc = "󰑎 Redo" })
vim.keymap.set("v", "<C-z>", "<ESC><CMD>u<CR>", { desc = "󰕌 Undo" })
vim.keymap.set("v", "<C-r>", "<ESC><CMD>redo<CR>", { desc = "󰑎 Redo" })
vim.keymap.set("i", "<C-z>", "<ESC><CMD>u<CR>", { desc = "󰕌 Undo" })
vim.keymap.set("i", "<C-r>", "<ESC><CMD>redo<CR>", { desc = "󰑎 Redo" })
vim.keymap.set("n", "<BS>", "<C-o>", { desc = "Return" })

-- vim.keymap.set("n", "<C-x>", "x", { desc = "󰆐 Cut" })
-- vim.keymap.set("n", "<C-v>", "p`[v`]=", { desc = "󰆒 Paste" })
-- vim.keymap.set("n", "<C-c>", "y", { desc = " Copy" })

-- vim.keymap.set("i", "<C-c>", "y", { desc = " Copy" })
-- vim.keymap.set("v", "<C-c>", "y", { desc = " Copy" })

vim.keymap.set("n", "p", "p`[v`]=", { desc = "󰆒 Paste" })
vim.keymap.set("n", "<leader><leader>p","printf('`[%s`]', getregtype()[0])", { desc = "Reselect last pasted area" }, {expr = true})
vim.keymap.set("n", "<leader><leader>d", "viw",{ desc = " Select word" })
vim.keymap.set("n", "<leader>d", 'viw"_di', { desc = " Delete word" })
vim.keymap.set("n", "<A-Up>", "<CMD>m .-2<CR>==", { desc = "󰜸 Move line up" })
vim.keymap.set("n", "<A-Down>", "<CMD>m .+1<CR>==", { desc = "󰜯 Move line down" })        

vim.keymap.set("v", "<A-Up>", ":m'<-2<CR>gv=gv", { desc = "󰜸 Move selection up"}, {opts = { silent = true } })
vim.keymap.set("v", "<A-Down>", ":m'>+1<CR>gv=gv", { desc = "󰜯 Move selection down"}, {opts = { silent = true } })
--vim.keymap.set("v", "<Home>", "gg", { desc = "Home" })
--vim.keymap.set("v", "<End>", "G", { desc = "End" })
vim.keymap.set("v", "y", "y`]", { desc = "Yank and move to end" })
vim.keymap.set("v", "<", "<gv", { desc = " Ident backward"}, {opts = { silent = false }})
vim.keymap.set("v", ">", ">gv", { desc = " Ident forward"}, {opts = { silent = false }})
 
vim.keymap.set("v", "<A-Left>", "<ESC>_", { desc = "󰜲 Move to beginning of line" })
vim.keymap.set("v", "<A-Right>", "<ESC>$", { desc = "󰜵 Move to end of line" })

vim.keymap.set("n", "<leader><leader>h", "<CMD>vs <CR>", { desc = "󰤼 Vertical split"}, {opts = { nowait = true } })
vim.keymap.set("n", "<leader><leader>v", "<CMD>sp <CR>", { desc = "󰤻 Horizontal split"}, {opts = { nowait = true } })