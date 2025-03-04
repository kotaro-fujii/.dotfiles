let g:nvim_prefix = "~/.config/nvim/"

let g:script_path = g:nvim_prefix . "script/"
execute "source " . g:script_path . "basic.vim"
execute "source " . g:script_path . "remap.vim"
execute "source " . g:script_path . "representation.vim"
execute "source " . g:script_path . "func.vim"
