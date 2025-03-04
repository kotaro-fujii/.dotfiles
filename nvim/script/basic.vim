set fenc=utf-8

set shell=zsh

set expandtab
set shiftwidth=4
set autoindent
set smarttab
filetype indent off
filetype plugin indent off

set mouse=

autocmd TermOpen * startinsert
" autocmd BufEnter * if &buftype == 'terminal' | startinsert | endif

set hidden
