set fenc=utf-8

set shell=zsh

set expandtab
set shiftwidth=4
set autoindent
set smarttab
filetype indent off
filetype plugin indent off

set mouse=

if has('nvim')
  autocmd TermOpen * startinsert
endif

set hidden
