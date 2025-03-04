let g:vim_prefix = "~/.vim/"

let g:script_path = g:vim_prefix . "script/"
execute "source " . g:script_path . "basic.vim"
execute "source " . g:script_path . "remap.vim"
execute "source " . g:script_path . "representation.vim"
execute "source " . g:script_path . "func.vim"
