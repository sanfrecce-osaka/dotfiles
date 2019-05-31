# -------------------------------------
# 環境変数
# -------------------------------------

# SSHで接続した先で日本語が使えるようにする
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# エディタ
export EDITOR='vim'

# ページャ
export PAGER='lv -c'
export MANPAGER=/usr/local/bin/vimpager

# mysql
export PATH=$PATH:/usr/local/mysql/bin

# Node.js
export PATH=$PATH:/Users/moritsukamasatoshi/.nodebrew/current/bin

# -------------------------------------
# zshのオプション
# -------------------------------------

## 補完機能の強化
autoload -U compinit
compinit

## 入力しているコマンド名が間違っている場合にもしかして：を出す。
setopt correct

# ビープを鳴らさない
setopt nobeep

## 色を使う
setopt prompt_subst

## ^Dでログアウトしない。
setopt ignoreeof

## バックグラウンドジョブが終了したらすぐに知らせる。
setopt no_tify

## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups

# 補完
## タブによるファイルの順番切り替えをしない
unsetopt auto_menu

# cd -[tab]で過去のディレクトリにひとっ飛びできるようにする
setopt auto_pushd

# ディレクトリ名を入力するだけでcdできるようにする
setopt auto_cd

# -------------------------------------
# パス
# -------------------------------------

# 重複する要素を自動的に削除
typeset -U path cdpath fpath manpath

path=(
    $HOME/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    $path
)

# -------------------------------------
# プロンプト
# -------------------------------------

autoload -U promptinit; promptinit
autoload -Uz colors; colors
autoload -Uz vcs_info
autoload -Uz is-at-least

# begin VCS
zstyle ":vcs_info:*" enable git svn hg bzr
zstyle ":vcs_info:*" formats "(%s)-[%b]"
zstyle ":vcs_info:*" actionformats "(%s)-[%b|%a]"
zstyle ":vcs_info:(svn|bzr):*" branchformat "%b:r%r"
zstyle ":vcs_info:bzr:*" use-simple true

zstyle ":vcs_info:*" max-exports 6

if is-at-least 4.3.10; then
    zstyle ":vcs_info:git:*" check-for-changes true # commitしていないのをチェック
    zstyle ":vcs_info:git:*" stagedstr "<S>"
    zstyle ":vcs_info:git:*" unstagedstr "<U>"
    zstyle ":vcs_info:git:*" formats "(%b) %c%u"
    zstyle ":vcs_info:git:*" actionformats "(%s)-[%b|%a] %c%u"
fi

function vcs_prompt_info() {
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && echo -n " %{$fg[yellow]%}$vcs_info_msg_0_%f"
}
# end VCS

OK="^_^ "
NG="X_X "

PROMPT=""
PROMPT+="%(?.%F{green}$OK%f.%F{red}$NG%f) "
PROMPT+="%F{blue}%~%f"
PROMPT+="\$(vcs_prompt_info)"
PROMPT+="
"
PROMPT+="%% "

RPROMPT="[%*]"

# -------------------------------------
# エイリアス
# -------------------------------------

# -n 行数表示, -I バイナリファイル無視, svn関係のファイルを無視
alias grep="grep --color -n -I --exclude='*.svn-*' --exclude='entries' --exclude='*/cache/*'"

# cd
alias c="cd"
alias cpro="cd ~/projects"

# ls
alias ls="ls -G" # color for darwin
alias l="ls -la"
alias la="ls -la"
alias l1="ls -1"

# tree
alias tree="tree -NC" # N: 文字化け対策, C:色をつける

# bundler
alias be="bundle exec"
alias bi="bundle install"
alias biv="bundle install --path vendor/bundle"
alias bu="bundle update"

# rails g
alias rg="rails g"
alias rgmo="rails g model"
alias rgc="rails g controller"
alias rgmi="rails g migration"
alias rgma="rails g mailer"

# rails d
alias rd="rails d"
alias rdmo="rails d model"
alias rdc="rails d controller"
alias rdmi="rails d migration"
alias rdma="rails d mailer"

# rails db
alias dbcr="rails db:create"
alias dbrb="rails db:rollback"
alias dbmi="rails db:migrate"
alias dbsu="rails db:setup"
alias dbre="rails db:reset"
alias dbse="rails db:seed"

# rubocop
alias cop="rubocop"
alias copa="rubocop -a"

# docker
alias d="docker"
alias dp="docker ps"
alias dc="docker-compose"
alias dcu="docker-compose up"
alias dcd="docker-compose down"
alias dcp="docker-compose ps"

# git
alias gc="git commit"
alias gca="git commit --amend"
alias gce="git commit --allow-empty"
alias gr="git rebase"
alias gri="git rebase -i"
alias grc="git rebase --continue"
alias gra="git rebase --abort"
alias grs="git reset --soft"
alias grm="git reset --mixed"
alias grh="git reset --hard"

# reload
alias r="source ~/.zshrc"

# -------------------------------------
# キーバインド
# -------------------------------------

bindkey -e

function cdup() {
   echo
   cd ..
   zle reset-prompt
}
zle -N cdup
bindkey '^K' cdup

bindkey "^R" history-incremental-search-backward

# -------------------------------------
# その他
# -------------------------------------

# cdしたあとで、自動的に ls する
function chpwd() { ls -1 }

# iTerm2のタブ名を変更する
function title {
    echo -ne "\033]0;"$*"\007"
}
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
eval "$(direnv hook zsh)"

# カレントディレクトリの変更で自動的にNode.jsのバージョンを変える
function chpwd_node_version() {
  if [ -e ".node-version" ]; then
    version=`cat .node-version`
    nodebrew use $version
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd chpwd_node_version
