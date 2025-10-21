local ret_status="%(?:%{$fg_bold[green]%}(*'~'):%{$fg_bold[red]%}(;>~<%))"
PROMPT='%{$fg_bold[cyan]%}@%M %{$reset_color%}%D %T $(git_prompt_info)%{$fg_bold[green]%}%~%{$reset_color%}
${ret_status} < %? %{$fg_bold[red]%}%# %{$reset_color%}'
PROMPT2='${ret_status} %_> %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}%{$bg[black]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="*)"
ZSH_THEME_GIT_PROMPT_CLEAN=")"
