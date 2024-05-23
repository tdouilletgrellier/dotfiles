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
      require("illuminate").configure {
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        under_cursor = false,
      }
    end,
  },

  {
    "hiphish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    config = function()
      local rainbow_delimiters = require "rainbow-delimiters"

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
}

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
      require("hlargs").setup {
        hl_priority = 200,
      }
    end,
  },

  {
    "cbochs/portal.nvim",
    keys = { "<leader>pj", "<leader>ph" },
  },

  {
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
  },      

  {
    "jubnzv/virtual-types.nvim",
    event = "LspAttach",
  },
  
  {
    "ray-x/aurora"
  },

}
