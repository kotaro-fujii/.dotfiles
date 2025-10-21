local ret_status="%(?:%{$fg_bold[green]%}(*'~'):%{$fg_bold[red]%}(;>~<%))"
PROMPT='%{$fg_bold[cyan]%}@%M %{$fg_bold[green]%}%~ $(git_prompt_info)
${ret_status} < %? %{$fg_bold[red]%}%# %{$reset_color%}'
PROMPT2='${ret_status} %_> %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[green]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="*)"
ZSH_THEME_GIT_PROMPT_CLEAN=")"
