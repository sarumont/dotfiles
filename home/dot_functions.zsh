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
        if test -f ${dir}/package.json; then
            cmdBase="npm"
            if test -f ${dir}/lerna.json; then
                cmdBase="npx lerna"
            fi

            if [[ $# -eq 0 ]]; then
                cmd="${cmdBase} run build"
            elif [[ $# -eq 1 ]]; then
                cmd="${cmdBase} run $@"
            else
                cmd='echo "'${cmdBase}' '$@'"'
                for target in $@; do
                    cmd="${cmd} && ${cmdBase} run ${target}"
                done
            fi
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
clb() {
    cl build $@
}
cli() {
    cl install $@
}
clp() {
    cl package $@
}

fetch_gh_latest() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: $0 <user/repo>"
        return 1
    fi
    curl -L $(curl --silent "https://api.github.com/repos/$1/releases/latest" | jq -r '.assets[] | select(.browser_download_url | contains("linux")) | .browser_download_url') | tar zx
}

# machine-specific: <host>.functions.zsh is managed, functions.zsh is local-only
for f in ~/.local/sh/*.functions.zsh(N); do
    . $f
done

if [[ -r ~/.local/sh/functions.zsh ]]; then
    . ~/.local/sh/functions.zsh
fi
