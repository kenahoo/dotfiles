HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
setopt notify
bindkey -e

# https://github.com/ohmyzsh/ohmyzsh/issues/5642
disable r

zstyle :compinstall filename '/home/kwilliams/.zshrc'

autoload -Uz compinit
compinit

unset LS_COLORS

autoload -U colors && colors

antigen_file=/usr/local/share/antigen/antigen.zsh
if [[ -f $antigen_file ]]; then
    source $antigen_file
    antigen bundle git
    antigen bundle zsh-users/zsh-completions src
    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen apply
fi

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


#export LC_ALL=C
export PAGER=less
export EDITOR='emacs -nw'

for prog in src-hilite-lesspipe.sh ; do
    (( $+commands[$prog] )) || continue
    export LESSOPEN="| $prog %s"
    break
done

export LESS=-eiMqR

fpath=(~/.zfuncs $fpath)
fpath=(/usr/local/share/zsh-completions $fpath)
path[1,0]=$HOME/bin  # Prepend

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
    export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
fi

autoload -U +X bashcompinit && bashcompinit

complete -o nospace -C /usr/local/bin/vault vault


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
