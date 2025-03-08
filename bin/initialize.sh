#!/bin/zsh

dotfiles_prefix=$HOME/.dotfiles

# zsh initialize
ln -sf $dotfiles_prefix/zsh/zshrc $HOME/.zshrc
if [[ $(readlink $HOME/.zsh) != $dotfiles_prefix/zsh ]]; then
    rm -rf $HOME/.zsh
    ln -sf $dotfiles_prefix/zsh $HOME/.zsh
fi
if [[ ! -e $dotfiles_prefix/zsh/local.sh ]]; then
    touch $dotfiles_prefix/zsh/local.sh
fi
# .config/nvim setting
if [ ! -d $HOME/.config ]; then
    mkdir $HOME/.config
fi
if [[ $(readlink $HOME/.config/nvim) != $dotfiles_prefix/nvim ]]; then
    rm -rf $HOME/.config/nvim
    ln -sf $dotfiles_prefix/nvim $HOME/.config/nvim
fi
# other settings
ln -sf $dotfiles_prefix/gitconfig $HOME/.gitconfig
ln -sf $dotfiles_prefix/tmux.conf $HOME/.tmux.conf

if [[ ! -d $dotfiles_prefix/fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git $dotfiles_prefix/fzf
    $dotfiles_prefix/fzf/install --all
fi
if [[ $(readlink $HOME/.fzf) != $dotfiles_prefix/fzf ]]; then
    rm -rf $HOME/.fzf
    ln -sf $dotfiles_prefix/fzf $HOME/.fzf
fi
