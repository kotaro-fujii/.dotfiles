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

windows_homedir=$(powershell.exe '$env:USERPROFILE' | sed 's/\\/\//g' | sed 's/C:/\/mnt\/c/1' | tr -d '\r')
windows_appdata=$windows_homedir/AppData/Roaming

# ====================

# zsh initialize
ln -sf $dotfiles_prefix/zsh/zshrc $HOME/.zshrc
ln -sf $dotfiles_prefix/zsh/zshenv $HOME/.zshenv
dir_link $dotfiles_prefix/zsh $HOME/.zsh

# bash initialize
ln -sf $dotfiles_prefix/zsh/zshrc $HOME/.bashrc

# .config/nvim setting
[ ! -d $HOME/.config ] && mkdir $HOME/.config
dir_link $dotfiles_prefix/nvim $HOME/.config/nvim

# .vim setting
ln -sf $dotfiles_prefix/nvim/init.vim $HOME/.vimrc
dir_link $dotfiles_prefix/vim $HOME/.vim

# emacs setting
dir_link $dotfiles_prefix/emacs.d $HOME/.emacs.d

# alacritty setting
if [ -f /etc/wsl.conf ]; then
    windows_alacritty=$windows_appdata/alacritty
    [ ! -d $windows_alacritty ] && mkdir $windows_alacritty
    cp -r $dotfiles_prefix/alacritty/* $windows_alacritty
    [ ! -f $windows_alacritty/local.toml ] && touch $windows_alacritty/local.toml
    if [ ! -d $windows_alacritty/themes ]; then
        ssh -T git@github.com && git clone https://github.com/alacritty/alacritty-theme $windows_alacritty/themes
    fi
fi

# wezterm setting
# windows
if [ -f /etc/wsl.conf ]; then
  cp $dotfiles_prefix/wezterm/wezterm_windows.lua $windows_homedir/.wezterm.lua
  wezterm_local=$windows_homedir/.wezterm_local.lua
  [ ! -f $wezterm_local ] && cp $dotfiles_prefix/wezterm/wezterm_local.lua $wezterm_local
# linux
else
  wezterm_dir=$HOME/.config/wezterm
  [ ! -d $wezterm_dir ] && mkdir $wezterm_dir
  ln -s $dotfiles_prefix/wezterm/wezterm_linux.lua $wezterm_dir/wezterm.lua
fi

# other config settings
ln -sf $dotfiles_prefix/gitconfig $HOME/.gitconfig
ln -sf $dotfiles_prefix/tmux.conf $HOME/.tmux.conf

# ====================
# initialize applications
# ====================

# cargo
if [[ ! -d $HOME/.cargo ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# bat
if [[ ! -d $dotfiles_prefix/bat ]]; then
    bat_tar_gz=$dotfiles_prefix/bat-v0.25.0-x86_64-unknown-linux-gnu.tar.gz
    wget https://github.com/sharkdp/bat/releases/download/v0.25.0/bat-v0.25.0-x86_64-unknown-linux-gnu.tar.gz \
        -O $bat_tar_gz
    tar -zxvf $bat_tar_gz && \
        rm $bat_tar_gz && \
        mv $(dirname $bat_tar_gz)/$(basename $bat_tar_gz .tar.gz) $dotfiles_prefix/bat
fi

## fzf
if [[ ! -d $dotfiles_prefix/fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git $dotfiles_prefix/fzf
    $dotfiles_prefix/fzf/install --all
fi
dir_link $dotfiles_prefix/fzf $HOME/.fzf

miniforge_url="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
miniforge_filename=$(basename $miniforge_url)
[ ! -f $dotfiles_prefix/$miniforge_filename ] && \
  wget -P $dotfiles_prefix $miniforge_url && \
  chmod +x $miniforge_filename && \
  ./$miniforge_filename -p $dotfiles_prefix/miniforge3

