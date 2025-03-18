#!/bin/zsh

dotfiles_prefix=$HOME/.dotfiles

function dir_link {
    # arg1: directory to link
    # arg2: link destination
    if [[ $(readlink $2) != $1 ]]; then
        rm -rf $2
        ln -sf $1 $2
    fi
}

# zsh initialize
ln -sf $dotfiles_prefix/zsh/zshrc $HOME/.zshrc
dir_link $dotfiles_prefix/zsh $HOME/.zsh
[ ! -e $dotfiles_prefix/zsh/local.sh ] && touch $dotfiles_prefix/zsh/local.sh
# bash initialize
ln -sf $dotfiles_prefix/zsh/zshrc $HOME/.bashrc
# .config/nvim setting
[ ! -d $HOME/.config ] && mkdir $HOME/.config
dir_link $dotfiles_prefix/nvim $HOME/.config/nvim
# .vim setting
dir_link $dotfiles_prefix/nvim $HOME/.vim
# alacritty setting
ssh -T git@github.com
if [[ $? = 1 ]]; then
    git clone git@github.com:kotaro-fujii/alacritty_setting.git $dotfiles_prefix/alacritty_config
fi
if [[ $(readlink $HOME/.config/alacritty) != $dotfiles_prefix/alacritty ]]; then
    rm -rf $HOME/.config/alacritty
    ln -sf $dotfiles_prefix/alacritty_config $HOME/.config/alacritty
fi
# emacs setting
dir_link $dotfiles_prefix/emacs.d $HOME/.emacs.d
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
dir_link $dotfiles_prefix/fzf $HOME/.fzf
## alacritty
#if [[ ! -d $dotfiles_prefix/alacritty ]]; then
#    git clone https://github.com/alacritty/alacritty.git $dotfiles_prefix/alacritty
#    (
#        cd $dotfiles_prefix/alacritty;
#        cargo build --release;
#    )
#fi
