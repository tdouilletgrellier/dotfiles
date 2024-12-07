local hooks = require("ibl.hooks")

-- Custom highlights
local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#cd0000" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#e7bf00" })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#386bd7" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#ff8700" })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#79ff0f" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#db67e6" })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#79dff2" })
end)

require("ibl").setup({
  scope = { highlight = highlight },
})
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
