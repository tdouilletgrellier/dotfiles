return{

  {
    "cappyzawa/trim.nvim",
    config = function()
      require("trim").setup({
        ft_blocklist = {},
        -- if you want to ignore markdown file.
        -- you can specify filetypes.
        -- ft_blocklist = {"markdown"},
        -- if you want to remove multiple blank lines
        patterns = {
          [[%s/\(\n\n\)\n\+/\1/]], -- replace multiple blank lines with a single line
        },
        trim_on_write = true,
        trim_trailing = true,
        trim_last_line = true,
        trim_first_line = true,
        -- highlight trailing spaces
        highlight = false,
        highlight_bg = "#ff0000", -- or 'red'
        highlight_ctermbg = "red",
        notifications = true,
      })
    end,
  },
    
}