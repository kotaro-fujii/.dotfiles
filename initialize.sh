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

# ========== make links ==========

setln () {
  # zsh
  ln -sf $dotfiles_prefix/zsh/zshrc $HOME/.zshrc
  ln -sf $dotfiles_prefix/zsh/zshenv $HOME/.zshenv
  dir_link $dotfiles_prefix/zsh $HOME/.zsh
  # bash
  ln -sf $dotfiles_prefix/bash/bashrc $HOME/.bashrc
  dir_link $dotfiles_prefix/bash $HOME/.bash
  # neovim
  [ ! -d $HOME/.config ] && mkdir $HOME/.config
  dir_link $dotfiles_prefix/nvim $HOME/.config/nvim
  # neovim (windows)
  if [ -f /etc/wsl.conf ]; then
    win_nvim=$windows_homedir/AppData/Local/nvim
    [ ! -d $win_nvim ] && mkdir $win_nvim
    cp $dotfiles_prefix/nvim/init.vim $win_nvim
    win_nvim_conf=$windows_homedir/.config/nvim
    [ ! -d $win_nvim_conf ] && mkdir $win_nvim_conf
    cp $dotfiles_prefix/nvim/dein.toml $win_nvim_conf
  fi
  # vim
  ln -sf $dotfiles_prefix/nvim/init.vim $HOME/.vimrc
  dir_link $dotfiles_prefix/vim $HOME/.vim
  # emacs
  dir_link $dotfiles_prefix/emacs.d $HOME/.emacs.d
  # alacritty
  if [ -f /etc/wsl.conf ]; then
      windows_alacritty=$windows_appdata/alacritty
      [ ! -d $windows_alacritty ] && mkdir $windows_alacritty
      cp -r $dotfiles_prefix/alacritty/* $windows_alacritty
      [ ! -f $windows_alacritty/local.toml ] && touch $windows_alacritty/local.toml
      if [ ! -d $windows_alacritty/themes ]; then
        ssh -T git@github.com && git clone https://github.com/alacritty/alacritty-theme $windows_alacritty/themes
      fi
  fi
  # wezterm (windows)
  if [ -f /etc/wsl.conf ]; then
    cp $dotfiles_prefix/wezterm/wezterm_windows.lua $windows_homedir/.wezterm.lua
    wezterm_local=$windows_homedir/.wezterm_local.lua
    [ ! -f $wezterm_local ] && cp $dotfiles_prefix/wezterm/wezterm_local.lua $wezterm_local
  # wezterm (linux)
  else
    wezterm_dir=$HOME/.config/wezterm
    [ ! -d $wezterm_dir ] && mkdir $wezterm_dir
    ln -s $dotfiles_prefix/wezterm/wezterm_linux.lua $wezterm_dir/wezterm.lua
  fi
  # powershell
  if [ -f /etc/wsl.conf ]; then
    cp $dotfiles_prefix/pwsh/Microsoft.PowerShell_profile.ps1 $windows_homedir/Documents/PowerShell
  fi
  # other configs
  ln -sf $dotfiles_prefix/gitconfig $HOME/.gitconfig
  ln -sf $dotfiles_prefix/tmux.conf $HOME/.tmux.conf
  # jj
  dir_link $dotfiles_prefix/jj $HOME/.config/jj
}
setln

# ========== install applications ==========

install_ohmyzsh () {
  if [ ! -d $HOME/.oh-my-zsh ] && { ! type "omz" }; then
    sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
  fi
}

# todo: check dependency
# todo: update evaluation
install_neovim () {
  __neovim_version="v0.11.4"
  if [[ ! -d "$dotfiles_prefix/neovim" ]]; then
    git clone "https://github.com/neovim/neovim.git" $dotfiles_prefix/neovim
    mkdir $dotfiles_prefix/neovim-install
    (
      cd $dotfiles_prefix/neovim \
        && git checkout "$__neovim_version" \
        && make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$dotfiles_prefix/neovim-install \
        && make install
    )
  fi
  unset __neovim_version
}

install_cargo () {
  if [[ ! -d $HOME/.cargo ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  fi
}

install_stack () {
  if [[ ! -f $dotfiles_prefix/stack/stack ]]; then
    wget "https://get.haskellstack.org/" -O $dotfiles_prefix/stack_installation.sh
    chmod +x $dotfiles_prefix/stack_installation.sh
    $dotfiles_prefix/stack_installation.sh -d $dotfiles_prefix/stack
  fi
}

install_bat () {
  cargo install --locked bat
}

install_tre () {
  cargo install tre-command
}

install_fzf () {
  if [[ ! -d $dotfiles_prefix/fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git $dotfiles_prefix/fzf
    $dotfiles_prefix/fzf/install --all
  fi
  dir_link $dotfiles_prefix/fzf $HOME/.fzf
}

install_ripgrep () {
  if [[ ! -f $HOME/.cargo/bin/ripgrep ]]; then
    cargo install ripgrep
  fi
}

install_miniforge () {
  miniforge_url="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
  miniforge_filename=$(basename $miniforge_url)
  [ ! -f $dotfiles_prefix/$miniforge_filename ] && \
    wget -P $dotfiles_prefix $miniforge_url && \
    chmod +x $miniforge_filename && \
    ./$miniforge_filename -p $dotfiles_prefix/miniforge3
}

install_uv () {
  cargo install --git https://github.com/astral-sh/uv uv
}

install_jj () {
  cargo install --locked --bin jj jj-cli
}

install_nodejs () {
  nodejs_version=22.19.0
  if [[ ! -d $dotfiles_prefix/node ]]; then
    wget -O - "https://nodejs.org/dist/v${nodejs_version}/node-v${nodejs_version}-linux-x64.tar.xz" \
      | tar -Jxf - -C $dotfiles_prefix
    mv $dotfiles_prefix/node-v${nodejs_version}-linux-x64 $dotfiles_prefix/node
  fi
}

# LSP

install_pyright () {
  uv tool install pyright
}

install_rust_analyzer () {
  rustup component add rust-analyzer
}

install_markdown_oxide () {
  cargo install --git 'https://github.com/feel-ix-343/markdown-oxide' markdown-oxide
}

install_tinymist () {
  cargo install --git https://github.com/Myriad-Dreamin/tinymist --locked tinymist-cli
}

install_shellcheck () {
  if ! type shellcheck; then
    stack update
    stack install ShellCheck
  fi
}

install_bash_language_server () {
  if [[ ! -L $dotfiles_prefix/node/bin/bash-language-server ]]; then
    npm i -g bash-language-server
  fi
}

install_vim_language_server () {
  if [[ ! -L $dotfiles_prefix/node/bin/vim-language-server ]]; then
    npm i -g vim-language-server
  fi
}

# ========== run initialization ==========

package_func_json=$(cat << EOS
{
  "ohmyzsh":              "install_ohmyzsh",
  "neovim":               "install_neovim",
  "cargo":                "install_cargo",
  "stack":                "install_stack",
  "bat":                  "install_bat",
  "tre":                  "install_tre",
  "fzf":                  "install_fzf",
  "ripgrep":              "install_ripgrep",
  "miniforge":            "install_miniforge",
  "uv":                   "install_uv",
  "jj":                   "install_jj",
  "pyright":              "install_pyright",
  "rust_analyzer":        "install_rust_analyzer",
  "markdown_oxide":       "install_markdown_oxide",
  "tinymist":             "install_tinymist",
  "shellcheck":           "install_shellcheck",
  "bash_language_server": "install_bash_language_server",
  "vim_language_server":  "install_vim_language_server"
}
EOS
)

install_all=0
for arg in ${@}; do
  case $arg in
    -a)
      packages=$(echo $package_func_json | jq -r 'keys[]')
      install_all=1
      ;;
  esac
done
if [ $install_all -eq 0 ]; then
  packages=${@}
fi

for package in $(echo $packages); do
  install_function=$(echo $package_func_json | jq -r ".${package}")
  if [ "$install_function" = "null" ]; then
    echo "package \"$package\" is not found." >&2
  else
    $install_function
  fi
done
  # dottools
  uv tool install -e $dotfiles_prefix/dottools
