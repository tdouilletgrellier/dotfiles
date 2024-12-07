return{

  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        -- Enable transparent background
        transparent = true,

        -- Enable italics comments
        italic_comments = true,

        -- Replace all fillchars with ' ' for the ultimate clean look
        hide_fillchars = true,

        -- Modern borderless telescope theme
        borderless_telescope = false,

        -- Set terminal colors used in `:terminal`
        terminal_colors = true,

        theme = {
          variant = "default", -- use "light" for the light variant
          highlights = {
            -- Highlight groups to override, adding new groups is also possible
            -- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values

            -- Example:
            -- Comment = { fg = "#696969", bg = "NONE", italic = true },

            -- Complete list can be found in `lua/cyberdream/theme.lua`
          },

          -- Override a color entirely
          colors = {
            -- Palette 1
            -- bg = "#000000",
            -- fg = "#ffffff",
            -- magenta = "#cd00cd",
            -- blue = "#1c71d8",
            -- grey = "#838b8b",
            -- orange = "#ff4f00",
            -- cyan = "#00cdcd",
            -- yellow = "#cdcd00",
            -- purple = "#bf00ff",
            -- pink = "#fd6c9e",
            -- red = "#cd0000",
            -- bgAlt = "#1e2124",
            -- bgHighlight = "#3c4048",
            -- green = "#00cd00",
            -- -- bg = "#16181a",

            -- Palette 2
            -- bg = "#000000",
            -- bgAlt = "#1e2124",
            -- bgHighlight = "#3c4048",
            -- fg = "#ffffff",
            -- grey = "#7b8496",
            -- blue = "#5ea1ff",
            -- green = "#5eff6c",
            -- cyan = "#5ef1ff",
            -- red = "#ff6e5e",
            -- yellow = "#f1ff5e",
            -- magenta = "#ff5ef1",
            -- pink = "#ff5ea0",
            -- orange = "#ffbd5e",
            -- purple = "#bd5eff",

            -- Palette 3 (Terminal)
            bg = "#000000",
            bgAlt = "#2a2a2a",
            -- red2 = "#ff0000",
            green = "#79ff0f",
            yellow = "#e7bf00",
            blue = "#386bd7",
            -- purple2 = "#b349be",
            -- blue2 = "#66ccff",
            grey = "#bbbbbb",
            bgHighlight = "#666666",
            red = "#cd0000",
            -- green2 = "#66ff66",
            orange = "#ff8700",
            -- blue3 = "#709aed",
            purple = "#db67e6",
            cyan = "#79dff2",
            fg = "#ffffff",
            -- from Palette 2
            magenta = "#ff5ef1",
            pink = "#ff5ea0",

            -- Palette 4
            -- bg = "#ffffff",
            -- bgAlt = "#eaeaea",
            -- bgHighlight = "#acacac",
            -- fg = "#16181a",
            -- grey = "#7b8496",
            -- blue = "#0057d1",
            -- green = "#008b0c",
            -- cyan = "#008c99",
            -- red = "#d11500",
            -- yellow = "#997b00",
            -- magenta = "#d100bf",
            -- pink = "#f40064",
            -- orange = "#d17c00",
            -- purple = "#a018ff",

            -- Palette 5 (Neon)
            -- bg =  "#000000",
            -- fg = "#FFFFFF",
            -- red =  "#FF0105",
            -- orange = "#FF6001",
            -- yellow = "#E0FF01",
            -- green =  "#06FF05",
            -- cyan =  "#01FFFD",
            -- blue =  "#0042FF",
            -- purple = "#7D1AE6",
            -- pink =  "#FF01C3",
            -- magenta =  "#FF026A",
            -- grey =  "#B0B0B0",
            -- bgAlt =  "#353576",
            -- -- From Palette 1
            -- bgHighlight =  "#1e2124",
          },
        },
      })
    end,
  },

}