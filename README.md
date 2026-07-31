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

    # Generate a new SSH key
    ssh-keygen -t ed25519
    # add ~/.ssh/id_ed25519.pub to Github
    ssh-agent
    # run commands output by ^
    ssh-add ~/.ssh/id_ed25519

    mkdir ~/git/
    git clone git@github.com:sarumont/dotfiles.git ~/git/dotfiles
    cd ~/git/dotfiles

    # install stow:
    paru -S stow
    sudo port install stow
    nix-env -iA nixpkgs.stow
    
    make # installs all links

## add user to useful groups (linux)

    sudo gpasswd -a $(whoami) disk
    sudo gpasswd -a $(whoami) storage
    sudo gpasswd -a $(whoami) users
    sudo gpasswd -a $(whoami) input
    sudo gpasswd -a $(whoami) audio
    sudo gpasswd -a $(whoami) video

## Local git configuration

This repo stores global git configuration in `~/.config/git/config`. This leaves `~/.gitconfig` for local overrides. You can set your name and email:

    git config --global user.name Zaphod Beeblebrox
    git config --global user.email zaphod@heartofgold.com

### Signing git commits with your SSH key

We need to configure `git` to use your SSH key as the signing key. There should only be one key in your keyring if you've followed these instructions. If you have multiple keys, copy-paste the one you want to use rather than using the `ssh-add -L` command below.

    git config --global user.signingkey "$(ssh-add -L)"
    git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
    echo EMAIL $(ssh-add -L) > ~/.ssh/allowed_signers

Note that these commands need to be run after installing `keychain`

# Local overrides

Local overrides are managed via `stow` using the `make host` command. This looks for a dir called `.hosts-$(hostname)` and applies that as a vault. This applies side-by-side, so it does *not* support overwriting.

## shell

The following local zsh overrides are supported:

 - `.aliases.zsh` -> `.local/sh/aliases.zsh`
 - `.functions.zsh` -> `.local/sh/functions.zsh`
 - `.zlogin` -> `.local/sh/zlogin`
 - `.zshenv` -> `.local/sh/zshenv` && `.local/sh/*.zshenv`
 - `.zshrc` -> `.local/sh/zshrc`

## obsidian.nvim

You can set `OBSIDIAN_VAULT_DIR` in your `~/.local/sh/zshenv` to point to an Obsidian Vault. This allows [`obsidian.nvim`](https://github.com/epwalsh/obsidian.nvim) to utilize it. It defaults to `~/notes`

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
    # oh my zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    # change shell to zsh (Arch: /usr/bin/zsh, macOS: /bin/zsh)
    chsh

## `tmux`

    # install tmux plugin manager (tpm)
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    # start tmux and run <prefix>I to install all plugins

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
