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


alias e=emacs
alias ls='ls -F'
alias lsl="ls -alF"
alias j=jobs
alias h=history
alias up='tar -zxvf'
alias top="top -u"
alias ql='quicklook -p'

# Git stuff
alias s='git status'
alias d='git diff'
alias l='git lg'
function git_ticket () { git rev-parse --abbrev-ref HEAD | perl -ne 'print m{(?:^|/)([A-Z]+-\d+)} ? qq{$1 } : q{}' }
function c () { x=$(git_ticket); git commit -m "$x$1" }


if [[ "$(uname -s)" =~ "^CYGWIN" ]]; then
    alias open=cygstart
    alias pbcopy=putclip
    alias pbpaste=getclip
elif [[ "$(uname)" == "Darwin" ]]; then
    # Already have it
else
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
fi

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias cds="cd ~/src"
alias cdd="cd ~/Downloads"

alias cpan='perl -MCPAN -e shell'
alias findproc='ps auxww | grep'
alias mac2unix='perl -pi -e "s/\cM/\n/g"'
alias dos2unix='perl -pi -e "s/\cM//g"'
alias pert='perl -a -F/\\t/'

alias R='R_HISTSIZE=10000 R --no-save --no-restore-data --quiet'

hcat  () { hdfs dfs -cat $1 }
hzcat () { hdfs dfs -cat $1 | bzcat }

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
