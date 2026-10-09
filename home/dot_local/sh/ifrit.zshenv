# Inline the current Homebrew shell environment for this host.
# Keep this explicit rather than evaluating `brew shellenv` at startup.
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

# Moov development environment
export GOPRIVATE="github.com/moov-io/*,github.com/moovfinancial/*"
export OBSIDIAN_VAULT_DIR="$HOME/My Drive/notes/moov-second-brain"
export BUMPER_PD_PATH="$HOME/github.com/moovfinancial/platform-dev"
export BUMPER_INFRA_PATH="$HOME/github.com/moovfinancial/infra"
export GCLOUD_HOME="/opt/google-cloud-sdk/"
export GOOGLE_CLOUD_PROJECT="moov-gemini"
