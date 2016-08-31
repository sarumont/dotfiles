# Gets the number of commits ahead from remote
function git_remote_prompt() {
  if $(command git rev-parse --abbrev-ref --symbolic-full-name @{u} > /dev/null 2>&1); then
    local COMMITS="$(git rev-list --count @{upstream}..HEAD)"
    if [[ $COMMITS -ne 0 ]]; then
        echo -n "$ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX$COMMITS$ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX"
    fi
    COMMITS="$(git rev-list --count HEAD..@{upstream})"
    if [[ $COMMITS -ne 0 ]]; then
        echo -n "$ZSH_THEME_GIT_COMMITS_BEHIND_PREFIX$COMMITS$ZSH_THEME_GIT_COMMITS_BEHIND_SUFFIX"
    fi
  fi
}
