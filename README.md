# .dotfiles
このリポジトリは、Linux 環境を自分好みに整えるための設定ファイル(dotfiles)をまとめたものです。
「何の設定？」「どうやって使うの？」がわかるように説明しています。

## このリポジトリでできること
- ターミナル(Alacritty, WezTerm)の見た目や使い勝手をカスタマイズ
- エディタ(Neovim, Emacs)の設定をまとめて管理
- ターミナルを扱うための便利なソフトウェア(bat, fzf)のインストール
- GitHubで設定ファイルを管理・共有
<!-- - シェル(zsh)の設定を統一 -->

## ディレクトリ構成

| ディレクトリ        | 説明                                                                 |
| ------------------- | -------------------------------------------------------------------- |
| **alacritty/**      | ターミナルエミュレータ「Alacritty」の設定                            |
| **wezterm/**        | ターミナルエミュレータ「WezTerm」の設定                              |
| **nvim/**           | Neovim(Vim含む)の設定                                                |
| **emacs.d/**        | Emacs の設定                                                         |
| **zsh/**            | zsh シェルの設定                                                     |
| **bin/**            | このリポジトリを使うためのスクリプト                                 |
| └ **initialize.sh** | 必要なソフトのインストールや設定ファイルのリンク作成を行うスクリプト |

## 注意(重要！)
`bin/initialize.sh` を実行すると、ホームディレクトリなどにある **既存の設定ファイルを削除** し、
代わりにこのリポジトリの設定ファイルへの **シンボリックリンクを作成** します。

**必ず** 実行前にバックアップを取るなどして、削除されて困る設定ファイルがないか確認してください！

## GitHub からダウンロード、インストール
git初心者向けに、**「クローン」と「フォーク」** の２つの方法を紹介します。

### 1. クローンするだけで使う方法(自分用に編集しない場合)
あなたの環境にそのまま設定をコピーして使えます。

```bash
# ホームディレクトリに移動
cd ~

# リポジトリをクローン
git clone https://github.com/kotaro-fujii/.dotfiles.git

# 移動
cd .dotfiles

# セットアップスクリプトを実行
./bin/initialize.sh
```

### 2. 自分用にカスタマイズしたい場合(フォークして使う)
GitHub の自分のアカウントにコピーを作って、自由に編集したいときは「フォーク」します。

1. [このリポジトリ](https://github.com/kotaro-fujii/.dotfiles) をブラウザで開く
2. 右上の *Star* の近くにある **"Fork"** ボタンをクリック
3. 自分のGitHubアカウントにフォーク(コピー)されます
4. 自分のフォークしたリポジトリのページで、「Code」→「HTTPS」をコピー
5. ターミナルで次のコマンドを実行：

```bash
# ホームディレクトリに移動
cd ~

# 自分のGitHubアカウントからクローン
git clone https://github.com/自分のユーザ名/.dotfiles.git

cd .dotfiles

# セットアップ
./bin/initialize.sh
```

## セットアップ後にできること
- 自分の設定をどんどん変更して、GitHubにpushして管理できる
- 新しいPCでも、クローンしてスクリプトを実行するだけで同じ環境が作れる

## oh-my-zshについて
このリポジトリの `zsh/zshrc` の一部の機能は `oh-my-zsh` に依存しています。
[こちらの記事](https://qiita.com/Oukaria/items/6cd0706beece722cd3db)を参考にインストール

## 補足
- 「dotfiles」とは、設定ファイル(例：`.zshrc`や`.vimrc`など)の総称です
- シンボリックリンクで管理することで、ファイルを直接ホームディレクトリに置かずに済みます
- `initialize.sh` は初回セットアップ用のスクリプトです

## こんな人におすすめ
- ターミナルやエディタをカスタマイズしたい
- Linuxの設定をGitHubで管理したい
- Linuxの仕組みを学んでみたい

---

# 各種ソフトウェアの使い方
以下のソフトウェアについての設定などを整備しています。
- alacritty
- wezterm
- neovim
- emacs
- bat
- fzf

## alacritty
```local.toml
[window]
opacity = 0.7

[general]
import = [
    "~/AppData/Roaming/alacritty/themes/themes/nightfox.toml"
]
```

## wezterm
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

## neovim
neovimはターミナル上で動作するテキストエディタです。
短時間での起動、素早い操作が特徴です。
ご自身でインストールしてください。

## emacs

## fzf
ファイルやコマンド実行履歴をあいまい検索できるソフトウェアです。
コマンドラインにて、 `ctrl + t` を押すとファイル名のあいまい検索、
`ctrl + r` を押すとコマンド実行履歴を検索できます。

---

# これから実装予定
- oh-my-zshのインストール
- vim, neovimの互換性に関する整備

# 検証済み環境
- WSL
- VirtualBox
  - Ubuntu
- Dockerコンテナ
  - ArchLinux
  - Debian

# 最後に
改善案や質問があれば、GitHubの issue や PullRequest、対面にて管理者まで連絡してください。
