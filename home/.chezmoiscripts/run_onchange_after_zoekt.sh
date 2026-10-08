#!/bin/sh
# Install Zoekt into pi's bin dir (on PATH via .zshenv). Updates: sysup.
set -eu
. "$HOME/.local/sh/dirs.env"
export PATH="$HOME/.local/share/mise/shims:$PATH"
command -v go >/dev/null 2>&1 || { echo "go not found; skipping zoekt" >&2; exit 0; }
GOBIN="$PI_BIN_DIR" go install \
  github.com/sourcegraph/zoekt/cmd/zoekt@latest \
  github.com/sourcegraph/zoekt/cmd/zoekt-git-index@latest \
  github.com/sourcegraph/zoekt/cmd/zoekt-local-sync@latest
