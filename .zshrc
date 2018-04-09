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
    zstyle ':vcs_info:*' formats '[%F{2}%b%f] '

    setopt prompt_subst
    precmd () { vcs_info }
fi

PROMPT="[%{$MCOL%}%U%m%u:%B%~%b%{$reset_color%}] \${vcs_info_msg_0_}%# "
PROMPT2="%{$MCOL%}%^> %{$reset_color%}"

REPORTTIME=5

setopt extendedhistory
setopt incappendhistory

bindkey ^W kill-region

#export LC_ALL=C
export PAGER=less
export EDITOR='emacs -nw'

for prog in src-hilite-lesspipe.sh ; do
    (( $+commands[$prog] )) || continue
    export LESSOPEN="| $prog %s"
    break
done

export LESS=-eiMqR
export PERL5LIB=~/perl5/lib/perl5
export ACK_OPTIONS=--pager=less


fpath=(~/.zfuncs $fpath)
fpath=(/usr/local/share/zsh-completions $fpath)
path[1,0]=$HOME/bin  # Prepend
path+=~/perl5/bin
path+=~/git/utils/perl
path+=~/git/utils/git
path+=/Developer/NVIDIA/CUDA-8.0/bin
path+=/usr/local/sbin

export DYLD_LIBRARY_PATH="/Developer/NVIDIA/CUDA-8.0/lib:$DYLD_LIBRARY_PATH"

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
setopt   pushd_ignore_dups

autoload -U zmv

export GPG_TTY=$(tty)

if [[ $OSTYPE == darwin* ]]; then
    bindkey "^[[3~" delete-char
    export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
fi
