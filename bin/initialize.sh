#!/bin/zsh

dotfiles_prefix=$HOME/.dotfiles
cp $dotfiles_prefix/zsh/zshrc $HOME/.zshrc
rm $HOME/.zsh
ln -s $HOME/.dotfiles/zsh $HOME/.zsh
