#!/bin/zsh

dotfiles_prefix=$HOME/.dotfiles
ln -s $dotfiles_prefix/zsh/zshrc $HOME/.zshrc
rm $HOME/.zsh
ln -s $dotfiles_prefix/zsh $HOME/.zsh

ln -sf $dotfiles_prefix/gitconfig $HOME/.gitconfig
ln -sf $dotfiles_prefix/tmux.conf $HOME/.tmux.conf

mkdir $HOME/.config
ln -sf $dotfiles_prefix/nvim $HOME/.config/nvim
