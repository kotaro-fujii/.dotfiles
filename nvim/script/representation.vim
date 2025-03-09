" basic setting
"set t_Co=256
" display view
set cursorline
set guicursor=n-v-c-i:block
set number
set showcmd
set listchars=tab:>-,trail:_
set list
set completeopt=menu,preview
" search representation
set hlsearch
set incsearch
" terminal representation
autocmd TermOpen * setlocal nonumber
autocmd TermOpen * setlocal norelativenumber
" coloring
let mysyntaxfile = "~/.vim/syntax/syntax.vim"
syntax on
syntax enable
set background=dark
" colorscheme iceberg
colorscheme nightfox
hi NonText ctermfg=red ctermbg=NONE guifg=#ffffff guibg=#000000
hi Whitespace ctermfg=red ctermbg=NONE guifg=#ffffff guibg=#000000
hi SpecialKey ctermfg=red ctermbg=NONE guifg=#ffffff guibg=#000000
