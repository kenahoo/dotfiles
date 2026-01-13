HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
setopt notify

# Emacs-like bindings
bindkey -e

# https://github.com/ohmyzsh/ohmyzsh/issues/5642
disable r

zstyle :compinstall filename "$HOME/.zshrc"

unset LS_COLORS
autoload -U colors && colors

ME=`hostname`
if [[ "$ME" == 'Ken-MacBook.local' ]]; then
  MCOL=$fg[white]
else
  MCOL=$fg[green]
fi

autoload -U is-at-least
if is-at-least 4.3.9; then
    autoload -Uz vcs_info
    zstyle ':vcs_info:*' formats '[%F{2}%30>…>%b%>>%f] '

    setopt prompt_subst
    precmd () { vcs_info }
fi

PROMPT="[%{$MCOL%}%U%m%u:%B%~%b%{$reset_color%}] \${vcs_info_msg_0_}%# "
PROMPT2="%{$MCOL%}%^> %{$reset_color%}"

REPORTTIME=5

setopt extendedhistory
setopt incappendhistory

bindkey ^W kill-region

# 'cdr' is better than 'pushd', see http://info2html.sourceforge.net/cgi-bin/info2html-demo/info2html?(zsh)Recent%2520Directories
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs


export PAGER=less
export EDITOR='emacs -nw'

for prog in src-hilite-lesspipe.sh ; do
    (( $+commands[$prog] )) || continue
    export LESSOPEN="| $prog %s"
    break
done

export LESS=-eiMqR

add_paths () {
    if [ -d "$1" ]; then
        path=("$1/bin" "$1/sbin" $path)
    fi
}

add_paths /usr/local
add_paths /opt/homebrew


if type brew &>/dev/null; then
    _brew_home=$(brew --prefix)
    FPATH=$_brew_home/share/zsh-completions:$FPATH

    antigen_file="$_brew_home/share/antigen/antigen.zsh"

    path=("$_brew_home/bin" "$_brew_home/sbin" $path)

    autoload -Uz compinit
    compinit

    if [ -e "$_brew_home/vault" ]; then
        complete -o nospace -C "$_brew_home/vault" vault
    fi

    if [ -e "$_brew_home/opt/asdf/libexec/asdf.sh" ]; then
        . "$_brew_home/opt/asdf/libexec/asdf.sh"
    fi

fi

fpath=(~/.zfunc $fpath)
path[1,0]=$HOME/bin  # Prepend


autoload -Uz compinit
compinit


if [ -f $antigen_file ]; then
    source $antigen_file
    antigen bundle git
    antigen bundle zsh-users/zsh-completions src
    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen apply

    typeset -A ZSH_HIGHLIGHT_STYLES
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=red,bold'
else
    echo "Antigen is not installed"
fi

# Copy $1 to $2/$1, where $1 can include nested directories
replicate () {
    src=$1
    dest=$2
    destdir=$(dirname $2/$1)
    mkdir -p $destdir
    cp -r $src $destdir
}

source ~/.aliases

unsetopt auto_name_dirs
unsetopt auto_pushd
unsetopt pushdminus
setopt   pushd_ignore_dups

autoload -U zmv

export GPG_TTY=$(tty)

if [[ $OSTYPE == darwin* ]]; then
    bindkey "^[[3~" delete-char
fi

autoload -U +X bashcompinit && bashcompinit



# Case insensitive match
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes


if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init - | sed s/precmd/chpwd/g)"
fi

eval "$(mise activate zsh)"
