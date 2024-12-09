return {
  {
    "m-demare/hlargs.nvim",
    event = "BufWinEnter",
    opts = {
      hl_priority = 200,
      extras = { named_parameters = true }, -- Remove if unsupported
    },
    config = function(_, opts)
      -- Load custom color palette
      local palette = require("colors.palette_custom")

      -- Setup hlargs with valid options
      require("hlargs").setup(opts)

      -- Define custom highlights using the custom color palette
      vim.api.nvim_set_hl(0, "Hlargs", { fg = palette.green, bg = palette.bgAlt, bold = true }) -- Green with bgAlt
      vim.api.nvim_set_hl(0, "HlargsNamedParameter", { fg = palette.orange, bg = palette.bg }) -- Orange for named parameters
      vim.api.nvim_set_hl(0, "HlargsParameter", { fg = palette.fg, bg = palette.bg }) -- White for generic parameters
    end,
  },
}
