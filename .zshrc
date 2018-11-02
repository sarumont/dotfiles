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
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.omz-custom

NVM_LAZY_LOAD=true
NVM_AUTO_USE=true

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git common-aliases ssh-agent zsh-nvm zsh-syntax-highlighting) 

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# set custom options
setopt histreduceblanks extendedglob notify dvorak 

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

if [[ -r ~/.local/sh/zshrc ]]; then
    . ~/.local/sh/zshrc
fi

# Source aliases
if [[ -r ~/.aliases.zsh ]]; then
    . ~/.aliases.zsh
fi

# functions
if [[ -r ~/.functions.zsh ]]; then
    . ~/.functions.zsh
fi

[[ -s "${HOME}/.local/sh/iterm2_shell_integration.zsh" ]] && source "${HOME}/.local/sh/iterm2_shell_integration.zsh"

typeset -U fpath

export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"

fpath+=("$HOME/.zfunctions")
autoload -U promptinit; promptinit
prompt pure
#zprof
