return{

  {
    "roobert/search-replace.nvim",
    config = function()
      require("search-replace").setup({
        default_replace_single_buffer_options = "g",
      })

      vim.keymap.set("n", "zh", "<cmd>SearchReplaceSingleBufferCWord<cr>")

      vim.o.inccommand = "split" -- or nosplit
      vim.keymap.set("v", "zh", "<cmd>SearchReplaceSingleBufferVisualSelection<cr>")
    end,
  },
    
}