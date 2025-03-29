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

" functions to handle org
let org_directory = expand("~/.dotfiles/org.d")
" open org.md
function! OrgOpen()
    let org_file = g:org_directory . "/" . "org.md"
    call timer_start(10, { -> execute('edit ' . fnameescape(org_file))})
endfunction
" pull org repository
function! OrgPush()
    let current_datetime = strftime("%Y/%m/%d/%H:%M")
    execute "!git -C " . g:org_directory . " add ."
    execute "!git -C " . g:org_directory . " commit -m \'Commit at " . current_datetime . " from OrgPush\'"
    execute "!git -C " . g:org_directory . " push"
endfunction
function! OrgPull()
    execute "!git -C " . g:org_directory . " pull"
endfunction


"" indent settings
set expandtab
set shiftwidth=4
set autoindent
set smarttab
filetype indent off
filetype plugin indent off
set fenc=utf-8
set hidden
set shell=zsh
set wildmode=list,full
set mouse=
set timeoutlen=300
"" terminal settings
"if has('nvim')
"  autocmd TermOpen * startinsert
"endif

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
inoremap <silent> <expr> <BS> BracketBackspace()
inoremap <silent> <expr> <CR> IndentBraces()
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
nnoremap <leader>src :source ~/.dotfiles/nvim/init.vim<CR>
"nnoremap <leader>b :b 
nnoremap <C-k> :bprev<CR>
nnoremap <C-j> :bnext<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>G :GFiles?<CR>
nnoremap <leader>b :Buffers<CR>
"" remaps to handle org
nnoremap <expr> <leader>o OrgOpen()
nnoremap <expr> <leader>oo OrgOpen()
nnoremap <expr> <leader>os OrgPush()
nnoremap <expr> <leader>op OrgPull()
"" other remaps
nmap <silent> <ESC><ESC> :nohlsearch<CR><ESC>

" representations
set cursorline
set guicursor=n-v-c-i:block
set number
set showcmd
set listchars=tab:>-,trail:-
set list
set completeopt=menu,preview
set hlsearch
set incsearch
"" terminal representation
if has('nvim')
  autocmd TermOpen * setlocal nonumber
  autocmd TermOpen * setlocal norelativenumber
endif
"" coloring
let mysyntaxfile = "~/.vim/syntax/syntax.vim"
syntax on
syntax enable
set background=dark
if has('nvim')
    colorscheme nightfox
else
    colorscheme iceberg
endif
"" overwrite coloring
if has('nvim')
    hi Normal ctermbg=None guibg=None
    hi NormalNC ctermbg=None guibg=None
else
    hi Normal ctermbg=None
    hi NormalNC ctermbg=None
endif
hi NonText ctermfg=red ctermbg=green guifg=#ff0000 guibg=#00ff00
hi Whitespace ctermfg=red ctermbg=green guifg=#ff0000 guibg=#00ff00
hi SpecialKey ctermfg=red ctermbg=green guifg=#ff0000 guibg=#00ff00

let g:nvim_prefix = "~/.config/nvim/"
if !filereadable(expand("~/.config/nvim/local.vim"))
    silent! execute "call system('touch ~/.config/nvim/local.vim')"
endif
execute "source " . g:nvim_prefix . "local.vim"
