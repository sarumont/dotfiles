# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository using **GNU Stow** for symlink management. The repository is organized into self-contained "packages" (directories) that stow symlinks into `$HOME`. The design supports both shared configuration and host-specific overrides.

## Core Architecture

### Stow-based Package System

Each top-level directory (except `.hosts-*`, `.git`, and hidden directories) is a stow package that mirrors the target directory structure starting from `$HOME`. For example:
- `nvim/.config/nvim/init.lua` → `~/.config/nvim/init.lua`
- `zsh/.zshrc` → `~/.zshrc`
- `tmux/.config/tmux/tmux.conf` → `~/.config/tmux/tmux.conf`

Key packages:
- `nvim/` - Neovim configuration (NvChad-based)
- `zsh/` - Zsh shell configuration with oh-my-zsh
- `tmux/` - tmux configuration with tpm plugins
- `git/` - Global git configuration
- `sway/` - Sway window manager (Linux)
- `alacritty/` - Alacritty terminal emulator
- `local/` - Local scripts and binaries in `.local/bin/`

### Host-Specific Overrides

Host-specific configurations are stored in `.hosts-$(hostname)/` directories. These apply side-by-side with base packages (no file overwriting). The hostname is determined by `uname -n`.

### Local Overrides (Not Committed)

The shell sources these local override files if they exist:
- `~/.local/sh/aliases.zsh` - Local aliases
- `~/.local/sh/functions.zsh` - Local functions
- `~/.local/sh/zshrc` - Additional zshrc configuration
- `~/.local/sh/zshenv` - Environment variables
- `~/.local/sh/*.zshenv` - Additional environment files

Also supports a private overlay repository called `privfiles` for secrets.

## Common Commands

### Stow Management

```bash
# Install/update all symlinks
make

# Install base packages only
make base

# Install host-specific overrides
make host

# Remove all symlinks
make delete

# Remove base package symlinks
make delete-base

# Remove host-specific symlinks
make delete-host
```

The Makefile uses: `stow --verbose --no-folding --target=$HOME`

### Neovim

- Update plugins: `viup` (alias for `nvim --headless "+Lazy! sync" +qa`)
- The configuration uses NvChad v2.5 with lazy.nvim
- Custom plugins are in `nvim/.config/nvim/lua/plugins/*.lua`
- LSP servers configured: `gopls`, `kotlin_language_server`
- Formatters via conform.nvim: `stylua` (Lua), `gofmt`/`goimports`/`goimports-reviser` (Go), `yamlfmt` (YAML)
- Format on save is enabled with async and LSP fallback

### Git

Global git configuration is in `git/.config/git/config`. Local overrides (name, email, signing key) go in `~/.gitconfig`.

Custom git commands in `local/.local/bin/`:
- `git-clean-merged` - Clean up merged branches
- `git-attic` - View deleted branches
- `git-neck` - Show commit graph
- `git-trail` - Show commit history

Useful aliases:
- `gup` → `git up` (fetch + rebase with autostash)
- `full_pull` → Pull with --all --prune --rebase and clean merged branches
- `gprune` → Delete merged branches (except main/master/develop/richard)

### tmux

- Session picker scripts are bound to prefix keys:
  - `C-a C-g` - Pick from `~/git` (symlink gallery)
  - `C-a C-w` - Pick from `~/work` (symlink gallery)
  - `C-a C-o` - Switch between existing sessions
  - `C-a C-b` / `C-a C-B` - Previous session
- `ta` script (`local/.local/bin/ta`) - Attach or create tmux sessions
  - `ta ~/git` - Select and open a project with nvim in split layout
  - `ta --start` - Create simple session in current directory
- Plugins managed via tpm (tmux plugin manager)

### Shell Functions

The `build()` function intelligently detects build systems (Gradle, Maven, Ant, npm, lerna) by walking up the directory tree and runs appropriate commands. Shortcuts:
- `b` - Build
- `c` - Compile
- `cl` - Clean and build
- `bi` - Build install
- `clb` - Clean and build
- `cli` - Clean and install

## Development Workflow

### Symlink Gallery Pattern

The "symlink gallery" pattern creates directories of symlinks to projects for quick tmux navigation. Example from README (intended to be placed in `~/.local/sh/functions.zsh`):

```zsh
update_link_galleries() {
  rm -rf ~/work
  mkdir ~/work
  ln -sf ~/github.com/myorganization/* ~/work

  rm -rf ~/git
  mkdir ~/git
  ln -sf ~/work/* ~/git
}
```

This integrates with tmux keybindings (`C-w` for work gallery, etc.).

### Environment Variables

- `OBSIDIAN_VAULT_DIR` - Set in `~/.local/sh/zshenv` to point to Obsidian vault (defaults to `~/notes`)
- `EDITOR` - Auto-detected (nvim → vim priority)

### Shell Tools

The configuration uses modern CLI replacements:
- `eza` instead of `ls` (aliases: `l`, `ll`, `la`, `ltr`, `tree`)
- `bat` instead of `cat`
- `rg` (ripgrep) instead of `ag`/`grep`
- `eva` instead of `bc`
- `zoxide` for directory jumping (aliased to `cd`)
- `mise` for language version management (activated with shims)

## Notes

- The configuration supports both macOS (MacPorts preferred) and Arch Linux (paru/pacman)
- zsh plugins: OS-specific (macos/archlinux/debian), git, gitfast, httpie, sudo, zsh-syntax-highlighting
- vim mode is enabled in zsh (`bindkey -v`)
- Starship prompt is used
- keychain is used for SSH key management
- direnv is loaded if available
- Docker plugin is lazy-loaded on first use
