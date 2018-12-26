typeset -U path

export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
export MAVEN_ARGS=""

# path prepend
path[1,0]=($HOME/.local/bin $HOME/.my/bin /opt/bin)

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
    $HOME/.dasht/bin
    .)
path=($^path(N))
