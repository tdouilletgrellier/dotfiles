return {
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      -- Enable for specific filetypes; "*" enables it globally
      filetypes = { "*", "cmp_docs", "cmp_menu" },

      user_default_options = {
        RGB = true,          -- Highlight RGB color values (#RRGGBB)
        RRGGBB = true,       -- Same as above
        RRGGBBAA = true,     -- Highlight #RRGGBBAA
        AARRGGBB = true,     -- Highlight #AARRGGBB
        names = false,       -- Disable color names like "red" or "blue"
        rgb_fn = true,       -- Enable rgb(255, 255, 255) function highlighting
        hsl_fn = true,       -- Enable hsl() function highlighting
        css = true,          -- Enable highlighting in CSS files
        css_fn = true,       -- Enable CSS functions like `rgba()`, `hsla()`
        tailwind = true,     -- Support Tailwind CSS colors
        sass = {             -- Enable SASS highlighting
          enable = true,
          parsers = { "css" },
        },
        mode = "background", -- Use background to display colors
        virtualtext = "■",   -- Use "■" for virtual text indicator
        always_update = true, -- Ensure the highlights are updated in real-time
      },
    },
  },
}
