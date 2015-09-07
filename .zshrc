# LANG
export LANG=ja_JP.UTF-8
export LC_CTYPE=$LANG
export LESSCHARSET=utf-8

# Emacs ライクな操作を有効にする（文字入力中に Ctrl-F,B でカーソル移動など）
# Vi ライクな操作が好みであれば `bindkey -v` とする
bindkey -e

# PATH設定
# - 重複パスを登録しない
typeset -U path sudo_path cdpath fpath manpath
# - sudo用のpathを設定
typeset -xT SUDO_PATH sudo_path
sudo_path=({/usr/local,/usr,}/sbin(N-/))
# - pathを設定
path=(
  {$HOME,/usr/local,/usr,}/bin(N-/)
  ${sudo_path}
  $(brew --prefix coreutils)/libexec/gnubin
  /Applications/MAMP/bin/php/php5.6.6/bin
  $HOME/.nodebrew/current/bin
  $HOME/Develop/adt-bundle-mac-x86_64-20140702/sdk/tools
  $HOME/Develop/adt-bundle-mac-x86_64-20140702/sdk/platform-tools
)
# - manpathを設定
manpath=( {usr/locaal,/usr,/opt/X11}/share/man(N-/) )

# rbenv, pyenv, plenv の設定
eval "$(rbenv init -)"
eval "$(pyenv init -)"
eval "$(plenv init -)"

# JAVA_HOMEの設定
JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

# ANDROID_HOMEの設定
export ANDROID_HOME="$HOME/Develop/adt-bundle-mac-x86_64-20140702/sdk"

# プロンプトの設定
PROMPT="[%n@%m]$ "
PROMPT2="> "
SPROMPT="%r is correct? [n,y,a,e]: "
#RPROMPT='[`rprompt-git-current-branch`%F{cyan}%~%f]'
RPROMPT="[%d]"
RPROMPT2="%K{green}%_%k"
# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst
## 入力が右端まで来たらRPROMPTを消す
setopt transient_rprompt

# 自動補完機能を強化する
fpath=(/usr/local/share/zsh-completions(N-/) $fpath)

# 自動補完を有効にする
# コマンドの引数やパス名を途中まで入力して <Tab> を押すといい感じに補完してくれる
# 例： `cd path/to/<Tab>`, `ls -<Tab>`
autoload -Uz compinit; compinit -u

# 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリに cd する
# 例： /usr/bin と入力すると /usr/bin ディレクトリに移動
setopt auto_cd

# pagerの設定
if type lv >/dev/null 2>&1; then
  ## lvを優先
  export PAGER='lv'
else
  ## lvがなかったらlessを使用
  export PAGER='less'
fi
#
if [[ "$PAGER" = 'lv' ]]; then
  ## -c: ANSIエスケープシーケンスの色付け等を有効にする
  ## -l: 1行が長く折り返されていても1行として扱う
  ##     （コピーした時に余計な改行を入れない）
  export LV='-c -l'
else
  ## lvがなくてもlvでページャーを起動する
  alias lv="$PAGER"
fi

# ↑を設定すると、 .. とだけ入力したら1つ上のディレクトリに移動できるので……
# 2つ上、3つ上にも移動できるようにする
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# "~hoge" が特定のパス名に展開されるようにする（ブックマークのようなもの）
# 例： cd ~hoge と入力すると /long/path/to/hogehoge ディレクトリに移動
hash -d hoge=/long/path/to/hogehoge

# cd した先のディレクトリをディレクトリスタックに追加する
# ディレクトリスタックとは今までに行ったディレクトリの履歴のこと
# `cd +<Tab>` でディレクトリの履歴が表示され、そこに移動できる
# setopt auto_pushd
# ---> plugin cdr を使用
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 200
zstyle ':chpwd:*' recent-dirs-default true

# pushd したとき、ディレクトリがすでにスタックに含まれていればスタックに追加しない
setopt pushd_ignore_dups

# 拡張 glob を有効にする
# glob とはパス名にマッチするワイルドカードパターンのこと
# （たとえば `mv hoge.* ~/dir` における "*"）
# 拡張 glob を有効にすると # ~ ^ もパターンとして扱われる
# どういう意味を持つかは `man zshexpn` の FILENAME GENERATION を参照
setopt extended_glob

# コマンド履歴
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# 入力したコマンドがすでにコマンド履歴に含まれる場合、履歴から古いほうのコマンドを削除する
# コマンド履歴とは今まで入力したコマンドの一覧のことで、上下キーでたどれる
setopt hist_ignore_all_dups

# コマンドがスペースで始まる場合、コマンド履歴に追加しない
# 例： <Space>echo hello と入力
setopt hist_ignore_space

# 履歴のインクリメンタル検索
bindkey '^r' history-incremental-pattern-search-backward
bindkey '^s' history-incremental-pattern-search-forward

# 入力済み文字列を利用して履歴検索する
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
bindkey '^o' history-beginning-search-backward-end

# <Tab> でパス名の補完候補を表示したあと、
# 続けて <Tab> を押すと候補からパス名を選択できるようになる
# 候補を選ぶには <Tab> か Ctrl-N,B,F,P
zstyle ':completion:*:default' menu select=1

# コマンドラインの色付け
#   plugin : zsh-syntax-highlighting
[[ -f $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] \
  && source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# 単語の一部として扱われる文字のセットを指定する
# ここではデフォルトのセットから / を抜いたものとする
# こうすると、 Ctrl-W でカーソル前の1単語を削除したとき、 / までで削除が止まる
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# 複数ファイル名を一括でリネームできるようにする
autoload -Uz zmv

# バージョン管理システムのリポジトリ情報を表示する
#autoload -Uz add-zsh-hook
#autoload -Uz vcs_info
#zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
#zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'
#function _update_vcs_info_msg() {
#  LANG=en_UFT-8 vcs_info
#  RPROMPT="${vcs_info_msg_0_}"
#}
#add-zsh-hook precmd _update_vcs_info_msg

# ^D で zsh を終了しない
#setopt IGNORE_EOF


# オプション一覧の出力を分かりやすくする関数
function showoptions() {
  set -o | sed -e 's/^no\(.*\)on$/\1  off/' -e 's/^no\(.*\)off$/\1  on/'
}


# ^Q/^S のフローコントロールを無効にする
setopt NO_FLOW_CONTROL

# beep 音を鳴らさない
setopt NO_BEEP

# rbenvの設定
export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init - zsh)"
#export CC=/usr/bin/gcc-4.2

# エイリアスの設定
alias -g A='| head'
alias -g Z='| tail'
alias -g T="| tee"
alias -g N='> /dev/null'
alias -g G="| grep"
alias -g L="|& $PAGER"
alias -g WC="| wc"
alias -g LC="| wc -l"
alias -g V='| vim -R -'
alias -g P=' --help | less'

# enable color support of ls and also add handy aliases
if [[ -x $(brew --prefix coreutils)/libexec/gnubin/dircolors ]]; then
  test -r ~/.dir_colors && eval "$(dircolors -b ~/.dir_colors)" || eval "$(dircolors -b)"
  alias ls='gls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias ls='ls -F'
alias la='ls -a'
alias ll='ls -l'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

alias zmv='noglob zmv -W'
alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias gvim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim -g "$@"'
alias ifspcd01='ssh hiroshi@ifspcd01.local.ifsys.jp -p 19622 -i /Users/hiroshi/.ssh/id_ras_ifsys'
alias ifsnas01='ssh hiroshi@ifsnas01.local.ifsys.jp -p 29622 -i /Users/hiroshi/.ssh/id_ras_ifsys'
alias ifsfgd01='ssh hiroshi@ifsfgd01.local.ifsys.jp -p 19622 -i /Users/hiroshi/.ssh/id_ras_ifsys'
alias ifsubd01='ssh hiroshi@ifsubd01.local.ifsys.jp -p 19622 -i /Users/hiroshi/.ssh/id_ras_ifsys'
alias ifsubd02='ssh hiroshi@ifsubd02.local.ifsys.jp -p 19622 -i /Users/hiroshi/.ssh/id_ras_ifsys'
alias ifsubd03='ssh hiroshi@ifsubd03.local.ifsys.jp -p 19622 -i /Users/hiroshi/.ssh/id_ras_ifsys'
alias ifsced01='ssh hiroshi@ifsced01.local.ifsys.jp -p 19622 -i /Users/hiroshi/.ssh/id_ras_ifsys'
alias ifsxrd01='ssh ifsys@s236.xrea.com -i /Users/hiroshi/.ssh/id_ras_ifsys'
alias readlink='greadlink'
alias awk='gawk'
alias sed='gsed'
alias date='gdate'
alias wol_ifspcd01='wolcmd c86000021281 192.168.174.21 255.255.255.0 19622'
alias firefox-dev='/Applications/Firefox.app/Contents/MacOS/firefox -no-remote -P dev-test01 &'

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### gems 用設定
export GEM_HOME=~/.gem
