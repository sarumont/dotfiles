#!/bin/sh
# Make zsh the login shell (no-op if it already is).
set -eu
zsh_path=$(command -v zsh)
current=$(getent passwd "$(id -un)" 2>/dev/null | cut -d: -f7 || true)
[ -n "$current" ] || current=$(dscl . -read "/Users/$(id -un)" UserShell 2>/dev/null | awk '{print $2}')
[ "$current" = "$zsh_path" ] || chsh -s "$zsh_path"
