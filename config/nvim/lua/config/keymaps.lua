-- Keymaps Configuration
-- Add or override keymaps for Neovim using LazyVim

-- Keymap helper for cleaner code
local keymap = vim.keymap.set

-- ========================
-- NORMAL MODE KEYMAPS
-- ========================
-- New lines without entering insert mode
keymap("n", "oo", "o<Esc>", { desc = "Insert New Line (Below)" })
keymap("n", "OO", "O<Esc>", { desc = "Insert New Line (Above)" })

-- Yank until end of line (Y behaves like D)
keymap("n", "Y", "y$", { desc = "Copy Until End of Line" })

-- Center cursor when scrolling or searching
keymap("n", "J", "mzJ`z", { desc = "Join Lines" })
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up" })
keymap("n", "n", "nzzzv", { desc = "Next Result" })
keymap("n", "N", "Nzzzv", { desc = "Previous Result" })

-- Replace word under cursor across buffer
keymap(
  "n",
  "<leader>sf",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace Word Under Cursor" }
)

-- Live Grep (args) with Telescope
-- keymap("n", "<leader>fs", require("telescope").extensions.live_grep_args.live_grep_args, { desc = "Live Grep (args)" })

-- Resize splits
keymap("n", "<A-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
keymap("n", "<A-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
keymap("n", "<A-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
keymap("n", "<A-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move lines up and down
keymap("n", "<A-k>", "<CMD>m .-2<CR>==", { desc = "Move Line Up", silent = true })
keymap("n", "<A-j>", "<CMD>m .+1<CR>==", { desc = "Move Line Down", silent = true })

-- Navigate to line start and end
keymap("n", "<A-h>", "^", { desc = "Move to Beginning of Line" })
keymap("n", "<A-l>", "$", { desc = "Move to End of Line" })

-- Select all
keymap("n", "<C-a>", "ggVG", { desc = "Select All" })

-- Remap delete and change to not copy text
keymap("n", "d", '"_d', { desc = "Delete without copying" })
keymap("n", "dd", '"_dd', { desc = "Delete line without copying" })
keymap("n", "c", '"_c', { desc = "Change without copying" })
keymap("n", "cc", '"_cc', { desc = "Change line without copying" })
keymap("n", "x", '"_x', { desc = "Delete single character without copying" })
keymap("n", "D", '"_D', { desc = "Delete line without copying" })
keymap("n", "C", '"_C', { desc = "Change line without copying" })

-- ========================
-- COMMAND MODE KEYMAPS
-- ========================
-- Accept completion in command line with Enter
keymap("c", "<CR>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-y>" -- Confirm selection in the popup menu
  else
    return "<CR>" -- Normal Enter behavior
  end
end, { expr = true, noremap = true, desc = "Accept completion with Enter" })

-- ========================
-- VISUAL MODE KEYMAPS
-- ========================
-- Stay in indent mode
keymap("v", "<", "<gv", { desc = "Indent Left" })
keymap("v", ">", ">gv", { desc = "Indent Right" })

-- Move blocks up and down
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Block Down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Block Up" })

-- Search for highlighted text
keymap("v", "//", 'y/<C-R>"<CR>', { desc = "Search Highlighted Text" })

-- Move lines up and down
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move Selection Up", silent = true })
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move Selection Down", silent = true })

-- Navigate to line start and end
keymap("v", "<A-h>", "^", { desc = "Move to Beginning of Line" })
keymap("v", "<A-l>", "$", { desc = "Move to End of Line" })

-- Remap delete and change to not copy text
keymap("v", "d", '"_d', { desc = "Delete without copying (visual)" })
keymap("v", "c", '"_c', { desc = "Change without copying (visual)" })
keymap("v", "X", '"_x', { desc = "Delete block without copying (visual)" })

-- ========================
-- INSERT MODE KEYMAPS
-- ========================
-- Move lines up and down
keymap("i", "<A-k>", "<CMD>m .-2<CR>==", { desc = "Move Line Up" })
keymap("i", "<A-j>", "<CMD>m .+1<CR>==", { desc = "Move Line Down" })

-- Navigate to line start and end
keymap("i", "<A-h>", "<ESC>I", { desc = "Move to Beginning of Line" })
keymap("i", "<A-l>", "<ESC>A", { desc = "Move to End of Line" })

-- ========================
-- BLACK HOLE REGISTER PREFIX
-- ========================
-- Use Z as a prefix for "delete without copying"
keymap("n", "Z", '"_', { desc = "Use Black Hole Register Prefix" })
keymap("v", "Z", '"_', { desc = "Use Black Hole Register Prefix" })
