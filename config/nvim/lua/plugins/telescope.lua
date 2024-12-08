return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-live-grep-args.nvim", -- For advanced search functionality
      "nvim-telescope/telescope-fzf-native.nvim",     -- For faster fuzzy searching
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      -- Setup telescope with keymaps and extensions
      telescope.setup({
        defaults = {
          prompt_prefix = "🔍 ",
          selection_caret = " ",
          mappings = {
            i = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
            },
            n = {
              ["q"] = actions.close, -- Close on 'q' key in normal mode
            },
          },
          sorting_strategy = "ascending", -- Use ascending sorting for results
          layout_strategy = "horizontal", -- Horizontal layout for results
        },
        extensions = {
          live_grep_args = {
            auto_quoting = true, -- Automatically add quotes for search args
          },
        },
      })

      -- Load Telescope extensions
      telescope.load_extension("live_grep_args")
      telescope.load_extension("fzf")
    end,
  },
}
