return {

  {
    "mcauley-penney/visual-whitespace.nvim",
    event = "ModeChanged",
    opts = {
      highlight = { link = "Visual" },
      space_char = "·",
      tab_char = "→",
      nl_char = "↲",
    },
  },

  {
    "RRethy/vim-illuminate",
    event = "CursorHold",
    config = function()
      require("illuminate").configure({
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        under_cursor = false,
      })
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },

  {
    "hiphish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  {
    "tzachar/highlight-undo.nvim",
    event = "BufReadPost",
    opts = {},
  },

  {
    "Fildo7525/pretty_hover",
    opts = {},
  },

  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      filetypes = {
        "*",
        cmp_docs = { always_update = true },
        cmp_menu = { always_update = true },
      },
      user_default_options = {
        names = false,
        RRGGBBAA = true,
        rgb_fn = true,
        tailwind = true,
        RGB = true,
        RRGGBB = true,
        AARRGGBB = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        sass = { enable = true, parsers = { "css" } },
        mode = "background", -- Available methods are false / true / "normal" / "lsp" / "both"
        virtualtext = "■",
        always_update = true,
      },
    },
  },
  {
    "NStefan002/visual-surround.nvim",
    event = "BufEnter",
    opts = true,
  },

  {
    "m-demare/hlargs.nvim",
    event = "BufWinEnter",
    config = function()
      require("hlargs").setup({
        hl_priority = 200,
      })
    end,
  },

  {
    "cbochs/portal.nvim",
    keys = { "<leader>pj", "<leader>ph" },
  },

  --[[  {
    "gbprod/cutlass.nvim",
    event = "BufReadPost",
    opts = {
      cut_key = "x",
      override_del = true,
      exclude = {},
      registers = {
        select = "_",
        delete = "_",
        change = "_",
      },
    },
  },]]

  {
    "jubnzv/virtual-types.nvim",
    event = "LspAttach",
  },

  {
    "sheerun/vim-polyglot",
  },

  {
    "ThePrimeagen/harpoon",
  },

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
        borderless_telescope = true,

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
            orange = "#f3d64e",
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
