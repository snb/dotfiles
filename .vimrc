" My vimrc file, configuration file for vim. Originally based on
" http://www.vim.org/vimrc.forall

" Vim has had a lot of security problems with modelines, so let's just disable
" them
set nomodeline

" 2 allows backspacing over indentation, end-of-line, and start-of-line.
set backspace=2

" Usually using a black background.
set background=dark
highlight Normal guibg=Black guifg=White

" I hate beeping.
set noerrorbells
set visualbell
set t_vb=

" Text Width at standard 80 characters.
set textwidth=80

" I usually like four spaces for tab, and spaces when automatically indenting.
" Leave tabstop unset though, so existing tabs will be 8 spaces wide
"set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

" Most of the time I also like auto indentation. smartindent is kind of stupid
" though.
set autoindent
"set smartindent

" Show matching bracket when a bracket statement is closed.
set showmatch

" This avoids breaking screen by not allowing ^Z to actually suspend vim.
map <C-Z> :shell

" Syntax colouring makes vim pretty like a pony!
if has("syntax")
    syntax on
endif

" Use the mouse.
"set mouse=a

" Put the name of the file we're editing in the terminal title. Disabled because
" status line is probably good enough.
"autocmd BufEnter * let &titlestring = hostname() . " [editing " . expand("%:t") . "]"
"set title

" Put file name and type on status line. To the right, line number/total lines,
" column number. Always display status line, too.
set statusline=%f\ %y\ %=%l/%L,%v
set laststatus=2

" Turn on spell checking, with Oxford English Dictionary spelling
set spell spelllang=en_gb_oed

" Make trailing whitespace and space before tabs ugly
autocmd BufEnter * match Todo /\s\+$\| \+\ze\t/

" Highlight search terms and show the first match for a pattern as I type
set hlsearch
set incsearch

""" File type stuff
" Look in .vim/indent/<ft>.vim for file type specific plugins for indentation
filetype indent on

" Set shiftwidth to 3 if editing some FORTRASH (to deal with the 7 column thing)
autocmd FileType fortran setlocal shiftwidth=3

" Don't want to expand tabs for Makefiles.
autocmd FileType make setlocal noexpandtab
autocmd FileType make setlocal shiftwidth=8
autocmd FileType make setlocal tabstop=8

" Wrap text at 72 characters for svn and git commits
autocmd FileType gitcommit setlocal textwidth=72
autocmd FileType svn setlocal textwidth=72

" C code by default formatted according to style(9)
autocmd FileType c call FreeBSD_Style()

" In addition the python.vim indent plugin I downloaded, PEP-8 says max line
" length should be 79 characters
autocmd FileType python setlocal textwidth=79

" If it's something that isn't code, I don't want smartindent. This is mostly so
" when I do gqap to reformat a paragraph it doesn't indent everything if a line
" starts with for or if, which is annoying in TeX files (and plain text, but
" those files don't have a FileType so I don't know what to do...)
autocmd FileType plaintex setlocal nosmartindent
