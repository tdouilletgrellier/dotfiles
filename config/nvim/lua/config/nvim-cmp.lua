-- lua/config/nvim-cmp.lua

local cmp = require("cmp")

cmp.setup({
  sources = {
        { name = "nvim_lsp" },         -- LSP for C/C++, Python, etc.
        { name = "luasnip" },          -- Snippets (useful for Python, C++)
        { name = "buffer" },           -- Buffers (file contents)
        { name = "path" },             -- Path completion (for file navigation)
        { name = "spell" },            -- Spelling correction
        { name = "cmp_git" },          -- Git completion (for filenames, branches, etc.)
  },
})
