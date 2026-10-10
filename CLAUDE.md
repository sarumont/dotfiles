# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed with **chezmoi**. The source state is in `home/`
(`.chezmoiroot`); this checkout (`~/github.com/sarumont/dotfiles`, also
`~/git/dotfiles` via the gallery) is chezmoi's `sourceDir`. Repos live at
`$REPO_ROOT/<owner>/<repo>` (`~/github.com/...`, cloned with `ghq get`).
chezmoi **copies** files into `$HOME` (no symlinks), so a source edit does
nothing until `chezmoi apply`, and a live-file edit must be brought back with
`chezmoi re-add` (plain files) or `chezmoi merge` (templates).

Targets: **shiva** (Omarchy, Linux), **ifrit** (work MacBook, Homebrew for
managed packages), and plain Arch. Per-machine data comes from `home/.chezmoi.toml.tmpl`
(answers cached in `~/.config/chezmoi/chezmoi.toml`): `.omarchy` (auto-detected),
`.desktop` (GUI machine; always true on Omarchy/macOS, false on servers like
dadfi — gate GUI apps/config on it), `.dev` (agents/toolchains; gate them on
`or .desktop .dev` — true on the jarvis dev VM), `.personal`, `.name`, `.email`, `.secrets` (`protonpass` | `1password` | `none`), plus
`.chezmoi.os` and `.chezmoi.hostname`.

`README.md` is the user-facing setup guide and reference; `docs/todo.md` holds
open items. The stow → chezmoi migration log (`MIGRATION.md`) lives in git
history.

## Layout and conventions

- chezmoi naming: `dot_` → `.`, `private_` → mode 0600/0700, `executable_`,
  `.tmpl` → Go template, `modify_` → script that merges into an existing file
  (stdin → stdout), `run_once_` / `run_onchange_` scripts in
  `home/.chezmoiscripts/`.
- Gating: whole paths per OS/host/Omarchy in `home/.chezmoiignore`; sections
  inside templates with `{{ if eq .chezmoi.os "darwin" }}`, `{{ if .omarchy }}`,
  `{{ if eq .chezmoi.hostname "shiva" }}`.
- Host-specific files are named per host: `~/.local/sh/<host>.{zshenv,aliases.zsh,functions.zsh}`,
  `~/.local/sh/dirs-<host>.env`, `~/.config/tmux/tmux.<host>.conf`.
  Unprefixed `~/.local/sh/{zshenv,zshrc,zlogin,aliases.zsh,functions.zsh}` and
  `~/.config/tmux/tmux.local.conf` are deliberately **unmanaged** local overrides.
- Data files: `home/.chezmoidata/packages.yaml` (package lists per OS),
  `herdr.yaml` (herdr plugins), `secrets.yaml` (secret **references**, not
  secrets).
- Externals (`home/.chezmoiexternal.toml.tmpl`): tpm (all), oh-my-zsh (macOS
  only; Linux uses the `oh-my-zsh-git` package).
- System files outside `$HOME` live in `system/` (e.g. `system/etc/keyd/`) and
  are installed by `run_onchange_` scripts that `include` them by
  `.chezmoi.workingTree` path.
- Maintenance: `~/.local/bin/sysup` (system → drift gate → `chezmoi update` →
  tools → validation). Drift = first column of `chezmoi status`; an Omarchy
  `post-update.d` hook reports it after migrations.
- Docs: `docs/nvim-keymaps.md`, `docs/tmux.md`.

## Rules

- **Never put secrets in this repo** (public), encrypted or not. Use the
  `secret` template (`home/.chezmoitemplates/secret`) with a reference in
  `secrets.yaml`, or an app's own credential store. When inspecting secret
  items (`pass-cli`, `op`), print only an allowlist of non-secret fields
  (ids, titles, field names); never print values. Every target rendered with
  the `secret` helper must also be listed in the secrets block of
  `home/.chezmoiignore`, so it's skipped (not failed) when the backend has no
  session.
- **Omarchy-owned files**: don't manage files Omarchy regenerates or symlinks
  (e.g. `~/.config/nvim/lua/plugins/theme.lua`, `~/.local/state/omarchy/*`).
  For files both an app and these dotfiles write (pi `settings.json`), use a
  `modify_` script that merges only our keys with `jq`. Ghostty's font family on
  Omarchy is rendered from `omarchy-font-current` so `omarchy-font-set` causes no
  drift. Only customized Hyprland files are managed. Never edit
  `/usr/share/omarchy/` (reading is fine).
- **Packages**: Linux uses `yay` (never `paru`). Things Omarchy already ships go
  in `arch_only`, not `linux`. Language runtimes and agent CLIs come from mise
  (`~/.config/mise/config.toml`, templated: workstation tools are
  desktop-only), not curl installers that edit shell rc files; add tools in
  the template, never with `mise use -g`.
  Python CLIs run via `uvx` (e.g. `gibr`, `codemod`).
- **Changes outside `$HOME`** (systemd, `/etc`, groups) must be recorded in the
  README table "Machine changes outside `$HOME`", automated in a script where
  possible.
- Workflow per change: edit source → `chezmoi diff` → `chezmoi apply <path>` →
  verify → commit (commits are SSH-signed) → push.

## Common commands

```bash
chezmoi status / diff / apply [path] / managed / data
chezmoi add [--template] <path>        # start managing a file
chezmoi re-add <path>                  # pull a live edit back (plain files)
chezmoi merge <path>                   # pull a live edit back (templates)
chezmoi execute-template < file.tmpl   # render a template (add --override-data '{...}' to test other OSes/hosts)
chezmoi cat <target>                   # rendered content for this machine
chezmoi state delete-bucket --bucket=entryState   # re-run run_onchange_ scripts
```

Validation after changes:
- Hyprland: `hyprctl reload && hyprctl configerrors`
- herdr: `herdr server reload-config` (look for empty `diagnostics`)
- tmux: start a throwaway server (`tmux -L test -f ~/.config/tmux/tmux.conf new -d`)
  and check `show-messages`; never touch the user's running sessions
- Neovim: headless runs need `doautocmd User VeryLazy` before checking keymaps
- zsh: `zsh -n` on rendered files, `zsh -i -c exit` for errors

## Notable pieces

- **zsh** + oh-my-zsh; `.zshenv` adds Omarchy's bash-only env on Omarchy;
  `.zshrc` ports some Omarchy helpers (`ff`, `eff`, `open`, `mup`, herdr layouts
  via `emulate ksh`). `build()` detects Gradle/Maven/Ant/npm.
- **Neovim**: LazyVim, leader `,`; extras in `lazyvim.json`, overrides in
  `lua/plugins/`, keymaps in `lua/config/keymaps.lua` (see docs).
- **tmux** (tpm) and **herdr** (plugins via data file) both in daily use;
  helper scripts in `~/.local/bin` (`ta`, `twt`, `herdr-*`, `tmux-*`).
- **Git**: config template with SSH signing; `allowed_signers` lists all
  machines' keys; custom commands `git-attic`, `git-clean-merged`, `git-neck`,
  `git-trail`.
- **Agents**: `~/AGENTS.md` shared; `CLAUDE.md`/`AGENTS.md` for Claude Code and
  Codex; pi and Claude Code settings merged via `jq` (`modify_`); Zoekt installed into `$PI_BIN_DIR`.
