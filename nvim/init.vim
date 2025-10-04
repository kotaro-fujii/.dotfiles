" ========== plugin setup: dein.vim  ==========
if has('nvim')
  " dein.vim を置くディレクトリ設定
  let s:dein_dir = expand('~/.config/nvim/dein')
  let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

  " dein.vim が無ければ clone して導入
  if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
      execute '!git clone https://github.com/Shougo/dein.vim ' . s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . s:dein_repo_dir
  endif

  " dein の初期化とプラグイン読み込み
  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    " プラグイン定義ファイル dein.toml
    let s:rc_dir = expand('~/.config/nvim')
    if !isdirectory(s:rc_dir)
      call mkdir(s:rc_dir, 'p')
    endif
    let s:toml = s:rc_dir . '/dein.toml'
    call dein#load_toml(s:toml, {'lazy': 0})

    call dein#end()
    call dein#save_state()
  endif

  " 未インストールプラグインがあればインストール
  if dein#check_install()
    call dein#install()
  endif

  " 削除されたプラグインをクリーンアップ
  let s:removed_plugins = dein#check_clean()
  if len(s:removed_plugins) > 0
    call map(s:removed_plugins, "delete(v:val, 'rf')")
    call dein#recache_runtimepath()
  endif

  " fzf を runtimepath に追加
  set rtp+=$HOME/.dotfiles/fzf

" ========== plugin setup: vim-plug  ==========
else
  " vim-plugが無ければautoloadにダウンロード
  let s:vimplug_file = expand('~/.vim/autoload/plug.vim')
  if !filereadable(s:vimplug_file)
    execute '!curl -fLo ' . s:vimplug_file . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  endif

  " vim-plugのpluginファイルをsource
  let s:vimplug_plugins = expand('~/.vim/vimplug_plugins.vim')
  if !filereadable(s:vimplug_plugins)
    execute '!touch ' . s:vimplug_plugins
  endif
  call plug#begin()
  execute "source " . s:vimplug_plugins
  call plug#end()

  set rtp+=$HOME/.dotfiles/fzf
endif


" ========== functions ==========
" 開きカッコと閉じカッコの対応表
let g:open_brackets = ["(", "{", "[", "\"", "\'"]
let g:close_brackets = [")", "}", "]", "\"", "\'"]

" ペアかどうか判定
function! IsPair(beforeletter, nowletter)
  if index(g:open_brackets, a:beforeletter) == -1
    return 0
  elseif index(g:open_brackets, a:beforeletter) == index(g:close_brackets, a:nowletter)
    return 1
  else
    return 0
  endif
endfunction

" 同じ行内で対応する閉じカッコの位置を探す
function! CloseBracketColumn(beforeletter)
  let line_tail = strpart(getline('.'), col('.') - 1)
  let close_bracket = g:close_brackets[index(g:open_brackets, a:beforeletter)]
  let nested = 0
  let colcount = 0
  for c in line_tail
    if c == a:beforeletter
      let nested += 1
    elseif IsPair(a:beforeletter, c)
      if nested == 0
        return colcount
      else
        let nested -= 1
      endif
    endif
    let colcount += 1
  endfor
  return -1
endfunction

" 改行時にインデントやカッコを補完
function! IndentBraces()
  let beforeletter = getline(".")[col(".") - 2]
  let nowletter = getline(".")[col(".") - 1]
  if beforeletter == ':'
    return "\n\t"
  elseif IsPair(beforeletter, nowletter)
    return "\n\t\n\<BS>\<UP>\<END>"
  elseif index(g:open_brackets, beforeletter) != -1
    let close_col = CloseBracketColumn(beforeletter)
    if close_col == -1
      return "\n\t"
    else
      return "\n\t" . repeat("\<RIGHT>", close_col) . "\n\<BS>\<UP>\<ESC>I"
    endif
  elseif index(g:close_brackets, nowletter) != -1
    return "\n\<ESC>O\t"
  else
    return "\n"
  endif
endfunction

" 開きカッコを削除したときに閉じカッコも一緒に削除
function! BracketBackspace()
  let beforeletter = getline(".")[col(".") - 2]
  let nowletter = getline(".")[col(".") - 1]
  if IsPair(beforeletter, nowletter)
    return "\<RIGHT>\<BS>\<BS>"
  else
    return "\<BS>"
  endif
endfunction


" ========== basic settings ==========
set expandtab
set autoindent
set smarttab
set fenc=utf-8
set hidden
set wildmode=list,full
set mouse=
set timeoutlen=500
set clipboard+=unnamedplus
filetype indent off
filetype plugin indent off
" シェルの設定
if executable("pwsh")
  set shell=pwsh
elseif executable("powershell")
  set shell=powershell
elseif executable("zsh")
  set shell=zsh
elseif executable("bash")
  set shell=bash
else
  echo "None of shells are executable."
endif


" ========== keymaps ==========

noremap <Space> <nop>
let mapleader = "\<Space>"

" completions in insert mode
inoremap { {}<LEFT>
inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap ' ''<LEFT>
inoremap " ""<LEFT>
inoremap '' '
inoremap "" "
inoremap """ """"""<LEFT><LEFT><LEFT>
inoremap <> <><LEFT>
inoremap <C-s> ==========

" motions
noremap H ^
noremap L $
" noremap K *zz
noremap n nzz
noremap N Nzz

" buffers, windows, tabs
nnoremap <C-k> :bprev<CR>
nnoremap <C-j> :bnext<CR>
nnoremap <leader>d :bnext \| bdelete #<CR>
nnoremap <leader>e :e 
nnoremap <leader>w :w<CR>

nnoremap <C-l> <C-w>w
nnoremap <C-h> <C-w>W
nnoremap <leader>h :split<CR>
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>q :q<CR>

nnoremap <M-h> :tabp<CR>
nnoremap <M-l> :tabn<CR>
nnoremap <leader>c :tabnew %<CR>
nnoremap <leader>C :tabclose<CR>

" other remaps
nmap <silent> <ESC><ESC> :nohlsearch<CR><ESC>
nnoremap <leader><leader>b :call ToggleBackgroundColor()<CR>
nnoremap U <C-r>
nnoremap <leader>i :! 
nnoremap <leader>src :source ~/.dotfiles/nvim/init.vim<CR>

" terminal settings
if has('nvim')
  tnoremap <silent> <ESC> <C-\><C-n>
  nnoremap <leader>t :terminal<CR>
else
  tnoremap <silent> <ESC><ESC> <C-w>N
  nnoremap <leader>t :terminal ++curwin<CR>
endif

" fzf 用
nnoremap <leader>f         :Files<CR>
nnoremap <leader><leader>f :Files 
nnoremap <leader>g         :GFiles<CR>
nnoremap <leader><leader>g :GFiles?<CR>
nnoremap <leader>b         :Buffers<CR>
nnoremap <leader>a         :Ag<CR>
nnoremap <leader><leader>a :Ag 
nnoremap <leader>r         :Rg<CR>
nnoremap <leader><leader>r :Rg 
nnoremap <leader>l         :Lines<CR>
nnoremap <leader><leader>l :BLines<CR>
nnoremap <leader>m         :Marks<CR>
nnoremap <leader><leader>m :BMarks<CR>


" ========== representation ==========
set number
set showcmd
set listchars=tab:>-,trail:-
set list
set hlsearch
set incsearch
set completeopt=menu,preview
set guicursor=n-v-c-i:block

" view 保存・復元（折り畳みなど）
autocmd BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
autocmd BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent! loadview | endif
set viewoptions-=options

" ターミナルでは行番号非表示
if has('nvim')
  autocmd TermOpen * setlocal nonumber norelativenumber
endif

" cursorline representation
function ChangeColorInsertEnter()
  set nocursorline
endfunction
function ChangeColorInsertLeave()
  set cursorline
endfunction
autocmd InsertEnter * call ChangeColorInsertEnter()
autocmd InsertLeave * call ChangeColorInsertLeave()
set cursorline

" toggle background
function ToggleBackgroundColor()
  let g:none_background_color = 1 - g:none_background_color
  execute 'colorscheme ' . g:colors_name
endfunction

" overwrite color scheme
let g:none_background_color = 1
function OverWriteColor()
  let l:listchars_guifg = synIDattr(synIDtrans(hlID('WarningMsg')), 'fg', 'gui')
  let l:listchars_guibg = synIDattr(synIDtrans(hlID('Title')),      'fg', 'gui')
  execute 'hi NonText    guifg='. l:listchars_guifg . ' guibg=' . l:listchars_guibg
  execute 'hi Whitespace guifg='. l:listchars_guifg . ' guibg=' . l:listchars_guibg
  execute 'hi SpecialKey guifg='. l:listchars_guifg . ' guibg=' . l:listchars_guibg
  if has('nvim')
    if g:none_background_color
      hi Normal ctermbg=None guibg=None
      hi NormalNC ctermbg=None guibg=None
    endif
  else
    if g:none_background_color
      hi Normal ctermbg=None
      hi NormalNC ctermbg=None
    endif
  endif
endfunction
autocmd ColorScheme * call OverWriteColor()

syntax on
syntax enable
set background=dark
if has('nvim')
  colorscheme nightfox
else
  colorscheme iceberg
endif


" ========== filetype settings ==========
" lisp mode
autocmd BufEnter *.lisp call LispSetting()
function LispSetting()
  setlocal lisp
  inoremap <buffer> <silent> <expr> <BS> BracketBackspace()
endfunction
" set IndentBrace function
autocmd BufEnter * if expand('%:e') !=# 'lisp' |
  \ inoremap <buffer> <silent> <expr> <BS> BracketBackspace() |
  \ inoremap <buffer> <silent> <expr> <CR> IndentBraces() |
  \ endif

" set indent width in reference to filetype
autocmd BufEnter * call IndentWidthSet()
function IndentWidthSet()
  let ft2 = [
    \ 'markdown',
    \ 'vim',
    \ 'tex',
    \ 'plaintex',
    \ 'sh',
    \ 'bash',
    \ 'zsh',
    \ 'bib',
    \ 'typst',
    \ 'html',
    \ 'javascript',
  \ ]
  if index(ft2, &filetype) >=0
    setlocal shiftwidth=2
  else
    setlocal shiftwidth=4
  endif
endfunction

" set filetype of specific files
autocmd BufEnter */bashenv,*/shellrc,*/shellenv,~/.shellenv.local set filetype=bash
autocmd BufEnter */dotfiles/gitconfig,~/.profile.gitconfig set filetype=gitconfig


" ========== load local settings ==========
let g:nvim_prefix = "~/.config/nvim/"
if !filereadable(expand(g:nvim_prefix . "local.vim"))
  silent! call system('touch ' . expand(g:nvim_prefix . "local.vim"))
endif
execute "source " . g:nvim_prefix . "local.vim"

" ========== lsp settings ==========
if has('nvim')
  lua require('lsp')
endif

