" after/syntax/fortran.vim

" Fixed form Fortran comments
autocmd FileType fortran setlocal commentstring=C\ %s

" Modern form Fortran comments
autocmd FileType fortran setlocal commentstring=! %s
