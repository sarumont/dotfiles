My dotfiles. The current iteration utilizes [GNU Stow](https://www.gnu.org/software/stow/) via `make`. This setup is inspired by [this post](https://venthur.de/2021-12-19-managing-dotfiles-with-stow.html).

This `README` is designed to be almost a lights-out installation and setup guide for new machines, too.

# Machine Setup

## Installation

Base installation process follows [this article](https://www.walian.co.uk/arch-install-with-secure-boot-btrfs-tpm2-luks-encryption-unified-kernel-images.html) for Arch (btw).

## Prerequisites

1. Create a user
1. Add user to `sudoers`
1. Install package manager

## Packager manager

### paru (Arch Linux)

    sudo pacman -Syu
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd ~
    rm -rf paru

### macports

MacPorts is assumed for macOS. Use `sudo port selfupdate` to update the local ports tree.

## Dotfiles setup

Do this first: the git config rewrites `https://github.com/` URLs to SSH, so
clones (including chezmoi externals) fail until the key is on GitHub.

    # Generate a new SSH key (no other keys are expected; the git config signs with this one)
    ssh-keygen -t ed25519

    # Install the GitHub CLI
    yay -S github-cli          # Arch / Omarchy
    brew install gh            # macOS

    # Log in, then register the key for both auth and commit signing
    gh auth login --git-protocol ssh --skip-ssh-key --web \
      --scopes admin:public_key,admin:ssh_signing_key
    gh ssh-key add ~/.ssh/id_ed25519.pub --type authentication --title "$(uname -n)"
    gh ssh-key add ~/.ssh/id_ed25519.pub --type signing --title "$(uname -n) signing"
    ssh -T git@github.com      # should greet you by username

    mkdir ~/git/
    git clone git@github.com:sarumont/dotfiles.git ~/git/dotfiles
    cd ~/git/dotfiles

    # install stow:
    paru -S stow
    sudo port install stow
    nix-env -iA nixpkgs.stow
    
    make # installs all links

### Shared directory definitions

Shell scripts source the POSIX-compatible `~/.local/sh/dirs.env` contract. It defines
`REPO_ROOT`, `REPO_GALLERY_DIR`, `WORK_GALLERY_DIR`, `WORKTREES_DIR`, `PI_AGENT_DIR`,
`PI_BIN_DIR`, and `ZOEKT_INDEX_DIR`. Host-specific overrides use
`~/.local/sh/dirs-$(hostname -s).env`; `SKILLS_DIRS` is defined there as a
colon-separated list of skill repositories.

## Day-to-day with chezmoi

The source of truth is `home/` in this repo (`~/Work/dotfiles`, set as
`sourceDir` in `~/.config/chezmoi/chezmoi.toml`). chezmoi copies files into
`$HOME`; it does not symlink, so edits to live files must be brought back.

    chezmoi status                 # what differs between repo and $HOME
    chezmoi diff [path]            # show the differences
    chezmoi apply [path]           # write repo state into $HOME (runs scripts too)
    chezmoi managed                # list managed paths

Changing a managed file:

    chezmoi edit ~/.config/foo     # edit the source, then: chezmoi apply
    # or, after editing the live file directly:
    chezmoi re-add ~/.config/foo   # plain files: copy the live file back
    chezmoi merge ~/.config/foo    # templates (*.tmpl): 3-way merge into the source

Adding a new file:

    chezmoi add ~/.config/foo/bar.conf             # plain file
    chezmoi add --template ~/.config/foo/bar.conf  # will contain {{ }} logic
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
- Template data available: `.chezmoi.os`, `.chezmoi.hostname`, `.omarchy`,
  `.personal`, `.email` (`chezmoi data` shows everything).

Don't add files that Omarchy owns as symlinks or regenerates (for example
`~/.config/nvim/lua/plugins/theme.lua`, `~/.local/state/omarchy/*`).

Committing: `chezmoi cd` opens a shell in the repo (or `cd ~/Work/dotfiles`);
commit and push as usual. On another machine: `chezmoi update` (git pull +
apply).

## add user to useful groups (linux)

    sudo gpasswd -a $(whoami) disk
    sudo gpasswd -a $(whoami) storage
    sudo gpasswd -a $(whoami) users
    sudo gpasswd -a $(whoami) input
    sudo gpasswd -a $(whoami) audio
    sudo gpasswd -a $(whoami) video

## Local git configuration

Global git configuration lives in `~/.config/git/config`, rendered by chezmoi.
It sets your email from chezmoi's per-machine data, signs commits and tags with
`~/.ssh/id_ed25519.pub`, and generates `~/.config/git/allowed_signers` from the
same key. No manual `git config` steps are needed.

`~/.gitconfig` is not managed and is read after the global config, so use it
for per-machine overrides.

## Machine changes outside `$HOME`

Changes made to a machine beyond the files chezmoi writes. Automated ones run
from `home/.chezmoiscripts/`; manual ones must be run by hand on a new machine.

| Change | OS | How | Undo |
|---|---|---|---|
| Mask gpg-agent sockets (`gpg-agent`, `-ssh`, `-extra`, `-browser`). GPG and smartcard SSH keys are no longer used; Arch's `gnupg` enables these sockets globally. | Linux | Automated: `run_once_after_mask-gpg-agent.sh` | `systemctl --user unmask gpg-agent.socket gpg-agent-ssh.socket gpg-agent-extra.socket gpg-agent-browser.socket` |

# Local overrides

Local overrides are managed via `stow` using the `make host` command. This looks for a dir called `.hosts-$(hostname)` and applies that as a vault. This applies side-by-side, so it does *not* support overwriting.

## shell

Machine-specific shell files live in `~/.local/sh/`:

- `<host>.zshenv`, `<host>.aliases.zsh`, `<host>.functions.zsh`,
  `dirs-<host>.env`: managed by chezmoi, only installed on that host
  (gated in `home/.chezmoiignore`).
- `zshenv`, `zshrc`, `zlogin`, `aliases.zsh`, `functions.zsh`: not managed;
  use them for settings that stay on one machine. They are sourced after the
  managed files, so they win.

## obsidian.nvim

Set `OBSIDIAN_VAULT_DIR` (e.g. in `~/.local/sh/<host>.zshenv`) to point
[obsidian.nvim](https://github.com/obsidian-nvim/obsidian.nvim) at a vault.
It defaults to `~/notes`.

## Privfiles

I have a private repository that is an overlay on top of this one called `privfiles`. I now manage it the same way (with `stow`) and use it to store e.g. secrets and configurations which I do not want to be public knowledge.

# Additional Software

## basic utilities

### Arch
    paru -S zsh starship neovim openssh go-yq exa eva bat hexyl zip unzip fzf ripgrep fd \
            whois btop jq tmux direnv at keychain zoxide usbutils stow smartmontools mise

### macOS
    sudo port install starship neovim tmux tmux-pasteboard exa bat hexyl ripgrep fd btop \
                      direnv yq pinentry-mac keychain zoxide stow
    brew install mise # not available via macports :(

### SteamOS (nix)
    nix-env -iA nixpkgs.cmake


## zsh

Linux uses packaged oh-my-zsh and zsh-syntax-highlighting:

    yay -S zsh oh-my-zsh-git zsh-syntax-highlighting

On macOS, chezmoi downloads oh-my-zsh into `~/.oh-my-zsh` (see
`home/.chezmoiexternal.toml.tmpl`); install the highlighter with
`brew install zsh-syntax-highlighting` or `sudo port install zsh-syntax-highlighting`.

`chezmoi apply` switches the login shell to zsh if needed
(`run_once_after_chsh-zsh.sh`). If the shell changes while you're logged into
a desktop session, log out and back in: terminals take `$SHELL` from the
session, which is set at login.

## `tmux`

Config: `home/dot_config/tmux/tmux.conf.tmpl` (workflow notes in
`docs/tmux.md`). chezmoi clones tpm into `~/.config/tmux/plugins/tpm` (a
weekly-refreshed external) and `run_onchange_after_tmux-plugins.sh` installs
the `@plugin` list whenever `tmux.conf` changes, using a private tmux server so
running sessions aren't affected. `<prefix> I` / `<prefix> U` still work for
manual installs and updates.

Per-host bindings live in `~/.config/tmux/tmux.<host>.conf` (managed);
`~/.config/tmux/tmux.local.conf` is unmanaged and loads last.

Running tmux servers keep their old config until you reload it
(`<prefix> R`) or restart them.

## herdr

Config: `home/dot_config/herdr/config.toml.tmpl`. On Omarchy it uses the
`terminal` theme so herdr follows Omarchy theme switches; macOS uses
`one-dark` and adds `cmd+1..9` tab switching.

Plugins are listed in `home/.chezmoidata/herdr.yaml` and installed by
`run_onchange_after_herdr-plugins.sh` whenever that list changes (add `ref:`
to pin a commit). herdr has no plugin-update command: to update, re-run
`chezmoi state delete-bucket --bucket=entryState` and `chezmoi apply`, or run
`herdr plugin install <repo> --yes` by hand.

- [nvim-herdr-navigation](https://github.com/bojackduy/nvim-herdr-navigation)
  (`local.vim-navigator`): `ctrl+h/j/k/l` move between herdr panes and Neovim
  splits. The Neovim half is in `nvim/.config/nvim/lua/plugins/herdr.lua` and
  only loads inside herdr; `vim-tmux-navigator` stays active outside it.
- [herdr-fingers](https://github.com/nathan-poncet/herdr-fingers): `prefix+f`
  (Ctrl+A, then F) labels paths, URLs, hashes and more; type a label to copy,
  Shift+label to paste, Ctrl+label to open, Tab to select several. Built with
  cargo, so Rust comes from mise (`~/.config/mise/config.toml`).

## Terminal (Ghostty)

Config: `home/dot_config/ghostty/config.tmpl`. On Omarchy, Omarchy owns the
font family and theme: the template renders the font from
`omarchy-font-current`, so `omarchy-font-set` never causes drift.

    # Omarchy: install and make it the default terminal, then set the font
    omarchy-install-terminal ghostty
    yay -S otf-monaspace-nerd
    omarchy-font-set "MonaspiceNe Nerd Font Mono"

    # macOS
    brew install --cask ghostty font-monaspace-nerd-font

## Hyprland / Omarchy

Only customized files are managed (Omarchy-only): `~/.config/hypr/`
`looknfeel.lua`, `input.lua` (shiva trackpoint section templated),
`bindings.lua`, `hyprsunset.conf`, `monitors.lua` (shiva only), and
`~/.config/omarchy/defaults/agent`. Everything else stays Omarchy's default;
`chezmoi add` a file when you start customizing it. After changes:
`hyprctl reload && hyprctl configerrors`; `hyprsunset.conf` needs
`omarchy restart hyprsunset`.

## Neovim

LazyVim, with `,` as leader. Config: `home/dot_config/nvim/` (extras in
`lazyvim.json`, overrides in `lua/plugins/`); keymaps and the reasoning behind
them: `docs/nvim-keymaps.md`. On Omarchy, `lua/plugins/theme.lua` is a symlink
owned by `omarchy-theme-set`, so Neovim follows Omarchy themes live; elsewhere
`theme.lua` sets onenord. `run_onchange_after_nvim-lazy-sync.sh` runs
`Lazy! sync` whenever `lazyvim.json` or a plugin spec changes.

Language tooling comes from mise (`go`, `rust`, `node`, `uv` in
`~/.config/mise/config.toml`) and Mason (gopls, delve, formatters, linters;
installed on first use).

Manual, once per machine:

    nvim +"Copilot auth"     # GitHub Copilot sign-in (Copilot is enabled for Go only)

## GUI

    paru -S sway waybar swaylock swaybg wob \
            ghostty firefox man-db gammastep adw-gtk-theme \
            polkit playerctl grimshot xorg-xwayland \
            yubioath-desktop yubikey-manager \
            imv mpv nautilus udevil devmon cifs-utils evince neofetch \
            wl-clipboard xdg-desktop-portal-wlr darkman
    systemctl --user enable --now playerctld
    systemctl --user enable --now devmon
    systemctl --user enable --now darkman

### Fonts
    paru -S noto-fonts-cjk noto-fonts-emoji noto-fonts \
            otf-firamono-nerd otf-fira-mono-italic-git \
            ttf-dejavu \
            ttf-ubuntu-nerd ttf-ubuntu-mono-nerd ttf-roboto \
            ttf-roboto-mono ttf-ms-fonts

## Misc

    # syncthing for file synchronization
    paru -S syncthing 
    systemctl --user enable --now syncthing

    # silicon for generating screenshots of code from nvim
    paru -S silicon

    # Tailscale for a private VPN
    paru -S tailscale
    sudo systemctl enable --now tailscaled
    sudo tailscale login
    sudo tailscale up --operator=$(whoami) --accept-routes

## Laptop

    paru -S battop wluma light tlp 

Configure power management via the [Arch Wiki article](https://wiki.archlinux.org/title/Power_management). Also [this Framework thread](https://community.frame.work/t/tracking-linux-battery-life-tuning/6665) is useful, especially for GPU rendering config.

### Thinkpad

[Arch Wiki - X1C 9th gen](https://wiki.archlinux.org/title/Lenovo_ThinkPad_X1_Carbon_(Gen_9))
    
    # TODO: still WIP userspace battery charge threshold
    paru -S threshy
    systemctl enable --now threshy

## printing

    paru -S cups
    sudo gpasswd -a $(whoami) cups

## 🎧

    paru -S pipewire pipewire-pulse easyeffects easyeffects-presets spotify \
            pavucontrol lsp-plugins plexamp-appimage
    systemctl --user enable --now pipewire

    # configure easyeffects

    # bluetooth
    paru -S bluez bluez-utils bluetuith
    sudo systemctl enable --now bluetooth.service

### `mpd` 

    paru -S mpc ncmpcpp mpd mpdevil

### `beets`

    paru -S python imagemagick
    python -m venv ~/.beets-venv
    source ~/.beets-venv/bin/activate
    pip install beets pylast pyxdg httpx flask requests beets-xtractor beets-copyartifacts3

Now, configure and mount your music dir. Drop the following into `~/.local/beets/config.yaml`:

    directory: /media/chocobo/music
    library: /home/sarumont/.local/beets/library.blb
    import:
      log: /home/sarumont/.local/beets/import.log

And begin the import!

## Dev

Development tools. Season these to taste based on your needs.

### Arch

    paru -S kcat-cli jwt-cli httpie aws-cli-v2-bin docker vault

### DB

    paru -S rubygems
    gem install schema-evolution-manager

### Golang

#### Arch

    paru -S go delve

#### macOS

    sudo port install go delve

### Zoekt + Pi agents

[Zoekt](https://github.com/sourcegraph/zoekt) provides fast cross-repository code search. Install its Go commands into Pi's existing bin directory, and install Universal Ctags for symbol-aware ranking:

    brew install universal-ctags
    GOBIN="$HOME/.pi/agent/bin" go install \\
      github.com/sourcegraph/zoekt/cmd/zoekt@latest \\
      github.com/sourcegraph/zoekt/cmd/zoekt-git-index@latest \\
      github.com/sourcegraph/zoekt/cmd/zoekt-local-sync@latest

Index all local repositories under `~/github.com`:

    zoekt-local-sync -index "$HOME/.zoekt" -f "$HOME/github.com"

Use `-f` only to apply the sync; omitting it previews changes. The supplied roots are the complete desired set, so repositories no longer found below them are removed from the index. Search examples:

    zoekt -index_dir "$HOME/.zoekt" -r -l 'WalletService GetDefault'
    zoekt -index_dir "$HOME/.zoekt" -jsonl 'wallet file:*.go'
    zoekt -index_dir "$HOME/.zoekt" 'wallet repo:transfers-config'

Refresh the index after pulling or creating repositories:

    zoekt-local-sync -index "$HOME/.zoekt" -f "$HOME/github.com"

For Pi agents, add a global skill at `~/.pi/agent/skills/zoekt/SKILL.md` explaining that Zoekt is for broad, read-only discovery and that `rg`/file reads must verify current working-tree results. Start a new Pi session after adding the skill.

## Kubernetes

    paru -S kubectl terragrunt helm telepresence2

### Local cluster

    paru -S rancher-k3d-bin

# Thinkpad X1C 9th Gen

Most of this is from the [Arch Wiki](https://wiki.archlinux.org/title/Lenovo_ThinkPad_X1_Carbon_(Gen_9))

    paru -S sof-firmware intel-media-driver fprintd gnome-polkit

## Trackpoint Sensitivity

Edit `/sys/devices/platform/i8042/serio1/sensitivity` as necessary. I like `110` as the value (default is `128`)

# Misc configuration

 - Enable color output in `pacman/yay/paru` - uncomment `Color` in `/etc/pacman.conf`
 - add `vers=3.0` to `cifs` mount options in `/etc/udevil/udevil.conf` (both allowed and default)
 - enable/start `devmon`: `systemctl --user enable --now devmon`
 - edit `/etc/makepkg.conf` and set `MAKEFLAGS="-j$(nproc)"` to parallelize compilation
 - enable/start `avahi`: `sudo systemctl enable --now avahi-daemon.service`

# Symlink gallery

I ripped this idea from [Waylon Walker](https://waylonwalker.com/symlink-gallery/). Basically, this creates a directory that is a "gallery" of projects, tying into tmux keybindings (see `C-w`). You can add multiple galleries (work, oss, etc.) and corresponding keybindings in your `tmux.conf`.

I keep this as a `zsh` function inside of `~/.local/sh/functions.zsh` and run it periodically to keep the galleries up to date:

    update_link_galleries() {
      rm -rf ~/work
      mkdir ~/work
      ln -sf ~/github.com/myorganization/* ~/work

      rm -rf ~/work
      mkdir ~/work
      ln -sf ~/work/* ~/git
    }

# TODO
- [ ] Tailscale statusbar
- [ ] clipman / parcellite / clipboard manager via Wofi
- [ ] screen auto locking (w/ fprint?) https://github.com/swaywm/swaylock/issues/61#issuecomment-1409369151

----

Shout-out to @notlesh for dropping me [this awesome link](https://www.wezm.net/technical/2019/10/useful-command-line-tools/), which has influenced some of my configuration now.
