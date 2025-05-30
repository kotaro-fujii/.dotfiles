" plugin setting
" dein.vim settings {{{
" install dir {{{
"let s:dein_dir = expand('~/.cache/dein')
let s:dein_dir = expand('~/.config/nvim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" }}}
" dein installation check {{{
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif
" }}}
" begin settings {{{
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  " .toml file
  let s:rc_dir = expand('~/.config/nvim')
  if !isdirectory(s:rc_dir)
    call mkdir(s:rc_dir, 'p')
  endif
  let s:toml = s:rc_dir . '/dein.toml'
  " read toml and cache
  call dein#load_toml(s:toml, {'lazy': 0})
  " end settings
  call dein#end()
  call dein#save_state()
endif
" }}}
" plugin installation check {{{
if dein#check_install()
  call dein#install()
endif
" }}}
" plugin remove check {{{
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif
" }}}
set rtp+=$HOME/.dotfiles/fzf

" functions about bracket operation
let open_brackets = ["(", "{", "[", "\"", "\'"]
let close_brackets = [")", "}", "]", "\"", "\'"]

" judge that given two characters is pair bracket
function! IsPair(beforeletter, nowletter)
  if index(g:open_brackets, a:beforeletter) == -1
    return 0
  elseif index(g:open_brackets, a:beforeletter) == index(g:close_brackets, a:nowletter)
    return 1
  else
    return 0
endfunction

" find pair bracket from same line
function! CloseBracketColumn(beforeletter)
  let line_tail = strpart(getline('.'), col('.') - 1)
  let close_bracket = g:close_brackets[index(g:open_brackets, a:beforeletter)]
  let nested = 0
  let colcount = 0
  for c in line_tail
    if c == a:beforeletter
      let nested = nested + 1
    elseif IsPair(a:beforeletter, c)
      if nested == 0
        return colcount
      else
        let nested = nested - 1
      endif
    endif
    let colcount = colcount + 1
  endfor
  return -1
endfunction

" format string when start new line
function! IndentBraces()
  let beforeletter = getline(".")[col(".") - 2]
  let nowletter = getline(".")[col(".") - 1]
  if beforeletter == ':'
    return "\n\t"
  elseif IsPair(beforeletter, nowletter) " (), focus on ')'
    return "\n\t\n\<BS>\<UP>\<END>"
  elseif index(g:open_brackets, beforeletter) != -1 " (hello, focus on h
    let close_bracket_colunm = CloseBracketColumn(beforeletter)
    if close_bracket_colunm == -1
      return "\n\t"
    else
      return "\n\t" . repeat("\<RIGHT>", close_bracket_colunm) . "\n\<BS>\<UP>\<ESC>I"
    endif
  elseif index(g:close_brackets, nowletter) != -1 " (hello world), focus on )
    return "\n\<ESC>O\t"
  else
    return "\n"
  endif
endfunction

" delete pair close bracket when remove open bracket
function! BracketBackspace()
  let beforeletter = getline(".")[col(".") - 2]
  let nowletter = getline(".")[col(".") - 1]
  if IsPair(beforeletter, nowletter)
      return "\<RIGHT>\<BS>\<BS>"
  else
      return "\<BS>"
  endif
endfunction


"" indent settings
set expandtab
set autoindent
set smarttab
filetype indent off
filetype plugin indent off
set fenc=utf-8
set hidden
set shell=zsh
set wildmode=list,full
set mouse=
set timeoutlen=500
set clipboard+=unnamedplus

" remap
"" brackets
inoremap { {}<LEFT>
inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap ' ''<LEFT>
inoremap " ""<LEFT>
inoremap '' '
inoremap "" "
inoremap """ """"""<LEFT><LEFT><LEFT>
inoremap <> <><LEFT>
"" remaps to escape
inoremap <silent> kj <ESC>
inoremap <silent> jk <ESC>
vnoremap <silent> vv <ESC>
cnoremap <silent> kj <C-u><ESC>
cnoremap <silent> jk <C-u><ESC>
tnoremap <silent> kj <c-\><c-n>
tnoremap <silent> jk <c-\><c-n>
tnoremap <silent> <ESC> <c-\><c-n>
"" motion remaps
noremap L $
noremap H ^
"" buffer and window operations
let mapleader = "\<Space>"
nnoremap <leader>h :split<CR>
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>t :terminal<CR>
nnoremap <leader>d :bdelete<CR>
nnoremap <leader>e :e 
nnoremap <leader>l :ls<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>src :source ~/.dotfiles/nvim/init.vim<CR>
nnoremap <C-k> :bprev<CR>
nnoremap <C-j> :bnext<CR>
nnoremap <C-l> <C-w>w
nnoremap <C-h> <C-w>W
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>G :GFiles?<CR>
nnoremap <leader>b :Buffers<CR>
"" other remaps
nmap <silent> <ESC><ESC> :nohlsearch<CR><ESC>
nnoremap U <C-r>
nnoremap <leader>r :reg<CR>

" representations
"set cursorline
set guicursor=n-v-c-i:block
set number
set showcmd
set listchars=tab:>-,trail:-
set list
set completeopt=menu,preview
set hlsearch
set incsearch

"" folding
autocmd BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
autocmd BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent! loadview | endif
set viewoptions-=options

"" terminal representation
if has('nvim')
  autocmd TermOpen * setlocal nonumber
  autocmd TermOpen * setlocal norelativenumber
endif

"" coloring
function ChangeColorInsertEnter()
  set nocursorline
endfunction
function ChangeColorInsertLeave()
  set cursorline
endfunction
set cursorline
autocmd InsertEnter * call ChangeColorInsertEnter()
autocmd InsertLeave * call ChangeColorInsertLeave()

" overwrite coloring
function OverWriteColor()
  let l:listchars_guifg = synIDattr(synIDtrans(hlID('WarningMsg')), 'fg', 'gui')
  let l:listchars_guibg = synIDattr(synIDtrans(hlID('Title')),      'fg', 'gui')
  execute 'hi NonText    guifg='. l:listchars_guifg . ' guibg=' . l:listchars_guibg
  execute 'hi Whitespace guifg='. l:listchars_guifg . ' guibg=' . l:listchars_guibg
  execute 'hi SpecialKey guifg='. l:listchars_guifg . ' guibg=' . l:listchars_guibg
  if has('nvim')
    hi Normal ctermbg=None guibg=None
    hi NormalNC ctermbg=None guibg=None
  else
    hi Normal ctermbg=None
    hi NormalNC ctermbg=None
  endif
endfunction
autocmd ColorScheme * call OverWriteColor()

" color scheme settings
let mysyntaxfile = "~/.vim/syntax/syntax.vim"
syntax on
syntax enable
set background=dark
if has('nvim')
  colorscheme nightfox
else
  colorscheme iceberg
endif

"" change remap in reference to buffertype
function LispRemap()
  setlocal lisp
endfunction
function OtherRemap()
  inoremap <buffer> <silent> <expr> <BS> BracketBackspace()
  inoremap <buffer> <silent> <expr> <CR> IndentBraces()
endfunction
autocmd BufNewFile,BufReadPost *.lisp call LispRemap()
autocmd BufNewFile,BufReadPost * if expand('%:e') !=# 'lisp' | call OtherRemap()

"" indent settings
function IndentWidthSet()
  let indent_width_2_file_formats = ['md', 'markdown', 'vim', 'tex', 'plaintex', 'sh', 'bash', 'zsh']
  if index(indent_width_2_file_formats, &filetype) >=0
    setlocal shiftwidth=2
  else
    setlocal shiftwidth=4
  endif
endfunction
autocmd BufNewFile,BufReadPost * call IndentWidthSet()

"" load local settings
let g:nvim_prefix = "~/.config/nvim/"
if !filereadable(expand("~/.config/nvim/local.vim"))
  silent! execute "call system('touch ~/.config/nvim/local.vim')"
endif
execute "source " . g:nvim_prefix . "local.vim"
