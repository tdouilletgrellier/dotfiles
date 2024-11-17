-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- local hardmode = true
-- if hardmode then
--   -- Show an error message if a disabled key is pressed
--   local msg = [[<cmd>echohl Error | echo "KEY DISABLED" | echohl None<CR>]]

--   -- Disable arrow keys in insert mode with a styled message
--   vim.api.nvim_set_keymap("i", "<Up>", "<C-o>" .. msg, { noremap = true, silent = false })
--   vim.api.nvim_set_keymap("i", "<Down>", "<C-o>" .. msg, { noremap = true, silent = false })
--   vim.api.nvim_set_keymap("i", "<Left>", "<C-o>" .. msg, { noremap = true, silent = false })
--   vim.api.nvim_set_keymap("i", "<Right>", "<C-o>" .. msg, { noremap = true, silent = false })
--   --vim.api.nvim_set_keymap("i", "<Del>", "<C-o>" .. msg, { noremap = true, silent = false })
--   --vim.api.nvim_set_keymap("i", "<BS>", "<C-o>" .. msg, { noremap = true, silent = false })

--   -- Disable arrow keys in normal mode with a styled message
--   vim.api.nvim_set_keymap("n", "<Up>", msg, { noremap = true, silent = false })
--   vim.api.nvim_set_keymap("n", "<Down>", msg, { noremap = true, silent = false })
--   vim.api.nvim_set_keymap("n", "<Left>", msg, { noremap = true, silent = false })
--   vim.api.nvim_set_keymap("n", "<Right>", msg, { noremap = true, silent = false })
--   --vim.api.nvim_set_keymap("n", "<BS>", msg, { noremap = true, silent = false })
-- end

vim.keymap.set("n", "oo", "O<Esc>", { desc = "Insert New Line (Below)" })
vim.keymap.set("n", "OO", "O<Esc>", { desc = "Insert New Line (Above)" })

-- Make Y behave like C or D
vim.keymap.set("n", "Y", "y$", { desc = "Copy Until End of Line" })

-- Keep window centered when going up/down
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join Lines" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next Result" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous Result" })

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

-- Resize window using <ctrl> arrow keys
map("n", "<C-S-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Visual --
-- Stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move block
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Block Down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Block Up" })

-- Search for highlighted text in buffer
vim.keymap.set("v", "//", 'y/<C-R>"<CR>', { desc = "Search for highlighted text" })

-- -- Move line up and down (insert+normal+visual)
vim.keymap.set("i", "<A-k>", "<CMD>m .-2<CR>==", { desc = "󰜸 Move line up" })
vim.keymap.set("i", "<A-j>", "<CMD>m .+1<CR>==", { desc = "󰜸 Move line down" })
vim.keymap.set("n", "<A-k>", "<CMD>m .-2<CR>==", { desc = "󰜸 Move line up" })
vim.keymap.set("n", "<A-j>", "<CMD>m .+1<CR>==", { desc = "󰜯 Move line down" })
vim.keymap.set("v", "<A-k>", ":m'<-2<CR>gv=gv", { desc = "󰜸 Move selection up" }, { opts = { silent = true } })
vim.keymap.set("v", "<A-j>", ":m'>+1<CR>gv=gv", { desc = "󰜯 Move selection down" }, { opts = { silent = true } })

-- -- Navigate (insert+normal+visual)
vim.keymap.set("i", "<A-h>", "<ESC>I", { desc = " Move to beginning of line" })
vim.keymap.set("i", "<A-l>", "<ESC>A", { desc = " Move to end of line" })
vim.keymap.set("n", "<A-h>", "<ESC>_", { desc = "󰜲 Move to beginning of line" })
vim.keymap.set("n", "<A-l>", "<ESC>$", { desc = "󰜵 Move to end of line" })
vim.keymap.set("v", "<A-h>", "<ESC>_", { desc = "󰜲 Move to beginning of line" })
vim.keymap.set("v", "<A-l>", "<ESC>$", { desc = "󰜵 Move to end of line" })

-- Select all
vim.keymap.set("n", "<C-a>", "gg0vG", { desc = " Select all" })
