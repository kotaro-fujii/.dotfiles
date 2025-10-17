<!--
     ██████╗   ██████╗  ████████╗ ███████╗ ██╗ ██╗      ███████╗ ███████╗
     ██╔══██╗ ██╔═══██╗ ╚══██╔══╝ ██╔════╝ ██║ ██║      ██╔════╝ ██╔════╝
     ██║  ██║ ██║   ██║    ██║    █████╗   ██║ ██║      █████╗   ███████╗
     ██║  ██║ ██║   ██║    ██║    ██╔══╝   ██║ ██║      ██╔══╝   ╚════██║
 ██╗ ██████╔╝ ╚██████╔╝    ██║    ██║      ██║ ███████╗ ███████╗ ███████║
 ╚═╝ ╚═════╝   ╚═════╝     ╚═╝    ╚═╝      ╚═╝ ╚══════╝ ╚══════╝ ╚══════╝
-->

# .dotfiles
ターミナル操作のためのツールや設定をまとめたリポジトリ

# contents
- initialize.sh:
  インストールのためのシェルスクリプト
- alacritty
- wezterm
- bash
- zsh
- neovim
- vim
- emacs
- bin
- fzf
- bat
- uv
- miniforge
- gitconfig
- tmux.conf
- stack

## alacritty
以下は設定例です。
```local.toml
[window]
opacity = 0.7

[general]
import = [
    "~/AppData/Roaming/alacritty/themes/themes/nightfox.toml"
]
```

## wezterm
alacrittyとは逆に様々な機能を盛り込んだターミナルエミュレータです。
alacrittyと同様にGPUを活用しています。
`lua`ファイルによる柔軟な設定が可能です。

以下は設定例です(Windows)。
```.wezterm_local.lua
local config = {}
config.background = {
    {
        vertical_align = "Middle",
        horizontal_align = "Center",
        source = {
            File = "C:/Users/fkota/.wezterm_image",
        },
        hsb = {
            brightness = 0.2,
        },
    },
}
return config
```

## font installation
`alacritty`, `wezterm` といったターミナルエミュレータのフォントを変更する際、
新たにインストールする必要がある場合、以下のような操作でインストールできます。

example: 和英文用コードフォント`HackGen Console`をインストールするコマンド
```sh
wget https://github.com/yuru7/HackGen/releases/download/v2.10.0/HackGen_v2.10.0.zip
unzip HackGen_v2.10.0.zip
mv HackGen_v2.10.0.zip ~/.fonts
fc-cache -fv
```

---

# これから実装予定
- oh-my-zshのインストール

# 検証済み環境
- WSL
  - ubuntu 24.04
- VirtualBox
  - Ubuntu
- Dockerコンテナ
  - ArchLinux
  - Debian

# 最後に
改善案や質問があれば、GitHubの issue や PullRequest、対面にて管理者まで連絡してください。
