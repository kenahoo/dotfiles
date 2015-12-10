HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
setopt notify
bindkey -e

zstyle :compinstall filename '/home/kwilliams/.zshrc'

autoload -Uz compinit
compinit

unset LS_COLORS

autoload -U colors && colors

antigen bundle git
antigen bundle zsh-users/zsh-completions src
antigen bundle zsh-users/zsh-syntax-highlighting


ME=`hostname`
if [[ "$ME" == 'Ken-MacBook.local' ]]; then
  MCOL=$fg[white]
else
  MCOL=$fg[green]
fi

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '[%F{2}%b%f] '

setopt prompt_subst
precmd () { vcs_info }
PROMPT="[%{$MCOL%}%U%m%u:%B%~%b%{$reset_color%}] \${vcs_info_msg_0_}%# "
PROMPT2="%{$MCOL%}%^> %{$reset_color%}"

REPORTTIME=5

setopt extendedhistory
setopt incappendhistory

bindkey ^W kill-region

#export LC_ALL=C
export PAGER=less
export EDITOR=emacs

for prog in src-hilite-lesspipe.sh ; do
    (( $+commands[$prog] )) || continue
    export LESSOPEN="| $prog %s"
    break
done

export LESS=-eiMqR
export PERL5LIB=~/perl5/lib/perl5
export ACK_OPTIONS=--pager=less


fpath=(~/.zfuncs $fpath)
path[1,0]=$HOME/bin  # Prepend
path+=~/perl5/bin

brewbash=~/perl5/perlbrew/etc/bashrc
[[ -e $brewbash ]] &&
  source $brewbash


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

autoload -U zmv

export GPG_TTY=$(tty)
