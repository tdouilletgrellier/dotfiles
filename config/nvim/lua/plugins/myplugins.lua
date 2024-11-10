return {

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
    },
    config = function()
      local telescope = require("telescope")

      -- first setup telescope
      telescope.setup({
        -- your config
      })

      -- then load the extension
      telescope.load_extension("live_grep_args")
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
      })
    end,
  },

  {
    "nvim-zh/colorful-winsep.nvim",
    event = { "WinLeave" },
    config = function()
      require("colorful-winsep").setup({
        -- highlight for Window separator
        hi = {
          -- bg = "#16161E",
          fg = "#e7bf00",
        },
        -- This plugin will not be activated for filetype in the following table.
        no_exec_files = { "neo-tree", "packer", "TelescopePrompt", "mason", "CompetiTest", "NvimTree" },
        -- Symbols for separator lines, the order: horizontal, vertical, top left, top right, bottom left, bottom right.
        symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
        -- #70: https://github.com/nvim-zh/colorful-winsep.nvim/discussions/70
        only_line_seq = true,
        -- Smooth moving switch
        smooth = true,
        exponential_smoothing = true,
        anchor = {
          left = { height = 1, x = -1, y = -1 },
          right = { height = 1, x = -1, y = 0 },
          up = { width = 0, x = -1, y = 0 },
          bottom = { width = 0, x = 1, y = 0 },
        },
        light_pollution = function(lines) end,
      })
    end,
  },

  {
    "nvimdev/dashboard-nvim",
    lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
    opts = function()
      local logo = {
        [[=================     ===============     ===============   ========  ========]],
        [[\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //]],
        [[||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||]],
        [[|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||]],
        [[||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||]],
        [[|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||]],
        [[||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||]],
        [[|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||]],
        [[||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||]],
        [[||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||]],
        [[||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||]],
        [[||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||]],
        [[||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||]],
        [[||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||]],
        [[||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||]],
        [[||.=='    _-'                                                     `' |  /==.||]],
        [[=='    _-'                        N E O V I M                         \/   `==]],
        [[\   _-'                                                                `-_   /]],
        [[ `''                                                                      ``' ]],
      }

      -- logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = logo, --vim.split(logo, "\n"),
          -- stylua: ignore
          center = {
            { action = 'lua LazyVim.pick()()',                           desc = " Find File",       icon = " ", key = "f" },
            { action = "ene | startinsert",                              desc = " New File",        icon = " ", key = "n" },
            { action = 'lua LazyVim.pick("oldfiles")()',                 desc = " Recent Files",    icon = " ", key = "r" },
            { action = 'lua LazyVim.pick("live_grep")()',                desc = " Find Text",       icon = " ", key = "g" },
            { action = 'lua LazyVim.pick.config_files()()',              desc = " Config",          icon = " ", key = "c" },
            { action = 'lua require("persistence").load()',              desc = " Restore Session", icon = " ", key = "s" },
            { action = "LazyExtras",                                     desc = " Lazy Extras",     icon = " ", key = "x" },
            { action = "Lazy",                                           desc = " Lazy",            icon = "󰒲 ", key = "l" },
            { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit",            icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- open dashboard after closing lazy
      if vim.o.filetype == "lazy" then
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function()
              vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
            end)
          end,
        })
      end

      return opts
    end,
  },

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
    "hrsh7th/nvim-cmp",
    init = function()
      vim.g.cmp_disabled = true
    end,
    opts = function(_, opts)
      opts.enabled = function()
        -- local context = require("cmp.config.context")
        if vim.g.cmp_disabled == true then
          return false
        end
        -- some other conditions (like not in commments) can go here
        return not disabled
      end
    end,
    keys = {
      {
        "<leader>ua",
        function()
          vim.g.cmp_disabled = not vim.g.cmp_disabled
          local msg = ""
          if vim.g.cmp_disabled == true then
            msg = "Autocompletion (cmp) disabled"
          else
            msg = "Autocompletion (cmp) enabled"
          end
          vim.notify(msg, vim.log.levels.INFO)
        end,
        noremap = true,
        silent = true,
        desc = "toggle autocompletion",
      },
    },
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
     "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    lazy = false,
    keys = {
      { "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"' },
      { "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"' }
    },    
    opts = {}
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
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_general_viewer = "okular"
      vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"

      -- Turn off VimTeX indentation
      vim.g.vimtex_indent_enabled = 0

      -- Disable default mappings; I'll define my own
      vim.g.vimtex_mappings_enabled = 0

      -- Disable insert mode mappings (in favor of a dedicated snippet engine)
      vim.g.vimtex_imaps_enabled = 0

      -- Disable completion
      -- vim.g.vimtex_complete_enabled = 0

      -- Disable syntax conceal
      vim.g.vimtex_syntax_conceal_disable = 1

      -- Default is 500 lines and gave me lags on missed key presses
      vim.g.vimtex_delim_stopline = 50

      -- VimTeX toggle delimeter configuration
      -- vim.g.vimtex_delim_toggle_mod_list = { ['\left', '\right'] , ['\big', '\big'], }

      -- Don't open quickfix for warning messages if no errors are present
      vim.g.vimtex_quickfix_open_on_warning = 0

      -- Disable some compilation warning messages
      vim.g.vimtex_quickfix_ignore_filters = {
        "LaTeX hooks Warning",
        "Underfull \\hbox",
        "Overfull \\hbox",
        -- 'LaTeX Warning: .\+ float specifier changed to',
        'Package siunitx Warning: Detected the "physics-- package:',
        "Package hyperref Warning: Token not allowed in a PDF string",
        "Fatal error occurred, no output PDF file produced!",
      }

      -- if g:os_current == "Linux"
      vim.g.vimtex_view_method = "zathura"
      -- elseif g:os_current == "Darwin"
      --   vim.g.vimtex_view_method = 'skim'
      -- else
      --   echom "Error: LaTeX forward show not supported on this OS"
      -- endif

      -- Don't automatically open PDF viewer after first compilation
      vim.g.vimtex_view_automatic = 0

      -- Disable continuous compilation
      --vim.g.vimtex_compiler_latexmk = {
      --     'build_dir' = '',
      --     'callback' = 1,
      --     'continuous' = 0,
      --     'executable' = 'latexmk',
      --     'hooks' = [],
      --     'options' = [
      --       '-verbose',
      --       '-file-line-error',
      --       '-synctex=1',
      --       '-interaction=nonstopmode',
      --     ],
      --    }
    end,
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
