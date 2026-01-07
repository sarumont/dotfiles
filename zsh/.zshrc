#zmodload zsh/zprof

# Path to oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# OMZ config
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=50000
SAVEHIST=50000
ZSH_CUSTOM=$HOME/.omz-custom

# tweak compinit/compaudit
ZSH_DISABLE_COMPFIX="true"
ZSH_COMPDUMP="${ZSH_CACHE_DIR:-$ZSH/cache}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

# set TMUX session name
if [[ -n "$TMUX" ]]; then
  export TMUX_SESSION_NAME=$(tmux display-message -p '#S')
fi

# I either have macOS, Arch, or a Debian-based system at this point in my life
OS=macos
COPY=pbcopy
if [[ -f "/etc/lsb-release" ]]; then
  OS=debian
  COPY=wl-copy
elif [[ -f "/etc/arch-release" ]]; then 
  OS=archlinux
  COPY=wl-copy
fi

plugins=(
  $OS
  git
  gitfast
  sudo
  zsh-syntax-highlighting
)

typeset -U fpath
fpath+=(
  "$HOME/.zfunctions"
)

source $ZSH/oh-my-zsh.sh

# set custom options
setopt histreduceblanks hist_ignore_dups hist_ignore_space share_history extendedglob notify dvorak CHASE_LINKS

# vim mode
bindkey -v

# copy current command to clipboard
copy-command() {
  echo -n $BUFFER | $COPY
  zle -M "copied to clipboard"
}
zle -N copy-command
bindkey 'c' copy-command

if [[ -r ~/.local/sh/zshrc ]]; then
  . ~/.local/sh/zshrc
fi

# Source aliases and functions
. ~/.aliases.zsh
. ~/.functions.zsh

[[ -s "${HOME}/.local/sh/iterm2_shell_integration.zsh" ]] && source "${HOME}/.local/sh/iterm2_shell_integration.zsh"

# Editor setup
if command -v nvim &> /dev/null; then
  export EDITOR=nvim
elif command -v vim &> /dev/null; then
  export EDITOR=vim
fi
alias vim=$EDITOR
alias vi=$EDITOR

export PG_PAGER="$EDITOR -R -c 'set ft=dbout' -"

# Starship
_starship_cache="${XDG_CACHE_HOME:-$HOME/.cache}/starship-init.zsh"
if [[ ! -f "$_starship_cache" ]] || [[ $(command -v starship) -nt "$_starship_cache" ]]; then
  starship init zsh > "$_starship_cache"
fi
source "$_starship_cache"

# zoxide
_zoxide_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zoxide-init.zsh"
if [[ ! -f "$_zoxide_cache" ]] || [[ $(command -v zoxide) -nt "$_zoxide_cache" ]]; then
  zoxide init --cmd cd zsh > "$_zoxide_cache"
fi
source "$_zoxide_cache"

# direnv
if command -v direnv &> /dev/null; then
  _direnv_hook_cache="${XDG_CACHE_HOME:-$HOME/.cache}/direnv-hook.zsh"
  if [[ ! -f "$_direnv_hook_cache" ]] || [[ $(command -v direnv) -nt "$_direnv_hook_cache" ]]; then
    direnv hook zsh > "$_direnv_hook_cache"
  fi
  source "$_direnv_hook_cache"

fi

# fzf
if [[ -z "$FZF_BASE" && -d "/usr/share/fzf" ]]; then
  export FZF_BASE="/usr/share/fzf"
fi
if [[ -n "$FZF_BASE" ]]; then
  source "$FZF_BASE/completion.zsh" 2> /dev/null
  source "$FZF_BASE/key-bindings.zsh" 2> /dev/null
fi

# Lazy-loading
docker() {
  unfunction docker
  source ~/.oh-my-zsh/plugins/docker/docker.plugin.zsh
  docker "$@"
}

eval "$(mise activate zsh)"

# Keychain
if [[ ! -S ~/.ssh/ssh_auth_sock ]] && [[ -z "$SSH_AGENT_PID" ]]; then
  # First shell - run keychain
  eval $(keychain --eval --quick --quiet id_ed25519)
else
  # Subsequent shells - just source the cache
  [[ -f ~/.keychain/${HOST}-sh ]] && source ~/.keychain/${HOST}-sh
fi

zprof_on_prompt() {
  zprof
  unset -f zprof_on_prompt
  precmd_functions=("${(@)precmd_functions:#zprof_on_prompt}")
}
#precmd_functions+=(zprof_on_prompt)
