#!/bin/zsh

dotfiles_prefix=$HOME/.dotfiles
ln -f $dotfiles_prefix/zsh/zshrc $HOME/.zshrc
rm $HOME/.zsh
ln -f $dotfiles_prefix/zsh $HOME/.zsh

ln -sf $dotfiles_prefix/gitconfig $HOME/.gitconfig
ln -sf $dotfiles_prefix/tmux.conf $HOME/.tmux.conf
