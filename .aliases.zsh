unalias rm
unalias mv

alias vi=$EDITOR
alias vim=$EDITOR
alias viup='vim -c ":PlugUpgrade | :PlugUpdate | :PlugInstall | :quitall"'

# job management
alias j='jobs'
alias 1='fg %1'
alias 2='fg %2'
alias 3='fg %3'
alias 4='fg %4'
alias 5='fg %5'
alias 6='fg %6'
alias 7='fg %7'
alias 8='fg %8'
alias 9='fg %9'

# general aliases
alias grep='grep --color'
alias ugrep='ps aux | grep $USER | grep '
alias bc='bc ~/.dotfiles/bcrc'
#alias tmux="tmux -2 -u"
alias _git_full_log="git log --graph --oneline --decorate"
alias _git_prunable='git branch --merged | grep -v "\*" | egrep -v "(master|develop)"'

alias update_submodules='git pull --recurse-submodules && git submodule update --recursive'
alias ag="ag --smart-case"

alias sub_st='for x in `find . -maxdepth 1 -mindepth 1 -type d`; do cd $x; echo $x:; git status -s; cd ..; done'

# SCM
alias bump='git commit -m ":arrow_up:"'
alias full_pull='git pull --rebase && git fetch --all --prune && git branch -d `git branch --merged | grep -v "\*" | egrep -v "(master|develop|richard)"`'
alias gcm='git commit -m' # override gcm - git checkout master is useless
alias gprune='git branch -d `git branch --merged | grep -v "\*" | egrep -v "(master|develop|richard)"`'
alias gstl='git stash list --date=relative' # overrides OMZ default
alias gtt='git log -1 --format=%ai '
alias gup='git up' # defer this to ~/gitconfig
alias st='scm_st'

alias ltr="ls -altr"

alias jdk8="sdk use java 8.0.201-oracle"
alias jdk11="sdk use java 11.0.2-open"

alias certbot='certbot --config-dir ~/.config/letsencrypt --logs-dir ~/tmp --work-dir ~/tmp'

# notes
alias daily='$EDITOR note:`date +%Y-%m-%d`'
alias yesterday='$EDITOR note:`date -v-1d +%Y-%m-%d`'

if [[ -r ~/.local/sh/aliases.zsh ]]; then
    . ~/.local/sh/aliases.zsh
fi
