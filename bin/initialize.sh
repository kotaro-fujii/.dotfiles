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

# initialize applications
[ ! -d $HOME/.bin ] && mkdir $HOME/.bin
## cargo
if [[ ! -d $HOME/.cargo ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
## bat
if [[ ! -d $dotfiles_prefix/bat ]]; then
    bat_tar_gz=$dotfiles_prefix/bat-v0.25.0-x86_64-unknown-linux-gnu.tar.gz
    wget https://github.com/sharkdp/bat/releases/download/v0.25.0/bat-v0.25.0-x86_64-unknown-linux-gnu.tar.gz \
        -O $bat_tar_gz
    tar -zxvf $bat_tar_gz && \
        rm $bat_tar_gz && \
        mv $(dirname $bat_tar_gz)/$(basename $bat_tar_gz .tar.gz) $dotfiles_prefix/bat
fi
ln -sf $dotfiles_prefix/bat/bat $HOME/.bin
## fzf
if [[ ! -d $dotfiles_prefix/fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git $dotfiles_prefix/fzf
    $dotfiles_prefix/fzf/install --all
fi
if [[ $(readlink $HOME/.fzf) != $dotfiles_prefix/fzf ]]; then
    rm -rf $HOME/.fzf
    ln -sf $dotfiles_prefix/fzf $HOME/.fzf
fi
