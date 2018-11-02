typeset -U path

DEFAULT_USER=(sarumont richard)
export $DEFAULT_USER
export EDITOR=`which vim`
export PG_PAGER="vim -R -c 'set ft=dbout' -"
export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
export MAVEN_ARGS="-T 1C"

# path prepend
path[1,0]=($HOME/.local/bin $HOME/.dotfiles/bin /opt/bin)

# path append
path+=(/sbin /usr/sbin)

# source machine-specific code
if [[ -r ~/.local/sh/zshenv ]]; then
    . ~/.local/sh/zshenv
fi

# these will always be set in the local if they exist - and '.' is always at the end
path+=(
    $ANDROID_HOME/platform-tools
    $ANDROID_HOME/tools
    $HEROKU_HOME/bin
    $HOME/.rvm/bin
    .)
path=($^path(N))