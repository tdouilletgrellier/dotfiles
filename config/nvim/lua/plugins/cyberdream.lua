return {

  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Load the chosen palette
      local palette = require("colors.palette_custom") -- Change this line to load different palettes

      require("cyberdream").setup({
        -- Enable transparent background
        transparent = true,

        -- Enable italics comments
        italic_comments = true,

        -- Replace all fillchars with ' ' for the ultimate clean look
        hide_fillchars = true,

        -- Modern borderless telescope theme
        borderless_pickers = false,

        -- Set terminal colors used in `:terminal`
        terminal_colors = true,

        variant = "default", -- use "light" for the light variant

        colors = palette,
      })
    end,
  },
}
