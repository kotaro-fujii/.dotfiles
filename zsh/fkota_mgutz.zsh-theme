typeset -A host_icon_table
host_icon_table=(
  #"desktop-Kotaro" "desktop-Kotaro"
)
hostname=$(hostname)
if [[ -n ${host_icon_table[(i)$(hostname)]} ]]; then
  hosticon=${host_icon_table[${hostname}]}
else
  hosticon=${hostname}
fi
#PROMPT='%{$fg_bold[cyan]%}@%m %{$fg_bold[green]%}%1~$(git_prompt_info) %{$fg_bold[red]%}%# %{$reset_color%}'
#PROMPT='%{$fg_bold[cyan]%}@${hosticon} %{$fg_bold[green]%}%1~$(git_prompt_info) %{$fg_bold[red]%}%# %{$reset_color%}'
local ret_status="%(?:%{$fg_bold[green]%}(*'-'):%{$fg_bold[red]%}(*>~<))"
PROMPT='%{$fg_bold[cyan]%}@${hosticon} %{$fg_bold[green]%}%1~$(git_prompt_info)
${ret_status} %{$fg_bold[red]%}%# %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[green]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="*)"
ZSH_THEME_GIT_PROMPT_CLEAN=")"
