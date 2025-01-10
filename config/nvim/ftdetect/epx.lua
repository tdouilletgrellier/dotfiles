vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.epx" },
  callback = function()
    vim.bo.filetype = "epx"
  end,
})
