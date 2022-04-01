typeset -U path

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export RIPGREP_CONFIG_PATH=$HOME/.rgrc

export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
export MAVEN_ARGS="-T 1C"

export GPG_TTY=$(tty)

export MOZ_ENABLE_WAYLAND=1

# path prepend
path[1,0]=(
    $HOME/.local/bin
    $HOME/.my/bin 
    /sbin
    /usr/sbin
    /opt/bin 
    /opt/local/bin
    /opt/local/sbin
    /snap/bin
)

# source private shared shit
if [[ -r ~/.privfiles/sh/zshenv ]]; then
    . ~/.privfiles/sh/zshenv
fi

for f in ~/.privfiles/sh/*.zshenv(N); do
    . $f
done

# source machine-specific code
if [[ -r ~/.local/sh/zshenv ]]; then
    . ~/.local/sh/zshenv
fi

for f in ~/.local/sh/*.zshenv(N); do
    . $f
done

# path append
# FOO_HOME will always be set in .local if they exist
# and '.' is always at the end
path+=(
    $ANDROID_HOME/platform-tools
    $ANDROID_HOME/tools
    $HEROKU_HOME/bin
    $HOME/.rvm/bin
    $HOME/.dasht/bin
    $HOME/go/bin
    .)
path=($^path(N))
