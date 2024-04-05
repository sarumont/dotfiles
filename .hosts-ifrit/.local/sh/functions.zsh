update_link_galleries() {
  rm -rf ~/work
  mkdir ~/work
  ln -sf ~/github.com/moovfinancial/* ~/work
  ln -sf ~/github.com/moov-jobs/* ~/work

  rm -rf ~/git
  mkdir ~/git
  ln -sf ~/work/* ~/git
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
