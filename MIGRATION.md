# Migration plan: stow → chezmoi

Status: **draft**. Every module below has a decision point. Nothing moves until
the decision for that module is recorded in its `Decision:` line.

Decision vocabulary used throughout:

| Code | Meaning |
|---|---|
| **KEEP** | Migrate as-is from this repo |
| **DISCARD** | Delete from the repo (history keeps it) |
| **MERGE** | Combine repo version with the live `~/.config` version on shiva (`chezmoi merge`) |
| **ADOPT** | Take the live version on shiva wholesale (`chezmoi add`), drop the repo version |
| **GATE** | Keep, but only apply on some OS/host (`darwin`, `omarchy`, `arch`, or a hostname) |
| **OTHER** | Free-form, write it in |

Targets: `darwin` (ifrit, work MBP), `omarchy` (shiva), `arch` (generic Arch, no Omarchy).

---

## Phase 0 — Repo and git cleanup

### 0.1 Facts

- Current default branch: `stow` (local + `origin/HEAD`). 1168 commits.
- Remote branches besides `stow`:
  - `origin/master` (tip `d4f47e1`) — the pre-stow layout. Last commit
    2024-08-01, 5 commits not in `stow`, 189 behind.
  - `origin/05-07-demo_cbb197b2_add_user_search`, `..._add_server_api`,
    `..._add_frontend_for_search` — 2026-05-07, 3 commits touching only
    `graphite-demo/{frontend.jsx,server.js}`. A Graphite demo stack, unrelated
    to dotfiles.
- Existing tags: `legacy` (`90320ca`, 2018-10-11, 720 commits behind
  `master`'s tip) and `goodbye_xorg`.
- **Done 2026-10-07:** `archive/master` (→ `d4f47e1`) and `archive/stow`
  (→ `7f63106`) created and pushed; `main` created from `stow` and set as the
  GitHub default; `master` and the `05-07-demo_*` branches deleted on the
  remote. `stow` stays until Phase 4.
- Pack size 43 MiB. Biggest blobs in history: `.config/aacs/KEYDB.cfg` (24 MB,
  still tracked), old binaries `.my/bin/{btsync,mikogo,yq3,starship}` and
  `bin/btsync` (long gone from the tree).
- Not stowed today (hidden dirs, skipped by `make`'s `*/` glob): `.config/`,
  `.macos/`, `.nvim-nvchad/`, `.hosts-*/` (the last two via separate targets).
- `.hosts-shiva` tracks a file inside `node_modules`
  (`.pi/agent/npm/node_modules/pi-herdr-subagents/config.json`).

### 0.2 Branch plan

```sh
cd ~/Work/dotfiles
git fetch --all --prune

# Preserve both tips before touching anything (annotated, so they carry a date/reason)
git tag -a archive/master origin/master -m "Final tip of master (pre-stow layout)"
git tag -a archive/stow   origin/stow   -m "Final tip of stow before chezmoi migration"
git push origin archive/master archive/stow
git ls-remote --tags origin 'archive/*'   # verify both are on the remote

# New default branch, starting from stow so history is kept
git switch -c main stow
git push -u origin main
```

Then switch the GitHub default branch to `main` (web UI → Settings → Branches,
or `gh repo edit --default-branch main` after `gh auth login`), and:

```sh
git remote set-head origin -a
# Once main is default and the Mac is moved over:
git push origin --delete stow
git push origin --delete master
```

- [x] Decision: new branch name — **`main`**
- [x] Decision: `master` — pre-stow variety. **Archive the tip as
      `archive/master`, then delete the branch.**
- [x] Decision: `stow` — **archive the tip as `archive/stow`, delete the branch
      after cutover** (Phase 4, once the Mac is on chezmoi).
- [x] Decision: `05-07-demo_*` branches (Graphite demo) — **delete without
      archiving.**

### 0.3 Deferred: history rewrite

**Decision: not now.** Kept here in case repo size becomes a problem later.

Purge `KEYDB.cfg` and the old `bin/`/`.my/bin/` binaries with `git filter-repo`
(roughly 43 MiB → a few MiB). **Rewrites every SHA**: the Mac clone must be
re-cloned, any forks/links to commits break, tags must be re-pushed with force.

```sh
# on a fresh mirror clone, not the working copy
git clone --mirror git@github.com:sarumont/dotfiles.git dotfiles-mirror
cd dotfiles-mirror
git filter-repo --path .config/aacs/KEYDB.cfg --path .my/bin --path bin --invert-paths
git push --force --mirror
```

If done after cutover, it also needs: re-push the `archive/*` tags (their SHAs
change too), and a fresh clone on both shiva and ifrit.

### 0.4 Repo layout under chezmoi

Use `.chezmoiroot` so repo-level files stay out of `$HOME`:

```
dotfiles/
├── .chezmoiroot            # contains: home
├── README.md               # rewritten: bootstrap + conventions only
├── CLAUDE.md               # updated for chezmoi
├── LICENSE
├── MIGRATION.md            # this file; delete when done
└── home/                   # chezmoi source state
    ├── .chezmoi.toml.tmpl  # per-machine data (prompts once on init)
    ├── .chezmoiignore      # OS/host gating
    ├── .chezmoiexternal.toml
    ├── .chezmoidata/packages.yaml
    ├── .chezmoiscripts/    # run_once_/run_onchange_ hooks
    ├── dot_zshrc, dot_config/..., dot_local/...
```

Use `git mv` for each file so `git log --follow` keeps per-file history. The
existing `home/` stow package gets moved into the new `home/` as part of module
M13 — do that one first or rename it out of the way.

Point chezmoi at the working copy instead of `~/.local/share/chezmoi`:

```toml
# ~/.config/chezmoi/chezmoi.toml (generated from .chezmoi.toml.tmpl)
sourceDir = "~/Work/dotfiles"
```

- [ ] Decision: repo location — `~/Work/dotfiles` via `sourceDir` (recommended,
      matches today) / default `~/.local/share/chezmoi`
- [ ] Decision: source subdir name — `home` / other: ___

### 0.5 Per-machine data (`.chezmoi.toml.tmpl`)

```gotemplate
{{- $omarchy := stat "/usr/share/omarchy" | not | not -}}
{{- $personal := promptBoolOnce . "personal" "Personal machine (Proton Pass, music, etc.)" -}}
sourceDir = "~/Work/dotfiles"

[data]
  omarchy  = {{ $omarchy }}
  personal = {{ $personal }}
  email    = {{ promptStringOnce . "email" "Git email" | quote }}

[diff]
  pager = "delta"   # or omit
```

`.chezmoi.os` (`darwin`/`linux`) and `.chezmoi.hostname` come for free.

- [ ] Decision: data flags — `omarchy`, `personal`, `email` / add more: ___

---

## Phase 1 — Tooling on shiva

```sh
sudo pacman -S chezmoi
# Proton Pass CLI (pass-cli): install per Proton's docs, then
pass-cli login
chezmoi init --source ~/Work/dotfiles   # renders .chezmoi.toml.tmpl
chezmoi doctor
```

Workflow for every module below: `git mv` into `home/` → adjust names/templates
→ `chezmoi diff` → resolve per decision (`chezmoi merge <file>` for MERGE,
`chezmoi add <file>` for ADOPT) → `chezmoi apply <path>` → commit.

- [x] Decision: AUR helper — **`yay` everywhere on Linux** (Omarchy's default).
      Every committed Arch/Omarchy instruction, README or chezmoi script, uses
      `yay`; generic Arch bootstraps `yay` instead of `paru`.
- [x] Installed on shiva: chezmoi 2.72.1 (`extra`), `proton-pass-cli-bin`
      2.4.2 (AUR); `pass-cli login` done.
- [x] Decision: macOS package manager — **ifrit uses both MacPorts and
      Homebrew; support both for now.** The package bootstrap needs a `port`
      list and a `brew` list on darwin.
  - **Deferred:** full migration to Homebrew only. Revisit after cutover.

---

## Phase 2 — Modules

Each module: what exists, what's live on shiva, recommendation, decision.

### M1. zsh (`zsh/`)

- Repo: `.zshrc`, `.zshenv`, `.zlogin`, `.aliases.zsh`, `.functions.zsh`,
  `.omz-custom/mygit.zsh`. Local overrides via `~/.local/sh/*`.
- Shiva: zsh installed and is the login shell; **oh-my-zsh not installed**.
- **Omarchy gotcha:** Omarchy's environment (`OMARCHY_PATH`, `EDITOR`,
  `BROWSER`, `MANPAGER`, `~/.local/bin` on PATH, locale fix) lives in
  `/usr/share/omarchy/default/bash/{env-bootstrap,envs}`, which only bash
  sources. zsh needs an `{{ if .omarchy }}` block that sources `env-bootstrap`
  and sets the pieces of `envs` you want. Omarchy aliases/functions in
  `default/bash/{aliases,functions}` are worth reviewing for anything to port.
- Dependencies → hooks:
  - oh-my-zsh, zsh-syntax-highlighting → `.chezmoiexternal.toml` (`git-repo`,
    refreshed weekly). Replaces the README `curl | sh` step.
  - `chsh` → `run_once_` script that checks `$SHELL` first.
- Sub-decisions:
  - [ ] **keychain** — not needed on shiva (no agent in use; see M2). On
        macOS, `ssh-agent` plus `UseKeychain yes`/`AddKeysToAgent yes` in
        `~/.ssh/config` covers it if ifrit's key has a passphrase →
        DISCARD everywhere (recommended) / GATE darwin
  - [ ] `GPG_TTY` export in `.zshenv` — DISCARD (gpg no longer used)
  - [ ] **direnv** — install + keep / DISCARD (mise can do env per dir)
  - [ ] **eva** (bc replacement) — install / DISCARD (Omarchy ships `omacalc`)
  - [ ] OMZ plugin list — drop `debian`; `archlinux` gated to Linux, `macos` to darwin
  - [ ] oh-my-zsh itself — KEEP / replace with a lighter plugin manager (later, separate change)
  - [ ] iTerm2 integration line — DISCARD (Ghostty on Mac?) / KEEP
  - [ ] `build()` and its shortcuts (Gradle/Maven/Ant/lerna) — still used?
- [ ] **Decision (M1):** ___

### M2. git — DONE

- [x] MERGE of repo config + Omarchy-written `~/.config/git/config` →
      `home/dot_config/git/config.tmpl`. Conflicts resolved:
      `init.defaultBranch = main`, `tag.sort = version:refname` (oldest first).
      Dropped: `pr` alias (use `gup` / `full_pull`), `push.default = simple`
      (git default), duplicate `[commit]`, `core.excludesfile`.
- [x] Signing: `user.signingkey` = `~/.ssh/id_ed25519.pub` (same filename on
      ifrit); `~/.config/git/allowed_signers` generated from it.
- [x] `gitignore` → `~/.config/git/ignore.tmpl` (git's default path); macOS
      patterns gated to darwin; add host blocks as needed.
- [x] README: SSH key + `gh` registration (auth + signing) comes first; the
      `url.insteadOf` SSH rewrite stays.
- Applied on shiva; difftastic installed; signed test commit verified. Shiva key is registered on GitHub for auth + signing.
- SSH agent finding: none is in use. `id_ed25519` has no passphrase, so ssh
  and git signing read it directly. `gpg-agent-ssh.socket` listens only
  because Arch's `gnupg` enables its user sockets globally; nothing sets
  `SSH_AUTH_SOCK` to it. (A probe during M2 started gpg-agent and created
  `~/.gnupg` with a YubiKey stub; to be removed.) GPG/smartcard keys are no
  longer used: one key per machine instead.

### M3. tmux (`tmux/`, `.hosts-*/.config/tmux/tmux.local.conf`)

- Repo: `tmux.conf`, `tmux.linux.conf`, `tmux.macos.conf`, host-local files.
  Plugins via tpm (`tmux-sensible`, `vim-tmux-navigator`, `tmux-yank`,
  `tmux-fpp`, `tmux-fastcopy`).
- Shiva: Omarchy wrote `~/.config/tmux/tmux.conf`; tpm not installed.
- Recommendation: decide first whether tmux is still primary now that herdr
  (M4) is. If kept: tpm → `.chezmoiexternal.toml`; plugin install →
  `run_onchange_` (`~/.config/tmux/plugins/tpm/bin/install_plugins`);
  `tmux.linux.conf`/`tmux.macos.conf` + host files → one template or keep the
  `source-file` pattern with OS-gated files.
- [ ] Is tmux still used day to day, or herdr only? ___
- [ ] **Decision (M3):** KEEP / MERGE / ADOPT / DISCARD

### M4. herdr (`herdr/`)

- Repo `config.toml` vs Omarchy-written `~/.config/herdr/config.toml` (Omarchy
  ships herdr by default).
- README steps → hooks:
  - `herdr plugin install bojackduy/nvim-herdr-navigation/herdr-vim-navigator`
    and `herdr plugin install nathan-poncet/herdr-fingers` →
    `run_onchange_after_herdr-plugins.sh` (needs Rust: add to mise).
  - `herdr server reload-config` → same script, guarded by "server running".
- [ ] **Decision (M4):** MERGE (recommended) / KEEP / ADOPT

### M5. Neovim (`nvim/`, `.nvim-nvchad/`)

- Repo `nvim/`: NvChad 2.5 config. `.nvim-nvchad/`: an older NvChad copy
  (has `configs/*.lua` the current one dropped) — stale.
- Shiva: LazyVim from the `omarchy-nvim` package. Omarchy theme switching
  drives the nvim colorscheme through LazyVim; NvChad loses that.
- Hooks: `nvim --headless "+Lazy! sync" +qa` → `run_onchange_after_` keyed on
  the hash of `lazy-lock.json` (track the lockfile if you aren't).
  Formatters/LSPs (`stylua`, `yamlfmt`, `gopls`, `kotlin-language-server`,
  `go`, `silicon`) → package list or Mason.
- [ ] `.nvim-nvchad/` — DISCARD (recommended)
- [ ] **Decision (M5):** KEEP NvChad everywhere / ADOPT LazyVim (port your
      plugins/mappings onto it) / GATE (LazyVim on Omarchy, NvChad on Mac — not
      recommended, two configs to maintain)

### M6. Starship (`starship/`)

- Repo `starship.toml` vs Omarchy-written `~/.config/starship.toml` (768 bytes).
- [ ] **Decision (M6):** KEEP / MERGE / ADOPT

### M7. Terminals (`ghostty/`, `.macos/.config/ghostty/config-macos`, `alacritty/`)

- Shiva: Omarchy's default terminal is **foot** (`xdg-terminal-exec`). Configs
  exist for alacritty, ghostty, kitty, foot; only **foot** is installed.
- Omarchy themes write terminal colors into per-terminal includes; any config
  you keep for an Omarchy terminal must keep those include lines.
- Ghostty on the Mac: `.macos/` overlay → template with `{{ if eq .chezmoi.os "darwin" }}`
  or a darwin-gated `config-macos` include.
- [ ] Linux terminal — foot (Omarchy default) / ghostty / alacritty / kitty
- [ ] `alacritty/` (onenord themes) — DISCARD (recommended) / KEEP
- [ ] **Decision (M7):** ___

### M8. Hyprland + Omarchy user config (new, nothing in repo yet)

- Shiva: `~/.config/hypr/*.lua` (bindings, input, monitors, looknfeel,
  autostart), `~/.config/omarchy/` (themes, hooks, extensions, `shell.json`).
- Recommendation: ADOPT the files you've changed or will change, GATE
  `omarchy`. `monitors.lua` is per host → host-gated or templated.
- [ ] Which files to track: bindings / input / looknfeel / autostart /
      monitors / omarchy hooks / omarchy themes / all of `~/.config/hypr`
- [ ] **Decision (M8):** ___

### M9. Sway stack (`sway/`, `waybar/`, `systemd/` sway units, `.hosts-steamdeck`)

- `sway/` (sway, swaylock, wofi, gammastep), `waybar/` (incl.
  `style.old.css`), `systemd/` `sway-session.target`, `swaybg.service`,
  `swayidle.service` (`.hosts-steamdeck` is already DISCARD per M17).
- None installed. Omarchy replaces all of it (Hyprland, quickshell,
  hyprsunset, hyprlock/idle). No current host runs sway.
- [ ] Will any future generic-Arch machine run sway? ___
- [ ] **Decision (M9):** DISCARD (recommended) / GATE `arch`

### M10. macOS window managers (`aerospace/`, `omniwm/`)

- Both macOS only. `omniwm` has recent commits; is `aerospace` still used?
- [ ] **Decision (M10):** GATE darwin both / GATE darwin omniwm + DISCARD aerospace

### M11. kanata (`kanata/`, `systemd/kanata.service`)

- Not installed on shiva. Needs the `input` group (README group step).
- [ ] **Decision (M11):** KEEP everywhere / GATE / DISCARD

### M12. Audio and music (`audio/`, root `.config/{beets,mpd,ncmpcpp,pipewire}`, `systemd/{mpd,playerctld}.service`)

- easyeffects presets + IRS files, beets config (×2 copies; the mesafi/yuffie
  host copies are DISCARD per M17), mpd, ncmpcpp,
  pipewire drop-in, mpd/playerctld user units. Nothing installed on shiva.
  Omarchy ships `mpv-mpris`; `playerctld` may be unnecessary.
- [ ] Still using easyeffects? beets? mpd/ncmpcpp? ___
- [ ] **Decision (M12):** GATE `personal` / DISCARD parts: ___

### M13. Small home files (`home/`) — DONE

| File | Decision | Result |
|---|---|---|
| `.bcrc` | DISCARD | removed |
| `.myclirc` | DISCARD | removed |
| `.psqlrc` | DISCARD | removed |
| `.rgrc` | KEEP, moved | `~/.config/ripgrep/config` (template; `--ignore-file` needs an absolute path). `RIPGREP_CONFIG_PATH` in `zsh/.zshenv` updated |
| `.rgignore` | KEEP, moved | `~/.config/ripgrep/ignore`, loaded via `--ignore-file`. Now applies to every search, not just under `~` |
| `AGENTS.md` | KEEP | `~/AGENTS.md` (pulled in by `~/.claude/CLAUDE.md`) |
| `gitignore` | KEEP as-is | `~/gitignore`, still referenced by `core.excludesfile`. Revisit in M2 |

Applied on shiva and verified (`rg` honors the ignore file and `--hidden`).

### M14. Scripts (`local/.local/bin`, `local/.local/sh/dirs.env`, `local/.local/misc`)

Proposed triage (confirm or override each):

| Likely KEEP | Likely DISCARD (sway/X11-era or stale) | Ask |
|---|---|---|
| `git-attic`, `git-clean-merged`, `git-neck`, `git-trail` | `reload_xsettings`, `set_dpi`, `display_switch`, `screen_it.sh`, `visor` | `theme` (clashes with Omarchy theming?) |
| `herdr-*` (8 scripts) | `256colors2.pl`, `lsiommu.sh` | `beersmith`, `batch_scan`, `split2flac` |
| `ta`, `tmux_attach`, `tmux-right-status`, `tmux-session-label` (if M3 keeps tmux) | `add_javadoc_docset`, `slackpost` | `devterm`, `get_profile`, `get_session_type` |
| `pi-maintenance`, `chlog`, `rgb_to_hex`, `timepoint` | | `twt`, `eds-query.py` |

- `dirs.env` + `dirs-<host>.env` → KEEP; host files become host-gated.
- Mark executables with the `executable_` prefix.
- [ ] **Decision (M14):** ___

### M15. AI agents (`claude/`, `codex/`, `pi/`, `.hosts-{shiva,ifrit}/.pi`)

- `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.pi/agent/{settings.json,
  extensions/review-loop.ts, skills/zoekt/SKILL.md}`.
- Shiva conflict: `~/.pi/agent/settings.json` already exists.
- The tracked `node_modules/.../pi-herdr-subagents/config.json` → move to a
  template or a `run_onchange_` that writes it after `npm install`.
- `.hosts-ifrit/.local/bin/pi` wrapper → GATE ifrit.
- Zoekt install (`go install …zoekt…`) → `run_onchange_` script; indexing stays
  a manual or periodic command, not a chezmoi hook.
- [ ] **Decision (M15):** ___

### M16. Root `.config/` (never stowed)

| Path | Notes | Recommendation |
|---|---|---|
| `aacs/KEYDB.cfg` | 24 MB, public Blu-ray key DB | DISCARD; if needed, `.chezmoiexternal` download from its source |
| `emoji-keyboard.json` | | ask |
| `libinput-gestures.conf` | Hyprland has native gestures | DISCARD |
| `parcellite/` | clipboard manager, Omarchy has its own | DISCARD |
| `mako/` | not installed; Omarchy uses quickshell notifications | DISCARD |
| `fontconfig/conf.d/{15-custom,69-aliases}.conf` | Omarchy has its own fontconfig | MERGE or DISCARD |
| `pgcli/`, `http-prompt/` | not installed | ask |
| `spicy/` | SPICE client | ask |
| `beets/`, `mpd/`, `ncmpcpp/`, `pipewire/` | see M12 | M12 |

- [ ] **Decision (M16):** per row

### M17. Host overlays (`.hosts-*`)

**Only two hosts are managed: `shiva` (Omarchy) and `ifrit` (work MBP).**

| Host | Contents | Decision |
|---|---|---|
| shiva | tmux local, `dirs-shiva.env`, `zshenv`, pi npm config | migrate, gated to shiva |
| ifrit (work Mac) | tmux local, `pi` wrapper, aliases, functions, `zshenv` (Homebrew), `dirs-ifrit.env` | migrate, gated to ifrit |
| mesafi | beets config | **DISCARD** (not in use) |
| yuffie | beets config | **DISCARD** (not in use) |
| steamdeck | sway `legion_go.config` | **DISCARD** (not in use) |

Mechanism: files live in the normal tree and get gated in `.chezmoiignore`
with `{{ if ne .chezmoi.hostname "ifrit" }}…{{ end }}`, or are merged into
templates where they only differ by a few lines.

With only one host per OS, `.chezmoi.os` (or `.omarchy`) and the hostname say
the same thing. Prefer OS/omarchy gating for portable config and hostname
gating only for truly machine-specific values (paths, monitors).

- [x] **Decision (M17):** keep shiva + ifrit; DISCARD mesafi, yuffie, steamdeck.
- [ ] Sub-decision: shiva/ifrit content — keep as host-gated files / fold into
      OS-conditional templates (decide per file during migration)

### M18. privfiles

- Separate private stow overlay today.
- Options: (a) secrets → Proton Pass template functions (`protonPass`,
  `protonPassJSON`, `protonPassAttachment`), with share/item IDs kept in the
  local `chezmoi.toml`, not the repo; (b) private non-secret config → pull
  privfiles in with `.chezmoiexternal.toml` (type `git-repo` over SSH, gated
  `personal`); (c) both.
- [ ] What's in privfiles today? ___
- [ ] **Decision (M18):** a / b / c

---

## Phase 3 — README → chezmoi hooks

| README step | New home | Notes |
|---|---|---|
| Arch install article, create user, sudoers | README (manual) | Pre-chezmoi |
| Install paru | Install **yay** instead: `run_once_before_` (Linux only, skip if `yay` exists) | Omarchy ships yay; generic Arch builds it from the AUR (`git clone https://aur.archlinux.org/yay-bin.git && makepkg -si`) |
| Every `paru -S …` line | `yay -S --needed …` | Applies to README text and scripts |
| MacPorts / Homebrew | README one-liners for both | Pre-chezmoi. ifrit uses both; Homebrew-only is deferred |
| ssh-keygen + add to GitHub | README (manual) | Or init over HTTPS, switch remote later |
| Clone + `make` | `sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply sarumont` | Plus `sourceDir` if not default |
| User groups (`disk storage users input audio video`) | `run_once_` with sudo, linux | Decide which groups are still needed |
| Git name/email/signing/allowed_signers | M2 template | No manual step left |
| Package lists (basic, GUI, fonts, dev, kube, audio) | `.chezmoidata/packages.yaml` + `run_onchange_before_install-packages.sh.tmpl` (`yay -S --needed` / `sudo port install` + `brew bundle`) | Split by `common`, `arch`, `omarchy`, `darwin.port`, `darwin.brew`, `personal`; drop what Omarchy already installs |
| oh-my-zsh, zsh-syntax-highlighting, tpm | `.chezmoiexternal.toml` | |
| `chsh` | `run_once_` | |
| tpm plugin install | `run_onchange_after_` | If M3 keeps tmux |
| herdr plugins + reload | `run_onchange_after_` | M4 |
| `Lazy! sync` | `run_onchange_after_` on `lazy-lock.json` hash | M5 |
| `systemctl --user enable` (playerctld, devmon, darkman, syncthing, pipewire) | `run_onchange_after_` | Prune per M9/M12 |
| Tailscale install/enable | packages + `run_once_` for `systemctl enable` | `tailscale login/up` stays manual |
| `/etc/pacman.conf` Color, `/etc/makepkg.conf` MAKEFLAGS, udevil cifs, avahi | `run_once_` with sudo, or keep in README | chezmoi only manages `$HOME`; decide |
| Zoekt install | `run_onchange_` | M15 |
| beets venv | README or `run_once_` gated `personal` | M12 |
| Laptop / ThinkPad X1C / printing / trackpoint | DISCARD or README appendix | Omarchy handles most |
| Symlink gallery function | Keep as a zsh function in M1 | README copy has a bug: clears `~/work` twice, never `~/git` |
| `nix-env` / SteamOS lines | DISCARD | Out of scope |
| TODO list (sway-era) | DISCARD | |

- [ ] Decision: system-level `/etc` tweaks — `run_once_` with sudo / README only
- [ ] Decision: README sections to drop vs keep as reference: ___

---

## Phase 4 — Cutover

1. **shiva**: `chezmoi diff` is clean except intended changes → `chezmoi apply`
   → open new terminal, tmux/herdr, nvim; check `git commit -S` works.
2. Remove `Makefile`, delete any remaining stow package dirs, update
   `CLAUDE.md` and `README.md`, delete this file. Commit on `main`.
3. Switch GitHub default branch to `main`.
4. **ifrit (Mac)**: `stow` cleanup first (`make delete` from the old checkout,
   which removes the symlinks), then `chezmoi init --apply`, review
   `chezmoi diff` before applying.
5. Confirm `archive/master` and `archive/stow` exist on the remote, then delete
   the `stow` and `master` branches (and the demo branches, per Phase 0).

## Deferred (after cutover)

- Rewrite history to drop large blobs (Phase 0.3).
- Move ifrit from MacPorts + Homebrew to Homebrew only.
- Other machines with keys on GitHub (left in place on purpose):
  - `dadfi` — still in use; its dotfiles are out of date. Bring it onto
    chezmoi (it isn't one of the two managed hosts yet: decide its gating).
  - `mesafi` — may still be in use. Decide: onboard, or remove its GitHub key
    (`gh ssh-key delete 117524922`).

## Suggested order

Phase 0 → Phase 1 → M13 (frees up the `home/` name) → M2 → M1 → M17 →
M4/M3 → M5 → M6 → M7 → M8 → M14 → M15 → M9/M10/M11/M12/M16 (mostly deletions)
→ M18 → Phase 3 → Phase 4.
