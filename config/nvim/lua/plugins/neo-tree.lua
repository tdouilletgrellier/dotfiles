return{

      {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
      })
    end,
  },
  
}