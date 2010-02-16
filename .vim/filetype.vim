" Vim should let me say use C syntax on all .h files by simply setting
" c_syntax_for_h, but that doesn't actually seem to work. Force it. Note that
" means .h files for Objective C and C++ will also use the C file type.
autocmd BufNewFile,BufRead *.h setf c

" .go files are probably Go language source
autocmd BufNewFile,BufRead *.go setf go
