vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.f", "*.f90", "*.f77", "*.F", "*.F90", "*.F77" },
  callback = function()
    vim.bo.filetype = "fortran"
  end,
})
