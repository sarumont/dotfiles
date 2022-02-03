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
alias ag='rg'

# SCM
alias update_submodules='git pull --recurse-submodules && git submodule update --recursive'
alias _git_full_log="git log --graph --oneline --decorate"
alias _git_prunable='git branch --merged | grep -v "\*" | egrep -v "(main|master|develop)"'
alias bump='git commit -m "⬆️"'
alias full_pull='git pull --all --prune --rebase && git branch -d `git branch --merged | grep -v "\*" | egrep -v "(main|master|develop|richard)"`'

# OMZ overrides
alias gcm='git commit -m' 
alias glg='git log --stat --show-signature'
alias gstl='git stash list --date=relative' # overrides OMZ default

alias gprune='git branch -d `git branch --merged | grep -v "\*" | egrep -v "(main|master|develop|richard)"`'
alias gtt='git log -1 --format=%ai '
alias gup='git up' # defer this to ~/gitconfig
alias st='scm_st'

# JDK switching
alias jdk8="sdk use java 8.0.262-zulu"
alias jdk11="sdk use java 20.1.0.r11-grl"

alias certbot='certbot --config-dir ~/.config/letsencrypt --logs-dir ~/tmp --work-dir ~/tmp'

# lerna
alias bootstrap='npx lerna exec npm i && npx lerna bootstrap'

# notes
alias daily='$EDITOR note:`date +%Y-%m-%d` -c ":Writemode"'
alias yesterday='$EDITOR note:`date -v-1d +%Y-%m-%d` -c ":Writemode"'

# music
alias beet="$(which beet) --config ~/.local/beets/config.yaml"

# mounts
alias mymounts="tree -L 1 /media/$USER"

# productivity
alias pomodoro="playerctl play && at now + 25 minutes <<< 'playerctl pause && notify-send -i ~/.my/misc/tomato.png -u normal \"Take a break and do some burpees\"'"
alias super_pom="playerctl play && at now + 50 minutes <<< 'playerctl pause && notify-send -i ~/.my/misc/tomato.png -u normal \"Take a break and do some burpees\"'"
alias deep_work="playerctl play && at now + 90 minutes <<< 'playerctl pause && notify-send -i ~/.my/misc/tomato.png -u normal \"Take a break and do some burpees\"'"

if [[ -r ~/.local/sh/aliases.zsh ]]; then
    . ~/.local/sh/aliases.zsh
fi
