return {
  {
    "m-demare/hlargs.nvim",
    event = "BufWinEnter",
    opts = {
      hl_priority = 200,
      extras = { named_parameters = true }, -- Remove if unsupported
    },
    config = function(_, opts)
      -- Setup hlargs with valid options
      require("hlargs").setup(opts)

      -- Define custom highlights using Neovim's highlight API
      vim.api.nvim_set_hl(0, "Hlargs", { fg = "#79ff0f", bg = "#2a2a2a", bold = true })        -- Green with bgAlt
      vim.api.nvim_set_hl(0, "HlargsNamedParameter", { fg = "#ff8700", bg = "#000000" })       -- Orange for named parameters
      vim.api.nvim_set_hl(0, "HlargsParameter", { fg = "#ffffff", bg = "#000000" })            -- White for generic parameters
    end,
  },
}
