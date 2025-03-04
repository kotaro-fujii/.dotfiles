" basic setting
set t_Co=256

" display view
set cursorline
set guicursor=n-v-c-i:block
set number
set showcmd
set listchars=tab:>-,trail:_
set list

set hlsearch
set incsearch

set completeopt=menu,preview

set number
autocmd TermOpen * setlocal nonumber
autocmd TermOpen * setlocal norelativenumber

" coloring
let mysyntaxfile = "~/.vim/syntax/syntax.vim"
syntax on

syntax enable

set background=dark
colorscheme iceberg
colorscheme iceberg_addition
highlight Normal ctermbg=none
highlight NonText ctermbg=none
highlight LineNr ctermbg=none
highlight EndOfBuffer ctermbg=none
