update_link_galleries() {
  rm -rf "$WORK_GALLERY_DIR"
  mkdir "$WORK_GALLERY_DIR"
  ln -sf $REPO_ROOT/moovfinancial/* $WORK_GALLERY_DIR
  ln -sf $REPO_ROOT/moov-jobs/* $WORK_GALLERY_DIR
  ln -sf $REPO_ROOT/moov-io/* $WORK_GALLERY_DIR

  rm -rf "$REPO_GALLERY_DIR"
  mkdir "$REPO_GALLERY_DIR"
  ln -sf "$WORK_GALLERY_DIR"/* "$REPO_GALLERY_DIR"
  ln -sf $REPO_ROOT/sarumont/* "$REPO_GALLERY_DIR"

  # Re-link worktrees created by twt
  if [[ -d "$WORKTREES_DIR" ]]; then
    for wt in "$WORKTREES_DIR"/*/; do
      [[ -f "${wt}.twt-galleries" ]] || continue
      while IFS= read -r gallery; do
        ln -sf "$wt" "$gallery/$(basename "$wt")"
      done < "${wt}.twt-galleries"
    done
  fi
}

moov() {
  stack=moov-${2}-apps
  pod=$3
  case "$1" in
    help)
      echo "usage: moov <command> <stack> <pod|run ID>"
      echo "\ncommands:"
      echo "\tlogin:\tlog into spacelift"
      echo "\tsc:\tconfirm spacectl stack run"
      echo "\tsrl:\tlist spacectl stack runs"
      echo "\tsll:\ttail latest spacectl stack run logs"
      echo "\tgp:\tget pod"
      echo "\trr:\trollout restart deployment"
      echo "\tdelp:\tdelete pod"
      return 0
      ;;
    login)
      spacectl profile login
      return 0
      ;;
    sc)
      if [[ -z "$pod" ]]; then
        echo "run must be provided"
        return 1
      fi
      spacectl stack confirm --id $stack --run $pod
      return 0
      ;;
    srl)
      spacectl stack run list --id $stack --max-results 10
      return 0
      ;;
    sll)
      spacectl stack logs --id $stack --run $(spacectl stack run list --id $stack -o json --max-results 1 | jq -r '.[] | .id')
      return 0
      ;;
    gp) 
      cmd="get"
      ;;
    rr)
      cmd="rollout-restart"
      ;;
    delp)
      cmd="delete-pod"
      ;;
    *) 
      echo "unknown command: $1"
      return 1
      ;;
  esac

  if [[ -z "$stack" || -z "$pod" ]]; then
    echo "stack or pod must be provided"
    return 1
  fi

  echo "--------------------------------------"
  echo "executing $cmd on $pod in stack $stack"
  echo "--------------------------------------"
  spacectl stack task --id $stack --tail "/mnt/workspace/source/scripts/kubectl-deployment.sh $cmd $pod"
}

moov_setup() {
  PROJECT=$(docker ps --filter "label=com.docker.compose.project" --format "{{.Label \"com.docker.compose.project\"}}" | sort -u)
  CURRENT=$(basename $(pwd))
  if [ ! -z "$PROJECT" ]; then
    if [[ $CURRENT != $PROJECT ]]; then
      echo "Bringing down project: $PROJECT"
      CURDIR=$(pwd)
      cd ../$PROJECT
      make teardown
      cd $CURDIR
    else
      echo "$CURRENT already set up"
      return 0
    fi
  fi
  echo "Setting up $CURRENT"
  make setup
}
