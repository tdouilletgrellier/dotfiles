local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}
local palette = require("colors.palette_custom")
local hooks = require("ibl.hooks")
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = palette.red })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = palette.yellow })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = palette.blue })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = palette.orange })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = palette.green })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = palette.purple })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = palette.cyan })
end)

vim.g.rainbow_delimiters = { highlight = highlight }
require("ibl").setup({ scope = { highlight = highlight } })

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
