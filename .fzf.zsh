# Setup fzf
# ---------
if [[ ! "$PATH" == */home/sarumont/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/sarumont/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/sarumont/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/sarumont/.fzf/shell/key-bindings.zsh"
