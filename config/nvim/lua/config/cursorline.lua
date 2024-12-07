vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.cursorlineopt = "number"

-- Highlight groups
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2a2a2a" })
vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#2a2a2a" })
vim.api.nvim_set_hl(0, "CursorLineNr", { bold = true, fg = "#e7bf00" })
