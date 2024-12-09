return {
  {
    "cappyzawa/trim.nvim",
    config = function()
      -- Load custom color palette
      local palette = require("colors.palette_custom")

      -- Setup trim.nvim with valid options
      require("trim").setup({
        ft_blocklist = {},
        -- If you want to ignore markdown files, you can specify filetypes.
        -- ft_blocklist = {"markdown"},
        -- If you want to remove multiple blank lines
        patterns = {
          [[%s/\(\n\n\)\n\+/\1/]], -- replace multiple blank lines with a single line
        },
        trim_on_write = true,
        trim_trailing = true,
        trim_last_line = true,
        trim_first_line = true,
        -- Set the highlight for trailing spaces using the custom palette
        highlight = true, -- Enable highlight for trailing spaces
        highlight_bg = palette.red, -- Set to custom color (e.g., red from palette)
        highlight_ctermbg = "red", -- Optional: use terminal background color if needed
        notifications = true,
      })
    end,
  },
}
