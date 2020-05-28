alias vi=$EDITOR
alias vim=$EDITOR
alias viup='vim -c ":PlugUpgrade | :PlugUpdate | :PlugInstall | :PlugClean | :quitall"'

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

# Ubuntu
alias as='apt search'

# general aliases
alias grep='grep --color'
alias ugrep='ps aux | grep $USER | grep '
alias bc='eva'
alias cat='bat'
alias fd='fdfind'

# tree navigation
alias ls='exa --icons'
alias l='ls --git --long'
alias la='ls -al' # note this should also include --git, but there is currently a bug in eva
alias ll='l'
alias ltr='l --sort newest'
alias tree='exa -T'

# suffixes (from OMZ common-aliases)
alias H='| head'
alias T='| tail'
alias G='| grep'
alias L='| less'
alias M='| most'
alias LL=' 2>&1 | less'
alias CA=' 2>&1 | cat -A'
alias NE=' 2> /dev/null'
alias NUL=' > /dev/null 2>&1'

# search
alias ag='rg -S'
alias rg='rg -S'

# SCM
alias update_submodules='git pull --recurse-submodules && git submodule update --recursive'
alias _git_full_log="git log --graph --oneline --decorate"
alias _git_prunable='git branch --merged | grep -v "\*" | egrep -v "(master|develop)"'
alias bump='git commit -m "⬆️"'
alias full_pull='git pull --rebase && git fetch --all --prune && git branch -d `git branch --merged | grep -v "\*" | egrep -v "(master|develop|richard)"`'
alias gcm='git commit -m' # override gcm - git checkout master is useless
alias gprune='git branch -d `git branch --merged | grep -v "\*" | egrep -v "(master|develop|richard)"`'
alias gstl='git stash list --date=relative' # overrides OMZ default
alias gtt='git log -1 --format=%ai '
alias gup='git up' # defer this to ~/gitconfig
alias st='scm_st'

# JDK switching
alias jdk8="sdk use java 8.0.252-zulu"
alias jdk11="sdk use java 20.1.0.r11-grl"

alias certbot='certbot --config-dir ~/.config/letsencrypt --logs-dir ~/tmp --work-dir ~/tmp'

# notes
alias daily='$EDITOR note:`date +%Y-%m-%d` -c ":Writemode"'
alias yesterday='$EDITOR note:`date -v-1d +%Y-%m-%d` -c ":Writemode"'

# music
alias beet='beet --config ~/.local/beets/config.yaml'

# mounts
alias mymounts="tree -L 1 /media/$USER"

# productivity
alias pomodoro="mpc play && at now + 25 minutes <<< 'mpc pause && notify-send -i ~/Dropbox/tomato.png -u normal \"Take a break\"'"
alias super_pom="mpc play && at now + 50 minutes <<< 'mpc pause && notify-send -i ~/Dropbox/tomato.png -u normal \"Take a break\"'"
alias deep_work="mpc play && at now + 90 minutes <<< 'mpc pause && notify-send -i ~/Dropbox/tomato.png -u normal \"Take a break\"'"

if [[ -r ~/.local/sh/aliases.zsh ]]; then
    . ~/.local/sh/aliases.zsh
fi
