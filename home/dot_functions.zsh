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

# Rebuild the symlink galleries from $REPO_ROOT/<owner>/* (dirs.env):
# $WORK_GALLERY_DIR gets $WORK_GALLERY_OWNERS; $REPO_GALLERY_DIR gets the work
# gallery plus $REPO_GALLERY_OWNERS; twt worktrees are re-linked.
update_link_galleries() {
  : "${WORK_GALLERY_DIR:?}" "${REPO_GALLERY_DIR:?}" "${REPO_ROOT:?}"
  local owner wt gallery
  local -a repos

  rm -rf "$WORK_GALLERY_DIR" "$REPO_GALLERY_DIR"
  mkdir -p "$WORK_GALLERY_DIR" "$REPO_GALLERY_DIR"

  for owner in ${=WORK_GALLERY_OWNERS}; do
    repos=("$REPO_ROOT/$owner"/*(N))
    (( $#repos )) && ln -sf "${repos[@]}" "$WORK_GALLERY_DIR"
  done

  repos=("$WORK_GALLERY_DIR"/*(N))
  (( $#repos )) && ln -sf "${repos[@]}" "$REPO_GALLERY_DIR"
  for owner in ${=REPO_GALLERY_OWNERS}; do
    repos=("$REPO_ROOT/$owner"/*(N))
    (( $#repos )) && ln -sf "${repos[@]}" "$REPO_GALLERY_DIR"
  done

  # Re-link worktrees created by twt
  if [[ -d "$WORKTREES_DIR" ]]; then
    for wt in "$WORKTREES_DIR"/*/(N); do
      [[ -f "${wt}.twt-galleries" ]] || continue
      while IFS= read -r gallery; do
        ln -sf "$wt" "$gallery/$(basename "$wt")"
      done < "${wt}.twt-galleries"
    done
  fi
}

# machine-specific: <host>.functions.zsh is managed, functions.zsh is local-only
for f in ~/.local/sh/*.functions.zsh(N); do
    . $f
done

if [[ -r ~/.local/sh/functions.zsh ]]; then
    . ~/.local/sh/functions.zsh
fi
