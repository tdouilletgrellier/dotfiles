return{

  {
    "mcauley-penney/visual-whitespace.nvim",
    event = "ModeChanged",
    opts = {
      highlight = { link = "Visual" },
      space_char = "·",
      tab_char = "→",
      nl_char = "↲",
      cr_char = "←",
      enabled = true,
    },
    vim.keymap.set("n", "<leader>uw", function()
      vim.cmd("VisualWhitespaceToggle")
    end, { desc = "Toggle Visual Whitespace" }),
  },
    
}