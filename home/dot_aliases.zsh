# editor aliases
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
alias cat='bat'

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
alias JQ='| jq'
alias LL=' 2>&1 | less'
alias NE=' 2> /dev/null'
alias NUL=' > /dev/null 2>&1'

# suffix aliases
alias -s md=bat
alias -s txt=bat
alias -s json=bat
alias -s go=$EDITOR
alias -s yaml=$EDITOR

# tumx
alias tkill="for s in \$(tmux list-sessions | awk '{print \$1}' | sed s/:\$// | fzf); do echo \$s; tmux kill-session -t \$s; done;"

# Git
alias full_pull='git pull --all --prune --rebase && git branch -d `git branch --merged | grep -v "\*" | grep -E -v "(main|master|develop|richard)"`'
alias gcm='git commit -m' 
alias glg='git log --stat --show-signature'
alias gstl='git stash list --date=relative' # overrides OMZ default
alias gprune='git branch -d `git branch --merged | grep -v "\*" | egrep -v "(main|master|develop|richard)"`'
alias gtt='git log -1 --format=%ai '
alias gup='git up' # defer this to ~/gitconfig
alias st='git status'

# AI tooling
alias gibr='uvx gibr'  # no Python env to manage
alias claude='claude --enable-auto-mode'

if [[ -r ~/.privfiles/sh/aliases.zsh ]]; then
    . ~/.privfiles/sh/aliases.zsh
fi

# machine-specific: <host>.aliases.zsh is managed, aliases.zsh is local-only
for f in ~/.local/sh/*.aliases.zsh(N); do
    . $f
done

if [[ -r ~/.local/sh/aliases.zsh ]]; then
    . ~/.local/sh/aliases.zsh
fi
