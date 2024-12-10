return {
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline", -- Keep the command-line at the bottom
      },
      presets = {
        bottom_search = true,
        command_palette = false, -- Disable Noice command palette autocompletion
        long_message_to_split = true,
      },
      messages = {
        enabled = true,
        view = "mini", -- Minimal message style
        view_error = "mini",
        view_warn = "mini",
        view_info = "mini",
        view_history = "split",
      },
      notify = {
        enabled = true, -- Enable Noice notifications
        view = "mini", -- Notifications will look minimal and classic
        timeout = 5000, -- Set a long enough timeout (5000ms = 5s)
      },
    },
    config = function(_, opts)
      require("noice").setup(opts)
    end,
  },
}
