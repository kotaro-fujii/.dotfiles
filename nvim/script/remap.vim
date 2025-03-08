" basic remaps
" brackets
inoremap { {}<LEFT>
inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap ' ''<LEFT>
inoremap " ""<LEFT>
inoremap <> <><LEFT>
" bracket format
inoremap <silent> <expr> <BS> BracketBackspace()
inoremap <silent> <expr> <CR> IndentBraces()
" buffer and window operations
let mapleader = "\<Space>"
nnoremap <leader>h :split<CR>
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>t :terminal<CR>
nnoremap <leader>d :bdelete<CR>
nnoremap <leader>e :e 
nnoremap <leader>l :ls<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>b :b 
nnoremap <C-k> :bprev<CR>
nnoremap <C-j> :bnext<CR>
"" remaps to operate buffer with fzf plugin
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>G :GFiles?<CR>


nmap <silent> <ESC><ESC> :nohlsearch<CR><ESC>

tnoremap <silent> <ESC> <c-\><c-n>

autocmd FileType lisp call LispRemap()
autocmd FileType vim call VimRemap()

function! VimRemap()
    inoremap <buffer> "" ""<LEFT>
endfunction

function! LispRemap()
    iunmap '
endfunction
