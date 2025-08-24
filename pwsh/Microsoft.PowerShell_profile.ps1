# ====================
# oh-my-posh (プロンプト)
# ====================
# インストール (初回のみ)
# winget install JanDeDobbeleer.OhMyPosh -s winget
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\powerlevel10k_rainbow.omp.json" | Invoke-Expression

# ====================
# fzf (PowerShell用設定)
# ====================
# scoop または winget で fzf をインストールしておく
# 例: scoop install fzf
# Ctrl+Rで履歴検索できるようにする
Import-Module PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -HistorySearchCursorMovesToEnd:$true
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory

# ====================
# alias / function
# ====================

# ディレクトリ移動系
Set-Alias c Set-Location
function b { Set-Location .. }

# lsコマンド系
Set-Alias l Get-ChildItem
Set-Alias ll "Get-ChildItem -Force -Detailed"
Set-Alias lr "Get-ChildItem -Recurse"
function LS { Get-ChildItem -Force }
function L { Get-ChildItem -Force }
function LL { Get-ChildItem -Force -Detailed }
function LR { Get-ChildItem -Force -Recurse }

# その他基本系
function wl { Get-Content $args | Measure-Object -Line }
Set-Alias rl Resolve-Path
#Set-Alias rp Resolve-Path
Set-Alias G Select-String
Set-Alias GE Select-String
function zz { & $PROFILE }  # プロファイル再読み込み

# アプリ起動系
function e($path) {
    $resolved = (Resolve-Path -LiteralPath $path).Path
    Start-Process explorer.exe $resolved
}

Set-Alias py python
Set-Alias lltx "lualatex --shell-escape --halt-on-error"
Set-Alias bat "bat -pp"
#Set-Alias nv nvim
Set-Alias tm tmux
Set-Alias em "emacs -nw"
Set-Alias g git
Set-Alias ty typst
function tyw { typst watch $args }
function tyc { typst compile $args }

## conda / mamba 系 (fzf込みはPowerShellではちょっと複雑なので簡略化)
#Set-Alias cac "conda activate"
#Set-Alias cif "conda info -e"
#Set-Alias mac "mamba activate"
#Set-Alias mif "mamba info -e"

# ====================
# 環境変数
# ====================
#$env:PATH = "$HOME\.dotfiles\bin;" + $env:PATH
$env:PATH = "C:\Program Files\VMD;" + $env:PATH
$env:HOME = (Resolve-Path ~).Path

# ====================
# mamba/conda 初期化 (PowerShell用)
# ====================
# 公式の init を使うとよい
# conda init powershell
# mamba init powershell

