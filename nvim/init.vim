" ===========================================
" プラグイン設定：dein.vim
" ===========================================

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

" ===========================================
" 自作関数：カッコ補完やインデント制御
" ===========================================

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

" ===========================================
" エディタ基本設定
" ===========================================
set expandtab                 " タブをスペースに
set autoindent                " 自動インデント
set smarttab                  " スマートタブ
set fenc=utf-8                " 文字コード
set hidden                     " 編集中でも他のバッファを開ける
set shell=zsh                  " シェルを zsh に
set wildmode=list,full         " コマンド補完モード
set mouse=                      " マウス無効
set timeoutlen=500             " マッピング待ち時間
set clipboard+=unnamedplus     " システムクリップボードと共有
filetype indent off
filetype plugin indent off

" ===========================================
" キーマップ設定
" ===========================================

" 括弧補完（インサートモード）
inoremap { {}<LEFT>
inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap ' ''<LEFT>
inoremap " ""<LEFT>
inoremap '' '
inoremap "" "
inoremap """ """"""<LEFT><LEFT><LEFT>
inoremap <> <><LEFT>

" ESC でモード切替（terminal）
tnoremap <silent> <ESC> <C-\><C-n>

" 行頭・行末移動
noremap H ^
noremap L $

" Leader キーを Space に
let mapleader = "\<Space>"

" よく使うコマンド
nnoremap <leader>h :split<CR>
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>t :terminal<CR>
nnoremap <leader>d :bdelete<CR>
nnoremap <leader>e :e 
nnoremap <leader>l :ls<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>B :call ToggleBackgroundColor()<CR>
nnoremap <leader>src :source ~/.dotfiles/nvim/init.vim<CR>

" バッファ移動
nnoremap <C-k> :bprev<CR>
nnoremap <C-j> :bnext<CR>

" ウィンドウ移動
nnoremap <C-l> <C-w>w
nnoremap <C-h> <C-w>W

" タブ移動
nnoremap <M-h> :tabp<CR>
nnoremap <M-l> :tabn<CR>
nnoremap <leader>c :tabnew %<CR>
nnoremap <leader>C :tabclose<CR>

" fzf 用
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>G :GFiles?<CR>
nnoremap <leader>b :Buffers<CR>

" その他remap
nmap <silent> <ESC><ESC> :nohlsearch<CR><ESC>
nnoremap U <C-r>

" ===========================================
" 表示・見た目設定
" ===========================================
set number                     " 行番号表示
set showcmd                    " コマンド表示
set listchars=tab:>-,trail:-   " 不可視文字表示
set list
set hlsearch                   " 検索結果ハイライト
set incsearch                  " インクリメンタルサーチ
set completeopt=menu,preview
set guicursor=n-v-c-i:block    " カーソル形状

" ===========================================
" ファイルごと設定・オートコマンド
" ===========================================

" view 保存・復元（折り畳みなど）
autocmd BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
autocmd BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent! loadview | endif
set viewoptions-=options

" ターミナルでは行番号非表示
if has('nvim')
  autocmd TermOpen * setlocal nonumber norelativenumber
endif

" ===========================================
" カラー設定
" ===========================================

" カーソルライン制御
function ChangeColorInsertEnter()
  set nocursorline
endfunction
function ChangeColorInsertLeave() 
  set cursorline
endfunction
autocmd InsertEnter * call ChangeColorInsertEnter()
autocmd InsertLeave * call ChangeColorInsertLeave()
set cursorline

" 背景切り替え
function ToggleBackgroundColor()
  let g:none_background_color = 1 - g:none_background_color
  execute 'colorscheme ' . g:colors_name
endfunction

" カラースキームの上書き
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

" ===========================================
" ファイルタイプ別設定など
" ===========================================

" lisp ファイルは lisp モード
autocmd BufNewFile,BufReadPost *.lisp setlocal lisp

" 他ファイルは自作関数を利用
autocmd BufNewFile,BufReadPost * if expand('%:e') !=# 'lisp' | 
      \ inoremap <buffer> <silent> <expr> <BS> BracketBackspace() |
      \ inoremap <buffer> <silent> <expr> <CR> IndentBraces() |
      \ endif

" ファイルタイプによるインデント幅設定
function IndentWidthSet()
  let ft2 = ['md','markdown','vim','tex','plaintex','sh','bash','zsh','bib']
  if index(ft2, &filetype) >=0
    setlocal shiftwidth=2
  else
    setlocal shiftwidth=4
  endif
endfunction
autocmd BufNewFile,BufReadPost * call IndentWidthSet()

" ===========================================
" ローカル設定の読み込み
" ===========================================
let g:nvim_prefix = "~/.config/nvim/"
if !filereadable(expand(g:nvim_prefix . "local.vim"))
  silent! call system('touch ' . expand(g:nvim_prefix . "local.vim"))
endif
execute "source " . g:nvim_prefix . "local.vim"

