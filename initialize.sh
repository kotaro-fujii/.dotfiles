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

# oh-my-zsh initialize
if [ ! -d $HOME/.oh-my-zsh ] && { ! type "omz" }; then
  sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
fi

# zsh initialize
ln -sf $dotfiles_prefix/zsh/zshrc $HOME/.zshrc
ln -sf $dotfiles_prefix/zsh/zshenv $HOME/.zshenv
dir_link $dotfiles_prefix/zsh $HOME/.zsh

# bash initialize
ln -sf $dotfiles_prefix/bash/bashrc $HOME/.bashrc
dir_link $dotfiles_prefix/bash $HOME/.bash

# .config/nvim setting
[ ! -d $HOME/.config ] && mkdir $HOME/.config
dir_link $dotfiles_prefix/nvim $HOME/.config/nvim

# nvim (windows) setting
if [ -f /etc/wsl.conf ]; then
  win_nvim=$windows_homedir/AppData/Local/nvim
  [ ! -d $win_nvim ] && mkdir $win_nvim
  cp $dotfiles_prefix/nvim/init.vim $win_nvim
  win_nvim_conf=$windows_homedir/.config/nvim
  [ ! -d $win_nvim_conf ] && mkdir $win_nvim_conf
  cp $dotfiles_prefix/nvim/dein.toml $win_nvim_conf
fi

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

# powershell
if [ -f /etc/wsl.conf ]; then
  cp $dotfiles_prefix/pwsh/Microsoft.PowerShell_profile.ps1 $windows_homedir/Documents/PowerShell
fi

# other config settings
ln -sf $dotfiles_prefix/gitconfig $HOME/.gitconfig
ln -sf $dotfiles_prefix/tmux.conf $HOME/.tmux.conf

# ====================
# initialize applications
# ====================

# nvim
# check dependency
# todo: update evaluation
if [[ ! -d "$dotfiles_prefix/neovim" ]]; then
  git clone "https://github.com/neovim/neovim.git" $dotfiles_prefix/neovim
  mkdir $dotfiles_prefix/neovim-install
  (
    cd $dotfiles_prefix/neovim \
      && make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=$dotfiles_prefix/neovim-install \
      && make install
  )
fi
if [[ ! -d "$dotfiles_prefix/nvim-linux-x86_64" ]]; then
wget -O - "https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz" \
  | tar -zxf - -C $dotfiles_prefix
fi

# cargo
if [[ ! -d $HOME/.cargo ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# stack (haskell)
if [[ ! -f $dotfiles_prefix/stack/stack ]]; then
  wget "https://get.haskellstack.org/" -O $dotfiles_prefix/stack_installation.sh
  chmod +x $dotfiles_prefix/stack_installation.sh
  $dotfiles_prefix/stack_installation.sh -d $dotfiles_prefix/stack
fi

# bat
cargo install --locked bat

# fzf
if [[ ! -d $dotfiles_prefix/fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git $dotfiles_prefix/fzf
    $dotfiles_prefix/fzf/install --all
fi
dir_link $dotfiles_prefix/fzf $HOME/.fzf

# ripgrep
if [[ ! -f $HOME/.cargo/bin/ripgrep ]]; then
  cargo install ripgrep
fi

# miniforge
miniforge_url="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
miniforge_filename=$(basename $miniforge_url)
[ ! -f $dotfiles_prefix/$miniforge_filename ] && \
  wget -P $dotfiles_prefix $miniforge_url && \
  chmod +x $miniforge_filename && \
  ./$miniforge_filename -p $dotfiles_prefix/miniforge3

# nodejs
nodejs_version=22.19.0
#node-v${nodejs_version}-linux-x64
if [[ ! -d $dotfiles_prefix/node ]]; then
  wget -O - "https://nodejs.org/dist/v${nodejs_version}/node-v${nodejs_version}-linux-x64.tar.xz" \
    | tar -Jxf - -C $dotfiles_prefix
  mv $dotfiles_prefix/node-v${nodejs_version}-linux-x64 $dotfiles_prefix/node
fi

# ========== LSP ==========

# pylsp
if ! type pylsp; then
  mamba run -n base \
    mamba install python-lsp-server
fi

# rust-analyzer
rustup component add rust-analyzer

# markdown-oxide
cargo install --git 'https://github.com/feel-ix-343/markdown-oxide' markdown-oxide

# tinymist
cargo install --git https://github.com/Myriad-Dreamin/tinymist --locked tinymist-cli

# shellcheck
if ! type shellcheck; then
  stack update
  stack install ShellCheck
fi

# bash-language-server
if [[ ! -L $dotfiles_prefix/node/bin/bash-language-server ]]; then
  npm i -g bash-language-server
fi

# vim-language-server
if [[ ! -L $dotfiles_prefix/node/bin/vim-language-server ]]; then
  npm i -g vim-language-server
fi
