#zmodload zsh/zprof
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="honukai"
ZSH_THEME=""

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=50000
SAVEHIST=50000

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.omz-custom

get_tmux_session_name() {
    tty=$(tty)
    for s in $(tmux list-sessions -F '#{session_name}' 2>/dev/null); do
        tmux list-panes -F '#{pane_tty} #{session_name}' -t "$s"
    done | grep "$tty" | awk '{print $2}'
}
export TMUX_SESSION_NAME=$(get_tmux_session_name)

# lazy load doesn't work with auto use
# export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('vim' 'nvim' 'vi')

OS=""
if [[ -f "/etc/lsb-release" ]]; then
    OS=debian
elif [[ -f "/etc/arch-release" ]]; then 
    OS=archlinux
fi
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    $OS
    docker
    git 
    gitfast
    httpie
    keychain
    kubectl
    sudo
    zsh-nvm 
    zsh-syntax-highlighting
)

zstyle :omz:plugins:keychain agents "ssh"
zstyle :omz:plugins:keychain identities "id_ed25519"

source $ZSH/oh-my-zsh.sh

# set custom options
setopt histreduceblanks hist_ignore_dups hist_ignore_space share_history extendedglob notify dvorak CHASE_LINKS

# vim mode
bindkey -v

# bind lazy loaders for version managers
rvm() {
    if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
        unfunction rvm 
        . "$HOME/.rvm/scripts/rvm" && rvm $@ 
    else
        echo "rvm not installed"
    fi
}

# lazily load k8s completions
kubectl() {
    unfunction kubectl
    KUBECTL=$(which kubectl)
    [[ -x $KUBECTL ]] && source <($KUBECTL completion zsh)
    $KUBECTL $@
}

# lazy Terraform completion
terraform() {
    unfunction terraform
    TF=$(which terraform)
    if [[ -x $TF ]]; then
        autoload -U +X bashcompinit && bashcompinit
        complete -o nospace -C $TF terraform
    fi
    $TF $@
}

vault() {
    unfunction vault
    VAULT=$(which vault)
    if [[ -x $VAULT ]]; then
        autoload -U +X bashcompinit && bashcompinit
        complete -o nospace -C $VAULT vault
    fi
    $VAULT $@
}

if [[ -r ~/.local/sh/zshrc ]]; then
    . ~/.local/sh/zshrc
fi

# Source aliases and functions
. ~/.aliases.zsh
. ~/.functions.zsh

[[ -s "${HOME}/.local/sh/iterm2_shell_integration.zsh" ]] && source "${HOME}/.local/sh/iterm2_shell_integration.zsh"

typeset -U fpath

export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"

fpath+=(
  "$HOME/.zfunctions"
)

# Editor setup
EDITOR=`which nvim`
if [[ $? -ne 0 ]]; then
    EDITOR=`which vim`
fi
export EDITOR
alias vim=$EDITOR
alias vi=$EDITOR

export PG_PAGER="$EDITOR -R -c 'set ft=dbout' -"

eval "$(starship init zsh)"

DIRENV=$(which direnv)
if [[ $? -eq 0 ]]; then
    eval "$($DIRENV hook zsh)"
fi

if [[ -z "$FZF_BASE" && -d "/usr/share/fzf" ]]; then
    export FZF_BASE="/usr/share/fzf"
fi

if [[ -n "$FZF_BASE" ]]; then
    source "$FZF_BASE/completion.zsh" 2> /dev/null
    source "$FZF_BASE/key-bindings.zsh" 2> /dev/null
fi

# zoxide
eval "$(zoxide init --cmd cd zsh)"

#zprof
