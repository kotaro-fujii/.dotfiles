" remaps in insert mode
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
"" bracket format
inoremap <silent> <expr> <BS> BracketBackspace()
inoremap <silent> <expr> <CR> IndentBraces()

" remaps to escape
inoremap <silent> kj <ESC>
inoremap <silent> jk <ESC>
vnoremap <silent> vv <ESC>
cnoremap <silent> kj <C-u><ESC>
cnoremap <silent> jk <C-u><ESC>

" buffer and window operations
let mapleader = "\<Space>"
nnoremap <leader>h :split<CR>
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>t :terminal<CR>
nnoremap <leader>d :bdelete<CR>
nnoremap <leader>e :e 
nnoremap <leader>l :ls<CR>
nnoremap <leader>w :w<CR>
"nnoremap <leader>b :b 
nnoremap <C-k> :bprev<CR>
nnoremap <C-j> :bnext<CR>
"" remaps to operate buffer with fzf plugin
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>G :GFiles?<CR>
nnoremap <leader>b :Buffers<CR>

nmap <silent> <ESC><ESC> :nohlsearch<CR><ESC>

" remap to escape terminal
tnoremap <silent> <ESC> <c-\><c-n>
