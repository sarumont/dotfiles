track_lengths() {
    for x in *.flac; do 
        metaflac --show-total-samples --show-sample-rate $x |\
            tr '\n' ' ' |\
            awk '{print $1/$2}' |\
            awk '{printf int($1/60) ":%02.0f\n", $1%60 }'
    done
}

# run git status or svn status as apropriate
scm_st() {
    dir=`pwd`
    cmd='echo "Could not find SCM repository"'
    until test -z $dir; do
        if test -d ${dir}/.svn; then
            cmd="svn status"
            break
        fi
        if test -d ${dir}/.git; then
            cmd="git status"
            break
        fi
        dir=${dir%/*}
    done
    eval $cmd
}

git_svn_version() {
    if [[ -d .svn ]]; then
        echo `command svnversion`
    else
        base=`git svn info | grep "Last Changed Rev" | awk '{print $4}'`
        mod=`(git st | grep "modified:\|added:\|deleted:" -q) && echo "M"`
        echo $base$mod
    fi
}

all() {
    case $1 in 
        status)
            GIT_CMD="git status"
            SVN_CMD="svn status"
            ;;
        pull)
            GIT_CMD="git pull --rebase"
            SVN_CMD="svn up"
            ;;
        push)
            GIT_CMD="git push"
            SVN_CMD=""
            ;;
        full)
            GIT_CMD="git fetch --all --prune && git pull --rebase"
            SVN_CMD=""
            ;;
        *)
            echo "Unknown command: $1"
            return 1
    esac

    for x in $(command ls -d */); do 
        cd $x
        echo "\n$fg[blue]$x:\e[0m"
        if [[ -d .git ]]; then 
            eval $GIT_CMD
        elif [[ -d .svn ]]; then
            eval $SVN_CMD
        else
            echo "No supported SCM detected"
        fi
        cd ..
    done
}

build() {
    dir=`pwd`
    cmd='echo "Could not find buildfile"'
    until test -z $dir; do
        if test -f ${dir}/build.gradle; then
            cmd="gradle -b ${dir}/build.gradle -p ${dir} $GRADLE_ARGS $@"
            break
        fi
        if test -f ${dir}/settings.gradle; then
            cmd="gradle -c ${dir}/settings.gradle -p ${dir} $GRADLE_ARGS $@"
            break
        fi
        if test -f ${dir}/build.xml; then
            cmd="ant -f ${dir}/build.xml $ANT_ARGS $@"
            break
        fi
        if test -f ${dir}/pom.xml; then
            cmd="mvn -f ${dir}/pom.xml $MAVEN_ARGS $@"
            break
        fi
        dir=${dir%/*}
    done
    eval $cmd
}

b() {
    build $@
}
cl() {
    target=''
    if [[ $# -gt 0 ]]; then
        target=$1
        shift
    fi
    build clean $@
    build $target $@
}
c() {
    build compile
}
bi() {
    build install $@
}
cli() {
    cl install $@
}
clp() {
    cl package $@
}

set_version() {
    mvn versions:set -DgenerateBackupPoms=false -DnewVersion=$1
}

go_light() {
    echo "set background=light" > ~/.config/nvim/bg.vim
    cat $HOME/.config/termite/config.base $HOME/.config/termite/config.light > $HOME/.config/termite/config
}

go_dark() {
    echo "set background=dark" > ~/.config/nvim/bg.vim
    cat $HOME/.config/termite/config.base $HOME/.config/termite/config.dark > $HOME/.config/termite/config
}

if [[ -r ~/.local/sh/functions.zsh ]]; then
    . ~/.local/sh/functions.zsh
fi
