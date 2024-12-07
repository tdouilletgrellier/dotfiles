" lua/ftdetect/fortran.vim

augroup filetypedetect
  autocmd!
  autocmd BufRead,BufNewFile *.f,*.f77,*.f90,*.F,*.F77,*.F90 setfiletype fortran
augroup END
