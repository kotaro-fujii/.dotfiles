" basic setting
"set t_Co=256
" display view
set cursorline
set guicursor=n-v-c-i:block
set number
set showcmd
set listchars=tab:>-,trail:-
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
" listchars representations
hi NonText ctermfg=red ctermbg=green guifg=#ff0000 guibg=#00ff00
hi Whitespace ctermfg=red ctermbg=green guifg=#ff0000 guibg=#00ff00
hi SpecialKey ctermfg=red ctermbg=green guifg=#ff0000 guibg=#00ff00
