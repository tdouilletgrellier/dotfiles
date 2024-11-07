-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local hardmode = true
if hardmode then
  -- Show an error message if a disabled key is pressed
  local msg = [[<cmd>echohl Error | echo "KEY DISABLED" | echohl None<CR>]]

  -- Disable arrow keys in insert mode with a styled message
  vim.api.nvim_set_keymap("i", "<Up>", "<C-o>" .. msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap("i", "<Down>", "<C-o>" .. msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap("i", "<Left>", "<C-o>" .. msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap("i", "<Right>", "<C-o>" .. msg, { noremap = true, silent = false })
  --vim.api.nvim_set_keymap("i", "<Del>", "<C-o>" .. msg, { noremap = true, silent = false })
  --vim.api.nvim_set_keymap("i", "<BS>", "<C-o>" .. msg, { noremap = true, silent = false })

  -- Disable arrow keys in normal mode with a styled message
  vim.api.nvim_set_keymap("n", "<Up>", msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap("n", "<Down>", msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap("n", "<Left>", msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap("n", "<Right>", msg, { noremap = true, silent = false })
  --vim.api.nvim_set_keymap("n", "<BS>", msg, { noremap = true, silent = false })
end

vim.cmd("nmap oo o<Esc>")
vim.cmd("nmap OO O<Esc>")

-- Make Y behave like C or D
vim.keymap.set("n", "Y", "y$")

-- Keep window centered when going up/down
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without overwriting register
vim.keymap.set("v", "p", '"_dP')
vim.keymap.set("n", "p", '"_dP')

-- Copy text to " register
vim.keymap.set("n", "<leader>y", '"+y', { desc = 'Yank into " register' })
vim.keymap.set("v", "<leader>y", '"+y', { desc = 'Yank into " register' })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = 'Yank into " register' })

-- Delete text to " register
vim.keymap.set("n", "<leader>d", '"_d', { desc = 'Delete into " register' })
vim.keymap.set("v", "<leader>d", '"_d', { desc = 'Delete into " register' })

-- Navigate between quickfix items
vim.keymap.set("n", "<leader>h", "<cmd>cnext<CR>zz", { desc = "Forward qfixlist" })
vim.keymap.set("n", "<leader>;", "<cmd>cprev<CR>zz", { desc = "Backward qfixlist" })

-- Navigate between location list items
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Forward location list" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Backward location list" })

-- Replace word under cursor across entire buffer
vim.keymap.set(
  "n",
  "<leader>sf",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word under cursor" }
)

-- Live Grep (args)
vim.keymap.set(
  "n",
  "<leader>fs",
  require("telescope").extensions.live_grep_args.live_grep_args,
  { desc = "Live Grep (args)" }
)

-- Visual --
-- Stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move block
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Block Down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Block Up" })

-- Search for highlighted text in buffer
vim.keymap.set("v", "//", 'y/<C-R>"<CR>', { desc = "Search for highlighted text" })
-- vim.cmd("nmap <CR> :a<CR><CR>.<CR>")

-- vim.keymap.set("n", "<CR>", "mao<esc>0<S-d>`a<cmd>delmarks a<cr>", { desc = "Add new line below" })
-- vim.keymap.set("n", "<S-CR>", "maO<esc>0<S-d>`a<cmd>delmarks a<cr>", { desc = "Add new line above" })

-- -- Set keymap for normal windows only (e.g. not quickfix)
-- local normal_window_keymap = function(mode, lhs, rhs, opts)
--   local merged_opts = vim.tbl_extend("force", { noremap = true, expr = true }, opts or {})
--
--   vim.keymap.set(mode, lhs, function()
--     local buftype = vim.fn.win_gettype()
--     return buftype == "" and rhs or lhs
--   end, merged_opts)
-- end
--
-- -- Open new line (like o/O) without moving the cursor, without entering insert mode and removing any characters
-- normal_window_keymap("n", "<CR>", "mao<esc>0<S-d>`a<cmd>delmarks a<cr>", { desc = "Add new line below" })
-- normal_window_keymap("n", "<S-CR>", "maO<esc>0<S-d>`a<cmd>delmarks a<cr>", { desc = "Add new line above" })

-- -- Mappings
--
-- -- <C> -> Ctrl
-- -- <leader> -> Space
-- -- <A> -> alt
-- -- <S> -> shift
-- -- <M> -> meta (cmd key on mac)
-- -- <D> -> super (windows key on windows)
-- -- <kPoint> -> Keypad Point (.)
-- -- <kEqual> -> Keypad Equal (=)
-- -- <kPlus> -> Keypad Plus (+)
-- -- <kMinus> -> Keypad Minus (-)
--
-- --[[vim.keymap.set("n", "<A-/>", function()
--   require("Comment.api").toggle.linewise.current()
-- end, { desc = "  Toggle comment"})]]
--
-- -- NewLine with Shift+Enter
-- vim.keymap.set("n", "o", "o<ESC>", { desc = " New line Below" })
-- vim.keymap.set("n", "O", "O<ESC>", { desc = " New line Above" })
--
--
-- -- Move line up and down
vim.keymap.set("i", "<A-k>", "<CMD>m .-2<CR>==", { desc = "󰜸 Move line up" })
vim.keymap.set("i", "<A-j>", "<CMD>m .+1<CR>==", { desc = "󰜸 Move line down" })
--
-- -- Navigate (insert)
vim.keymap.set("i", "<A-h>", "<ESC>I", { desc = " Move to beginning of line" })
vim.keymap.set("i", "<A-l>", "<ESC>A", { desc = " Move to end of line" })
-- -- vim.keymap.set("i", "<A-d>", "<ESC>diw", { desc = " Delete word" })
--
vim.keymap.set("n", "<A-h>", "<ESC>_", { desc = "󰜲 Move to beginning of line" })
vim.keymap.set("n", "<A-l>", "<ESC>$", { desc = "󰜵 Move to end of line" })
vim.keymap.set("n", "<C-a>", "gg0vG", { desc = " Select all" })
-- -- vim.keymap.set("n", "<F3>", "nzzzv", { desc = " Next" })
-- -- vim.keymap.set("n", "<S-F3>", "Nzzzv", { desc = " Previous" })
-- vim.keymap.set("n", "<C-z>", "<ESC><CMD>u<CR>", { desc = "󰕌 Undo" })
-- vim.keymap.set("n", "<C-r>", "<ESC><CMD>redo<CR>", { desc = "󰑎 Redo" })
-- vim.keymap.set("v", "<C-z>", "<ESC><CMD>u<CR>", { desc = "󰕌 Undo" })
-- vim.keymap.set("v", "<C-r>", "<ESC><CMD>redo<CR>", { desc = "󰑎 Redo" })
-- vim.keymap.set("i", "<C-z>", "<ESC><CMD>u<CR>", { desc = "󰕌 Undo" })
-- vim.keymap.set("i", "<C-r>", "<ESC><CMD>redo<CR>", { desc = "󰑎 Redo" })
-- vim.keymap.set("n", "<BS>", "<C-o>", { desc = "Return" })
--
-- -- vim.keymap.set("n", "<C-x>", "x", { desc = "󰆐 Cut" })
-- -- vim.keymap.set("n", "<C-v>", "p`[v`]=", { desc = "󰆒 Paste" })
-- -- vim.keymap.set("n", "<C-c>", "y", { desc = " Copy" })
--
-- -- vim.keymap.set("i", "<C-c>", "y", { desc = " Copy" })
-- -- vim.keymap.set("v", "<C-c>", "y", { desc = " Copy" })
--
-- vim.keymap.set("n", "p", "p`[v`]=", { desc = "󰆒 Paste" })
-- vim.keymap.set("n", "<leader><leader>p","printf('`[%s`]', getregtype()[0])", { desc = "Reselect last pasted area" }, {expr = true})
-- vim.keymap.set("n", "<leader><leader>d", "viw",{ desc = " Select word" })
-- vim.keymap.set("n", "<leader>d", 'viw"_di', { desc = " Delete word" })
vim.keymap.set("n", "<A-k>", "<CMD>m .-2<CR>==", { desc = "󰜸 Move line up" })
vim.keymap.set("n", "<A-j>", "<CMD>m .+1<CR>==", { desc = "󰜯 Move line down" })
--
vim.keymap.set("v", "<A-k>", ":m'<-2<CR>gv=gv", { desc = "󰜸 Move selection up" }, { opts = { silent = true } })
vim.keymap.set("v", "<A-j>", ":m'>+1<CR>gv=gv", { desc = "󰜯 Move selection down" }, { opts = { silent = true } })
-- --vim.keymap.set("v", "<Home>", "gg", { desc = "Home" })
-- --vim.keymap.set("v", "<End>", "G", { desc = "End" })
-- vim.keymap.set("v", "y", "y`]", { desc = "Yank and move to end" })
-- vim.keymap.set("v", "<", "<gv", { desc = " Ident backward"}, {opts = { silent = false }})
-- vim.keymap.set("v", ">", ">gv", { desc = " Ident forward"}, {opts = { silent = false }})
--
vim.keymap.set("v", "<A-h>", "<ESC>_", { desc = "󰜲 Move to beginning of line" })
vim.keymap.set("v", "<A-l>", "<ESC>$", { desc = "󰜵 Move to end of line" })
--
-- vim.keymap.set("n", "<leader><leader>h", "<CMD>vs <CR>", { desc = "󰤼 Vertical split"}, {opts = { nowait = true } })
-- vim.keymap.set("n", "<leader><leader>v", "<CMD>sp <CR>", { desc = "󰤻 Horizontal split"}, {opts = { nowait = true } })--
