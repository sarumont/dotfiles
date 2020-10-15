typeset -U path

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export RIPGREP_CONFIG_PATH=$HOME/.rgrc

export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
export MAVEN_ARGS="-T 1C"

# path prepend
path[1,0]=($HOME/.local/bin $HOME/.my/bin /opt/bin /snap/bin)

# path append
path+=(/sbin /usr/sbin)

# source private shared shit
if [[ -r ~/.privfiles/sh/zshenv ]]; then
    . ~/.privfiles/sh/zshenv
fi

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
    $HOME/go/bin
    .)
path=($^path(N))
