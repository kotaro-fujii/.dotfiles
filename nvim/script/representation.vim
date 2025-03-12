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
if has('nvim')
  autocmd TermOpen * setlocal nonumber
  autocmd TermOpen * setlocal norelativenumber
endif
" coloring
let mysyntaxfile = "~/.vim/syntax/syntax.vim"
syntax on
syntax enable
set background=dark
" listchars representations
hi NonText ctermfg=red ctermbg=NONE guifg=#ffffff guibg=#000000
hi Whitespace ctermfg=red ctermbg=NONE guifg=#ffffff guibg=#000000
hi SpecialKey ctermfg=red ctermbg=NONE guifg=#ffffff guibg=#000000
" background
if has('nvim')
    colorscheme nightfox
    hi Normal ctermbg=None guibg=None
    hi NormalNC ctermbg=None guibg=None
else
    " colorscheme iceberg
    hi Normal ctermbg=None
    hi NormalNC ctermbg=None
endif
