" character settings
set fenc=utf-8
set expandtab
set shiftwidth=4
set autoindent
set smarttab
" operation settings
filetype indent off
filetype plugin indent off
set mouse=
" term settings
set shell=zsh
if has('nvim')
  autocmd TermOpen * startinsert
endif
" buffer settings
set hidden

set wildmode=list,full
