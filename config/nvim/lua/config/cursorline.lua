-- Load custom color palette
local palette = require("colors.palette_custom")

-- Enable cursorline and cursorcolumn
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.cursorlineopt = "both" -- Highlight both the line and the number

-- Highlight groups with the custom color palette
vim.api.nvim_set_hl(0, "CursorLine", { bg = palette.bgAlt })       -- Use bgAlt for cursor line background
vim.api.nvim_set_hl(0, "CursorColumn", { bg = palette.bgAlt })    -- Use bgAlt for cursor column background
vim.api.nvim_set_hl(0, "CursorLineNr", { bold = true, fg = palette.yellow }) -- Use yellow for cursor line number
