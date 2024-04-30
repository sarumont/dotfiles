# editor aliases
alias vi=$EDITOR
alias vim=$EDITOR
alias viup='nvim --headless "+Lazy! sync" +qa'

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
alias bc='eva'
alias cat='bat'
#alias cd='cd -P' # cd to physical location, not symlink

# tree navigation
alias ls='eza --icons'
alias l='ls --git --long'
alias la='ls -al' # note this should also include --git, but there is currently a bug in eva
alias ll='l'
alias ltr='l --sort newest'
alias tree='eza -T'

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
alias full_pull='git pull --all --prune --rebase && git branch -d `git branch --merged | grep -v "\*" | grep -E -v "(main|master|develop|richard)"`'

# OMZ overrides (mostly git)
alias gcm='git commit -m' 
alias glg='git log --stat --show-signature'
alias gstl='git stash list --date=relative' # overrides OMZ default

alias gprune='git branch -d `git branch --merged | grep -v "\*" | egrep -v "(main|master|develop|richard)"`'
alias gtt='git log -1 --format=%ai '
alias gup='git up' # defer this to ~/gitconfig
alias st='scm_st'

# NPM / lerna
alias bootstrap='npx lerna exec npm i && npx lerna bootstrap'
alias scrubadubdub='rm -rf package-lock.json node_modules && npm i'

# notes
alias daily='$EDITOR note:`date +%Y-%m-%d` -c ":Writemode"'
alias yesterday='$EDITOR note:`date -v-1d +%Y-%m-%d` -c ":Writemode"'

# music
alias beet="$(which beet) --config ~/.local/beets/config.yaml"

# mounts
alias mymounts="tree -L 1 /media/$USER"

# productivity
alias pomodoro="playerctl play && at now + 25 minutes <<< 'playerctl pause && notify-send -i ~/Drive/misc/tomato.png -u normal \"Take a break and do some burpees\"'"
alias super_pom="playerctl play && at now + 50 minutes <<< 'playerctl pause && notify-send -i ~/Drive/misc/tomato.png -u normal \"Take a break and do some burpees\"'"
alias deep_work="playerctl play && at now + 90 minutes <<< 'playerctl pause && notify-send -i ~/Drive/misc/tomato.png -u normal \"Take a break and do some burpees\"'"

# Sway visor terminal size and position
alias visor_adj="swaymsg resize set 100 ppt 80 ppt && swaymsg move absolute position 0 30"

# tumx
alias tkill="for s in \$(tmux list-sessions | awk '{print \$1}' | sed s/:\$// | fzf); do echo \$s; tmux kill-session -t \$s; done;"

if [[ -r ~/.privfiles/sh/aliases.zsh ]]; then
    . ~/.privfiles/sh/aliases.zsh
fi

if [[ -r ~/.local/sh/aliases.zsh ]]; then
    . ~/.local/sh/aliases.zsh
fi
