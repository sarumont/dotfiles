My dotfiles, managed with [chezmoi](https://www.chezmoi.io/). They target
three kinds of machine: Omarchy (shiva), plain Arch, and macOS (ifrit, the work
MacBook). This README is meant to be a near lights-out setup guide for a new
machine, plus the reference for how things fit together.

The chezmoi source state lives in [`home/`](home) (`.chezmoiroot`). Other
docs: [`docs/nvim-keymaps.md`](docs/nvim-keymaps.md),
[`docs/tmux.md`](docs/tmux.md), [`docs/todo.md`](docs/todo.md) (open items).

# New machine

## 1. Base system

- **Omarchy**: install Omarchy; it brings `yay`, Hyprland and most CLI tools.
- **Plain Arch**: base install per
  [this guide](https://www.walian.co.uk/arch-install-with-secure-boot-btrfs-tpm2-luks-encryption-unified-kernel-images.html),
  a user in `wheel` with sudo, then:

      # yay (AUR helper; also what Omarchy uses)
      sudo pacman -S --needed base-devel git
      git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
      (cd /tmp/yay-bin && makepkg -si)

      # colored pacman/yay output: uncomment "Color" in /etc/pacman.conf
      sudo sed -i 's/^#Color/Color/' /etc/pacman.conf

      # mDNS (.local names, printers)
      sudo pacman -S --needed avahi nss-mdns
      sudo systemctl enable --now avahi-daemon.service

- **macOS**: install [Homebrew](https://brew.sh/). Dotfiles use Homebrew for
  all macOS package management.

## 2. SSH key and GitHub

Do this before cloning: the git config rewrites `https://github.com/` to SSH,
so clones (including chezmoi externals) fail until the key is on GitHub.

    # One key per machine, no passphrase (disk encryption protects it at rest).
    # git signs commits with this same key.
    ssh-keygen -t ed25519

    yay -S github-cli chezmoi          # Arch / Omarchy
    brew install gh chezmoi            # macOS

    gh auth login --git-protocol ssh --skip-ssh-key --web \
      --scopes admin:public_key,admin:ssh_signing_key
    gh ssh-key add ~/.ssh/id_ed25519.pub --type authentication --title "$(uname -n)"
    gh ssh-key add ~/.ssh/id_ed25519.pub --type signing --title "$(uname -n) signing"
    ssh -T git@github.com              # should greet you by username

Add the new key to `home/private_dot_ssh/<host>.pub` (and to
`home/dot_config/git/allowed_signers.tmpl` so other machines can verify its
signatures) once the repo is cloned.

## 3. chezmoi

    chezmoi init --source ~/github.com/sarumont/dotfiles --apply git@github.com:sarumont/dotfiles.git

Any path works (`sourceDir` follows the checkout); this one matches the repo
layout below. To move it later: move the checkout, then
`chezmoi init --source <new path>`.

It asks three things once (answers live in `~/.config/chezmoi/chezmoi.toml`):

| Prompt | Meaning |
|---|---|
| Desktop machine (GUI) | plain Arch only (Omarchy and macOS are always desktops): GUI apps, fonts, keyd, Ghostty/PipeWire config, k8s tools |
| Dev machine (agents, toolchains) | servers only (desktops always are): agents, Go/Rust/uv via mise, Zoekt + ctags, herdr-fingers |
| Personal machine | personal-only packages and config (Proton Pass, syncthing, tailscale) |
| Git name / Git email | commit identity for this machine (name defaults to mine; a bot machine uses the bot's) |
| Secrets backend | `protonpass` (`pass-cli`), `1password` (`op`) or `none` |

`apply` installs packages (`yay` on Arch, `brew` on macOS), switches the login
shell to zsh, installs plugins (tmux, herdr, Neovim), Zoekt, and on Omarchy makes
Ghostty the default terminal with the Monaspace font. Scripts live in
`home/.chezmoiscripts/`; see [What runs automatically](#what-runs-automatically).

## 4. Manual steps

- Log out and back in (new login shell, new groups).
- Secrets: `pass-cli login` (Proton Pass) or `op signin` (1Password), then
  `chezmoi apply` again for anything that reads secrets.
- `nvim +"Copilot auth"` (Copilot is enabled for Go only).
- `sudo tailscale up --operator=$USER --accept-routes` (personal machines).
- Linux audio: `systemctl --user restart pipewire pipewire-pulse wireplumber`
  to pick up the sample-rate drop-in.
- Zoekt index: `zoekt-local-sync -index ~/.zoekt -f ~/github.com`.

Machine types: **shiva**/**ifrit** are desktops; **dadfi** is a server
(desktop no, dev no, secrets none); **jarvis** is an isolated dev VM for agents
(desktop no, dev yes, personal no, secrets none). jarvis runs as a separate
GitHub **bot** account: in step 2 log `gh` in as the bot and add its key to the
bot account (auth + signing), answer the bot's name/email at `chezmoi init`, and
don't add its key to this repo. It only reads dotfiles (public); its work goes
through PRs from the bot. Then `claude` → `/login` with the subscription.
`dirs-jarvis.env` makes `claude` the herdr workspace agent (pi needs API keys).

Machines initialized before a prompt existed keep working (fallbacks in
`.chezmoidata/defaults.yaml`); to record the new answers and silence chezmoi's
"config file template has changed" warning, run `chezmoi init` (e.g.
`chezmoi init --promptString "Git name=Richard Kolkovich" --promptBool "Dev machine (agents, toolchains)=false"` on dadfi).

# Day-to-day with chezmoi

The source of truth is `home/` in this repo (`~/github.com/sarumont/dotfiles`, set as
`sourceDir` in `~/.config/chezmoi/chezmoi.toml`). chezmoi copies files into
`$HOME`; it does not symlink, so edits to live files must be brought back.

    chezmoi status                 # what differs between repo and $HOME
    chezmoi diff [path]            # show the differences
    chezmoi apply [path]           # write repo state into $HOME (runs scripts too)
    chezmoi managed                # list managed paths
    chezmoi update                 # git pull + apply (other machines)

Changing a managed file:

    chezmoi edit ~/.config/foo     # edit the source, then: chezmoi apply
    # or, after editing the live file directly:
    chezmoi re-add ~/.config/foo   # plain files: copy the live file back
    chezmoi merge ~/.config/foo    # templates (*.tmpl): 3-way merge into the source

Adding a new file:

    chezmoi add ~/.config/foo/bar.conf               # plain file
    chezmoi add --template ~/.config/foo/bar.conf    # will contain {{ }} logic
    chezmoi chattr +template ~/.config/foo/bar.conf  # turn an existing one into a template

`chezmoi add` keeps file modes (`private_`, `executable_` prefixes). Then
decide where it should apply:

- One OS / Omarchy only: add the path to `home/.chezmoiignore` inside
  `{{ if ne .chezmoi.os "darwin" }}`, `{{ if not .omarchy }}`, and so on
  (see the existing blocks).
- One host only: name it per host where possible (`~/.local/sh/<host>.*`,
  `~/.config/tmux/tmux.<host>.conf`) and add it to that host's block in
  `.chezmoiignore`; otherwise gate a section inside a template with
  `{{ if eq .chezmoi.hostname "shiva" }}`.
- Template data: `.chezmoi.os`, `.chezmoi.hostname`, `.omarchy`, `.desktop`,
  `.personal`, `.email`, `.secrets` (`chezmoi data` shows everything). GUI
  things belong behind `.desktop`, so servers (e.g. dadfi) only get the CLI set.

Files that an app also writes to (pi's `settings.json`) are managed with a
`modify_` script that merges only our keys with `jq`, instead of replacing the
file.

Don't add files that Omarchy owns as symlinks or regenerates (for example
`~/.config/nvim/lua/plugins/theme.lua`, `~/.local/state/omarchy/*`).

Committing: `chezmoi cd` opens a shell in the repo (or `cd ~/git/dotfiles`);
commit and push as usual.

## Secrets

No secrets are stored in this repo, encrypted or not. Templates read them from
the machine's backend at apply time:

    {{ template "secret" (list .secrets "pass://SHARE/ITEM/FIELD" "op://VAULT/ITEM/FIELD") }}

(`home/.chezmoitemplates/secret`). References (item IDs, not secrets) live in
`home/.chezmoidata/secrets.yaml` as `secretRefs.<name>.protonpass` /
`.onepassword`; Proton Pass items are in the `dotfiles` vault. A machine whose
backend has no reference for a secret renders it empty. Prefer an app's own
credential store where one exists.

If the backend isn't logged in (`pass-cli login` / `op signin`), chezmoi warns
and skips the secret-backed files, leaving the existing copies untouched, and
applies everything else. The check is `home/.chezmoitemplates/secrets-ready`;
the skipped files are listed in `home/.chezmoiignore`, so **add every new
secret-backed target there**.

SSH: `~/.ssh/config` (public) includes `~/.ssh/config.d/*` first and ends with
`Host *` defaults, so per-host settings win. Private host entries come from the
`ssh/dot_config` note into `~/.ssh/config.d/private`.

## Maintenance: `sysup`

`sysup` (in `~/.local/bin`) updates everything, in this order:

1. **System**: `omarchy update` on Omarchy (snapshot, system packages, Omarchy
   migrations, AUR, `mise up`, orphans); `yay -Syu` + `mise up` on plain Arch;
   `brew update/upgrade`, `mise up` on macOS.
2. **Drift gate**: stops if any managed file changed outside chezmoi (see
   [Drift](#drift)). Re-run with `sysup --tools` once resolved.
3. **Dotfiles**: `chezmoi update` (pull + apply).
4. **Tools**: herdr (`update --handoff` + plugins), tmux plugins, Neovim
   `Lazy! sync`, pi models/extensions, Zoekt binaries + index, skills repos.
5. **Validate**: `herdr config check`, `hyprctl configerrors`.

`sysup --tools` skips step 1. Mason-installed tools (gopls etc.) update from
within Neovim (`:Mason`, `U`).

## Drift

Drift is a managed file that changed since chezmoi last wrote it: an Omarchy
migration, an app rewriting its config, or a hand edit. `chezmoi status` shows
it in the **first** column (`MM file`); a change that only exists in the repo
shows as ` M` and is just pending `apply`.

Detection: `sysup` refuses to continue while there is drift, and on Omarchy a
`post-update` hook (`~/.config/omarchy/hooks/post-update.d/chezmoi-drift.hook`)
reports it right after `omarchy update`'s migrations, with a notification.
`sysup` ignores files whose source is a `modify_` script (pi's
`settings.json`): those merge our keys into a file the app also writes, so
their changes are expected.

Resolve each file:

    chezmoi diff <file>      # what changed (repo vs. live)

| You want | Plain file | Template (`*.tmpl`) |
|---|---|---|
| keep the outside change | `chezmoi re-add <file>`, commit | `chezmoi merge <file>`, commit |
| keep ours, discard theirs | `chezmoi apply <file>` | `chezmoi apply <file>` |
| some of each | `chezmoi merge <file>`, commit | `chezmoi merge <file>`, commit |
| stop managing it | `chezmoi forget <file>`, commit | same |

For Omarchy migrations, read the change first: they usually carry fixes for new
Omarchy versions, so keeping or merging is the common answer.

## Packages

`home/.chezmoidata/packages.yaml` lists packages per OS (`linux` for CLI on
every Linux box, `linux_desktop` for GUI, `arch_only` for things Omarchy
already ships, `linux_personal` for personal machines (desktop or server),
`linux_personal_desktop` for personal GUI apps, `darwin_*`).
`run_onchange_before_10-install-packages.sh` installs them whenever the file
changes. On plain Arch it runs `yay -Syu --needed`, so a stale machine is fully
upgraded rather than partially (which fails with file conflicts when packages
are split); on Omarchy it runs `yay -S --needed` and leaves full upgrades to
`omarchy update`. Language runtimes and agent CLIs come from mise
(`~/.config/mise/config.toml`, a template: `gh` and `node` everywhere; claude,
codex, go, pi, rust and uv on desktops only). Add tools by editing
`home/dot_config/mise/config.toml.tmpl`, not with `mise use -g` (that edits the
live file and shows up as drift).

Servers (`.desktop` false, e.g. dadfi) get the CLI set only: no GUI apps, no
k8s tooling (kubectl/helm/terragrunt), no ctags or Zoekt, no herdr-fingers
(it needs Rust), and the slim mise list. On a server that previously had the
full set, `mise prune` drops the removed tools.

## What runs automatically

| Script | When | Does |
|---|---|---|
| `run_onchange_before_10-install-packages` | `packages.yaml` changes | install packages |
| `run_once_before_15-herdr` | once (not Omarchy) | install herdr from herdr.dev into `~/.local/bin` |
| `run_once_after_chsh-zsh` | once | make zsh the login shell |
| `run_once_after_20-services` | once (personal Linux) | enable syncthing (user) and tailscaled |
| `run_once_after_30-omarchy-defaults` | once (Omarchy) | Ghostty as default terminal, Monaspace font |
| `run_onchange_after_40-keyd` | `system/etc/keyd/default.conf` changes (Linux desktops) | install the keyd config into `/etc`, reload, enable keyd |
| `run_once_after_mask-gpg-agent` | once (Linux) | mask gpg-agent sockets |
| `run_onchange_after_tmux-plugins` | `tmux.conf` changes | install tpm plugins |
| `run_onchange_after_herdr-plugins` | `herdr.yaml` changes | install herdr plugins |
| `run_onchange_after_nvim-lazy-sync` | Neovim plugin specs change | `Lazy! sync` |
| `run_onchange_after_zoekt` | script changes | install Zoekt into `$PI_BIN_DIR` |

`run_onchange_` state is in chezmoi's `entryState` bucket, `run_once_` in
`scriptState`; delete a bucket (`chezmoi state delete-bucket --bucket=...`) to
force a re-run.

## Machine changes outside `$HOME`

Changes beyond the files chezmoi writes. Automated ones run from
`home/.chezmoiscripts/`; manual ones must be redone by hand on a new machine.

| Change | OS | How | Undo |
|---|---|---|---|
| Mask gpg-agent sockets (`gpg-agent`, `-ssh`, `-extra`, `-browser`). GPG and smartcard SSH keys are no longer used; Arch's `gnupg` enables these sockets globally. | Linux | Automated: `run_once_after_mask-gpg-agent.sh` | `systemctl --user unmask gpg-agent.socket gpg-agent-ssh.socket gpg-agent-extra.socket gpg-agent-browser.socket` |
| Enable `tailscaled` | personal Linux | Automated: `run_once_after_20-services.sh` | `sudo systemctl disable --now tailscaled` |
| `pacman.conf` `Color`, avahi | plain Arch | Manual (step 1) | revert the line / disable the service |
| keyd: Caps Lock = Ctrl when held, Esc when tapped, all keyboards. Right Alt = Compose: keyd emits a raw Caps Lock, which Omarchy's `compose:caps` xkb option turns into Compose (breaks if Omarchy drops that option). | Linux desktops | Automated: config in `system/etc/keyd/default.conf`, installed by `run_onchange_after_40-keyd.sh` | `sudo systemctl disable --now keyd` (and `yay -R keyd`) |

# Reference

## Shell (zsh)

oh-my-zsh and zsh-syntax-highlighting come from packages on Linux
(`/usr/share/oh-my-zsh`); on macOS chezmoi downloads oh-my-zsh into
`~/.oh-my-zsh` (`home/.chezmoiexternal.toml.tmpl`). If the login shell changes
while you're in a desktop session, log out and back in: terminals take
`$SHELL` from the session.

On Omarchy, `.zshenv` adds the bits of Omarchy's bash environment that zsh
doesn't get from the session (`BROWSER`, `BAT_THEME`, bat as man pager), and
`.zshrc` ports a few Omarchy helpers (`ff`, `eff`, `open`, `mup`, herdr layouts
`hdl`/`hds`/`hdlm`/`hsl`).

Machine-specific shell files live in `~/.local/sh/`:

- `<host>.zshenv`, `<host>.aliases.zsh`, `<host>.functions.zsh`,
  `dirs-<host>.env`: managed by chezmoi, only installed on that host.
- `zshenv`, `zshrc`, `zlogin`, `aliases.zsh`, `functions.zsh`: not managed;
  for settings that stay on one machine. Sourced after the managed files, so
  they win.

Shell scripts source the POSIX-compatible `~/.local/sh/dirs.env` contract:
`REPO_ROOT`, `REPO_GALLERY_DIR`, `WORK_GALLERY_DIR`, `WORKTREES_DIR`,
`PI_AGENT_DIR`, `PI_BIN_DIR`, `ZOEKT_INDEX_DIR`, `REPO_GALLERY_OWNERS`,
`WORK_GALLERY_OWNERS`. Host overrides go in
`~/.local/sh/dirs-<host>.env`, including `SKILLS_DIRS` (colon-separated skill
repositories).

`build` (and `b`, `c`, `cl`, `bi`, `clb`, `cli`, `clp`) walks up the tree to
find Gradle, Maven, Ant or npm/lerna and runs the right command.

## Git

`~/.config/git/config` is rendered by chezmoi: email from chezmoi data, commits
and tags signed with `~/.ssh/id_ed25519.pub`, and
`~/.config/git/allowed_signers` listing every machine's signing key (the local
key is appended if missing). `diff.external` is difftastic. `~/.gitconfig` is
unmanaged and read after the global config, so use it for per-machine
overrides. Global ignores: `~/.config/git/ignore` (macOS patterns only on
macOS).

Custom commands in `~/.local/bin`: `git attic`, `git clean-merged`,
`git neck`, `git trail`. Aliases: `gup` (`git up`: fetch + rebase with
autostash), `full_pull`, `gprune`, `powerwash`.

## tmux

Config: `home/dot_config/tmux/tmux.conf.tmpl` (workflow notes in
`docs/tmux.md`). chezmoi clones tpm into `~/.config/tmux/plugins/tpm` (a
weekly-refreshed external) and `run_onchange_after_tmux-plugins.sh` installs
the `@plugin` list whenever `tmux.conf` changes, using a private tmux server so
running sessions aren't affected. `<prefix> I` / `<prefix> U` still work for
manual installs and updates.

Per-host bindings live in `~/.config/tmux/tmux.<host>.conf` (managed);
`~/.config/tmux/tmux.local.conf` is unmanaged and loads last. Running tmux
servers keep their old config until you reload it (`<prefix> R`).

## herdr

Config: `home/dot_config/herdr/config.toml.tmpl`. On Omarchy it uses the
`terminal` theme so herdr follows Omarchy theme switches; macOS uses
`one-dark` and adds `cmd+1..9` tab switching.

Install: on Omarchy, herdr is Omarchy's package (updated by `omarchy update`;
restart the server afterwards). Everywhere else, `run_once_before_15-herdr`
uses the official installer (`curl -fsSL https://herdr.dev/install.sh | sh`,
into `~/.local/bin`, no sudo), because only a self-managed binary supports
`herdr update --handoff` (live handoff without dropping sessions), which `sysup`
runs. If a package-manager herdr is also installed there, remove it
(`sudo pacman -R herdr` / `brew uninstall herdr`) so it can't shadow or confuse.

Plugins are listed in `home/.chezmoidata/herdr.yaml` and installed by
`run_onchange_after_herdr-plugins.sh` whenever that list changes (add `ref:`
to pin a commit). To update them, delete the `entryState` bucket and apply, or
run `herdr plugin install <repo> --yes` by hand.

- [nvim-herdr-navigation](https://github.com/bojackduy/nvim-herdr-navigation)
  (`local.vim-navigator`): `ctrl+h/j/k/l` move between herdr panes and Neovim
  splits. The Neovim half is `home/dot_config/nvim/lua/plugins/herdr.lua` and
  only loads inside herdr; `vim-tmux-navigator` handles tmux outside it.
- [herdr-fingers](https://github.com/nathan-poncet/herdr-fingers): `prefix+f`
  labels paths, URLs, hashes and more; type a label to copy, Shift+label to
  paste, Ctrl+label to open, Tab to select several. Built with cargo (Rust
  from mise).

## Terminal (Ghostty)

Config: `home/dot_config/ghostty/config.tmpl`, shared by both OSes. On
Omarchy, Omarchy owns the font family and theme: the template renders the font
from `omarchy-font-current`, so `omarchy-font-set` never causes drift.

## Hyprland / Omarchy

Only customized files are managed (Omarchy only): `~/.config/hypr/`
`looknfeel.lua`, `input.lua` (shiva trackpoint section templated),
`bindings.lua`, `hyprsunset.conf`, `monitors.lua` (shiva only), and
`~/.config/omarchy/defaults/agent`. Everything else stays Omarchy's default;
`chezmoi add` a file when you start customizing it. After changes:
`hyprctl reload && hyprctl configerrors`; `hyprsunset.conf` needs
`omarchy restart hyprsunset`.

Night light: gammastep, not hyprsunset (which only knows fixed clock times).
`~/.config/gammastep/config.ini` follows the sun for a fixed location
(Grand Junction, CO, rounded to city level; no geoclue): 5700K day, 3500K
night, with fades. It runs as the `gammastep.service` user unit, enabled by
`run_onchange_after_45-gammastep.sh`. `nightlight` pauses/resumes it; both
`SUPER+CTRL+N` and the Omarchy menu's Toggle → Nightlight entry (overridden in
`~/.config/omarchy/extensions/omarchy-menu.jsonc`) call it instead of
Omarchy's hyprsunset toggle, so the two never fight over the gamma. The bar's
night light indicator (it tracks hyprsunset) is left out of `items` in
`~/.config/omarchy/shell.json`; if hyprsunset ever gets started anyway,
`pkill -x hyprsunset`.

Layout: Hyprland's scrolling layout on every workspace (niri/OmniWM-style),
set in `looknfeel.lua`. Omarchy's `SUPER+L` dwindle/scrolling toggle is
unbound; it saves per-workspace overrides in
`~/.local/state/omarchy/workspace-layouts/`, which should stay empty.
`SUPER+R` cycles the focused column's width through 0.333 / 0.5 / 0.667 / 1.0
(`explicit_column_widths`). Vim-style navigation, same as the arrows:
`SUPER+H/J/K/L` focus; `SUPER+SHIFT+H/L` move the whole column (`swapcol`,
wraps at the ends), `SUPER+SHIFT+J/K` swap within a column. Stacking:
`SUPER+[` / `SUPER+]` join the neighbouring column, or leave the current one
if stacked (`consume_or_expel`). Keybinding cheat sheets moved off K to free
HJKL: `SUPER+B` (Omarchy), `SUPER+ALT+B` (tmux); herdr's stays on
`SUPER+CTRL+K` (`SUPER+CTRL+B` is Bluetooth). Omarchy's dwindle split toggle
(`SUPER+J`) is gone.

Visor (Quake-style drop-down terminal, as in sway and OmniWM's quake
terminal): `CTRL+SHIFT+RETURN` runs `~/.local/bin/visor`, which toggles the
special workspace `visor` over the current one, starting a Ghostty (class
`dev.sarumont.visor`, tmux session `visor`) on first use. A window rule floats
it full width, 80% tall, just below the bar.

Compose (Right Alt, via keyd): sequences live in `~/.XCompose` (template,
Linux desktops): Omarchy's emoji list (`Compose m <letter>`), its hand emoji
re-toned medium-light (🏼), and `Compose Space n/e` for name/email (email from
chezmoi data). `SUPER+CTRL+SHIFT+E` (`compose-keys`) lists them in Omarchy's
menu, and picking one types it; `compose-keys --print` prints them. After
editing, `omarchy-restart-xcompose`.

Window switcher: `SUPER+CTRL+SPACE` (OmniWM's palette chord; replaces
Omarchy's background switcher, still in the Omarchy menu) runs
`window-switcher`: open windows, most recent first and minus the focused one,
in Omarchy's searchable menu as `workspace  app  title`; picking one focuses
it, switching workspace if needed.

On macOS, OmniWM (`~/.config/omniwm/settings.toml`) mirrors this with Option as
the mod: same letters (both machines type Dvorak; OmniWM's file labels keys by
their QWERTY position, so Dvorak `i` is `G`, `r` is `O`, `w` is `Comma`),
`Option+Command+key` to move a window (the same two physical keys as
`SUPER+ALT` on a PC keyboard), `Option+r` to cycle width. OmniWM has no silent
move. Those chords shadow macOS's `Cmd+Opt+D` (Dock auto-hide),
`Cmd+Opt+W/M` (close/minimize all) and `Cmd+Opt+I` (devtools; use F12).

Workspaces (sway-style, in `bindings.lua`): `SUPER+1-4` general purpose
(5-10 unbound), plus named workspaces on their first letter: `SUPER+D` dev,
`W` www, `I` comms (`C` stays Omarchy's universal copy), `M` music, `N` notes.
One scheme for numbers and letters: `SUPER+<key>` go, `SUPER+ALT+<key>` move
the window there, `SUPER+SHIFT+ALT+<key>` move it silently (`SUPER+SHIFT+<letter>`
is Omarchy's app launchers). Relocated Omarchy defaults: group window 1-5 →
`SUPER+CTRL+ALT+1-5`; `SUPER+SHIFT+M` opens the `cliamp` music TUI instead
of Spotify. Close window moved to `SUPER+Q`. Window rules open Firefox on www,
Obsidian on notes, Discord/Signal/Google Messages on comms, cliamp on music. Omarchy's bar widget only knows numbered
workspaces, so the bar uses a clone, `~/.config/omarchy/plugins/sarumont.workspaces`
(fixed slots `1 2 3 4 D W I M N`; selected via `~/.config/omarchy/shell.json`).
Keep its slot list in sync with `bindings.lua`.

## Neovim

LazyVim, with `,` as leader. Config: `home/dot_config/nvim/` (extras in
`lazyvim.json`, overrides in `lua/plugins/`); keymaps and the reasoning behind
them: [`docs/nvim-keymaps.md`](docs/nvim-keymaps.md). On Omarchy,
`lua/plugins/theme.lua` is a symlink owned by `omarchy-theme-set`, so Neovim
follows Omarchy themes live; elsewhere `theme.lua` sets onenord.

Language tooling comes from mise and Mason (gopls, delve, formatters, linters;
installed on first use). Set `OBSIDIAN_VAULT_DIR` (e.g. in
`~/.local/sh/<host>.zshenv`) to point
[obsidian.nvim](https://github.com/obsidian-nvim/obsidian.nvim) at a vault; it
defaults to `~/notes`.

## AI agents (Claude Code, Codex, pi)

- `~/AGENTS.md` is shared; `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`
  import it. `CLAUDE.md` is templated so tool installs say `brew` on macOS and
  `yay` on Arch.
- pi: `~/.pi/agent/settings.json` is merged, not replaced
  (`modify_settings.json.tmpl`), so pi's own keys and Omarchy's `theme`
  survive. Skills from the work repo are ifrit-only. pi itself comes from mise;
  on ifrit `~/.local/bin/pi` wraps it with `$PI_DEFAULT_MODEL`.
- `pi-herdr-subagents` model assignments are per host (templated `config.json`
  inside its `node_modules`; `chezmoi apply` restores it if a reinstall removes
  it).
- `codemod` runs through `uvx` on all hosts via `~/.local/bin/codemod`;
  `gibr` also runs through `uvx`.

## Docker

Omarchy enables the Docker daemon (`docker.socket`) but deliberately does not
add the user to the `docker` group: membership is root-equivalent (any process
running as you could `docker run -v /:/host`). Current choice on shiva: **plain
`sudo docker`**. Docker isn't used much here, so nothing in these dotfiles
configures it.

Consequence: `sudo docker login` stores registry credentials in root's
`~/.docker/config.json` (base64, plaintext). Fine for occasional use; revisit
if Docker becomes part of the daily loop.

Options for later:

| Option | How | Security | Credentials |
|---|---|---|---|
| `sudo docker` (current) | nothing | root only via sudo | root's plaintext config |
| Sudoless Docker | `omarchy-setup-security-sudoless-docker` (Setup > Security > Sudoless Docker); undo by removing yourself from `docker` | root-equivalent for anything running as you | can use GNOME Keyring: `yay -S docker-credential-secretservice-git`, `"credsStore": "secretservice"` in `~/.docker/config.json`, then `docker login` |
| Rootless Docker | per-user daemon, socket in `$XDG_RUNTIME_DIR` | no root-equivalence | GNOME Keyring as above |

Rootless costs: slower user-mode networking, ports below 1024 need a sysctl, a
separate image store, and tools must point `DOCKER_HOST` at the user socket.
Note that Omarchy's default keyring is passwordless by design, so "in the
keyring" means plaintext on disk protected by LUKS. On macOS, Docker Desktop
already keeps credentials in the Keychain.

If you switch to a non-sudo option, record it in
[Machine changes outside `$HOME`](#machine-changes-outside-home) and manage
only the `credsStore` key (a `modify_` script with `jq`, as for pi's settings),
since Docker writes to `config.json` itself.

## Zoekt

[Zoekt](https://github.com/sourcegraph/zoekt) gives fast cross-repo code
search. `run_onchange_after_zoekt.sh` installs `zoekt`, `zoekt-git-index` and
`zoekt-local-sync` into `$PI_BIN_DIR` (`~/.pi/agent/bin`, on PATH via
`.zshenv`); `sysup` updates them and refreshes the index. Universal
Ctags (installed from `packages.yaml`) adds symbol-aware ranking and `sym:`
queries.

    zoekt-local-sync -index ~/.zoekt -f ~/github.com
    zoekt -index_dir ~/.zoekt -r -l 'WalletService GetDefault'

Omit `-f` to preview; the roots given are the complete set, so repos no longer
found under them are dropped from the index. The pi skill
(`~/.pi/agent/skills/zoekt/SKILL.md`) tells agents to use Zoekt for discovery
and verify with `rg`/file reads.

## Repos and the symlink gallery

Every clone lives at `$REPO_ROOT/<owner>/<repo>` (`~/github.com/...`): no
name collisions, predictable paths, and Zoekt indexes the whole tree. `ghq`
(with `ghq.root = ~` in the git config) clones straight into it:

    ghq get sarumont/dotfiles        # -> ~/github.com/sarumont/dotfiles
    ghq list                         # everything under $REPO_ROOT

The galleries (from [Waylon Walker](https://waylonwalker.com/symlink-gallery/))
are flat directories of symlinks over that tree, browsed by `ta`, the tmux
pickers (`C-a C-g`, `C-a C-w`) and the herdr workspace pickers:

- `$WORK_GALLERY_DIR` (`~/work`): repos of the owners in `$WORK_GALLERY_OWNERS`
  (set per host in `dirs-<host>.env`; ifrit: the work orgs).
- `$REPO_GALLERY_DIR` (`~/git`): the work gallery plus `$REPO_GALLERY_OWNERS`
  (default `sarumont`).

Run `update_link_galleries` (in `~/.functions.zsh`) after cloning; it also
re-links `twt` worktrees.

----

Shout-out to @notlesh for dropping me [this awesome link](https://www.wezm.net/technical/2019/10/useful-command-line-tools/), which has influenced some of my configuration now.
