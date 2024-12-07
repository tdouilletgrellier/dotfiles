return{

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = function()
      require("ibl").setup({
        exclude = { filetypes = { "dashboard" } },
        indent = { char = "▏" },
        whitespace = { highlight = { "Whitespace" } },
        scope = { enabled = false },
      })
    end,
  },

}