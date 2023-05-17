Dotfiles for my home directory.

I used to have another repository in my `$HOME` setup called `homes.git`. It was representative of 
actual `$HOME` and had submodules for `dotfiles.git` (this repo) and, optionally, `privfiles.git` 
(ssh configs, etc.). There were many symlinks into the common and local. `homes.git` had a branch 
per machine/VM to allow `.local` to contain differing configurations.

Now, this repository is an amalgamation of the old `homes.git` and `dotfiles.git`. Part of this is
driven by the fact that I generally only have one machine to maintain now. It is also driven by
desire to have a more portable config for managing remote servers and/or spinning up docker images
for development work, so I have attempted to make everything as portable as possible.

# Software

## Prerequisites

1. Create a user
1. Add user to `sudoers`

### paru (Arch)

    sudo pacman -Syu
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si

## Additional Utilities 🛠

### General

    paru -S starship neovim zsh gnupg openssh go-yq exa eva bat hexyl zip unzip fzf ripgrep fd \
            whois gotop jq tmux direnv at

    # install tmux plugin manager (tpm)
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

### Dev

    paru -S kcat-cli rubygems jwt-cli httpie aws-cli-v2-bin docker vault
    gem install schema-evolution-manager

#### Go

    paru -S go

    # Debugger
    go install github.com/go-delve/delve/cmd/dlv@latest

### Misc

    paru -S syncthing 

## Desktop Utilities (non-headless)

    paru -S sway waybar swaylock swaybg termite firefox arc-gtk-theme flat-remix man-db gammastep \
            polkit playerctl grimshot wob xorg-xwayland yubioath-desktop \
            imv mpv nautilus udevil cifs-utils evince yubikey-manager neofetch 

### Fonts
    paru -S noto-fonts-emoji nerd-fonts-fira-code ttf-dejavu nerd-fonts-ubuntu-mono ttf-roboto \
            ttf-roboto-mono ttf-ubuntu-font-family ttf-ms-fonts noto-fonts-jp-vf

### Laptop Utilities

    paru -S battop power-profiles-daemon cpupower lightc python-gobject

### Sway

Set background (managed via `systemd`):

    gsettings set org.gnome.desktop.background picture-uri ~/Drive/Pictures/bg/jason-abdilla-tvs3SeHBWDI-unsplash.jpg    

## Kubernetes

    paru -S kubectl terragrunt helm telepresence2

### Local cluster

    paru -S rancher-k3d-bin

## SDKMan (Java SDK manager) (TODO: remove this in favor of devcontainers)

    curl -s "https://get.sdkman.io" | zsh
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk i maven
    sdk i gradle
    sdk ls java
    sdk i java <whatever version you want/need>

# Setup

The following is split up a bit based on what sort of machine is being set up. A "local" machine is one you'll be physically using; a "remote" machine is something you'll ssh into (e.g. a server somewhere)

## Local machine setup (GPG)

    mkdir ~/.gnupg
    curl https://raw.githubusercontent.com/sarumont/dotfiles/master/.gnupg/gpg.conf > .gnupg/gpg.conf
    curl https://raw.githubusercontent.com/sarumont/dotfiles/master/.gnupg/gpg-agent-template.conf > .gnupg/gpg-agent.conf
    gpg --card-edit --expert
    > fetch
    > quit

    # set trust to 'ultimate' for your key via gpg --edit-key

    gpg --list-keys # side-effect of starting the agent
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    echo UPDATESTARTUPTTY | gpg-connect-agent

## General setup
    git init .
    git remote add -t \* -f origin git@github.com:sarumont/dotfiles.git
    git pull

    # local only
    rm .gnupg/gpg.conf
    # end local only

    git checkout master
    git submodule update --init --recursive

    # install nvchad (neovim base config)
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

    # start tmux and run <prefix>I to install all plugins

    # change shell to zsh (Arch: /usr/bin/zsh, macOS: /bin/zsh)
    chsh

    rm ~/.bash*
    rm ~/.profile
    rm -rf paru

    echo "Please log out and log back in"

## Remote only
    mkdir -p ~/.local/sh
    echo "export GPG_AGENT=false" >> ~/.local/sh/zshenv
    gpg2 --recv-key <GPG KEY ID>

## Privfiles
    # optional privfiles
    git clone git@github.com:sarumont/privfiles.git .privfiles

Note that if you don't have a `privfiles` equivalent, the only links that need to be considered are:
 - `.ssh/authorized_keys` -> `.privfiles/ssh/authorized_keys`
 - `.ssh/config` -> `.privfiles/ssh/config`

# Misc configuration

 - Enable color output in `pacman/yay/paru` - uncomment `Color` in `/etc/pacman.conf`
 - add `vers=3.0` to `cifs` mount options in `/etc/udevil/udevil.conf` (both allowed and default)
 - enable/start `playerctld`: `systemctl --user enable --now playerctld`
 - enable/start `devmon`: `systemctl --user enable --now devmon`
 - enable/start `syncthing`: `systemctl --user enable --now syncthing`
 - enable/start `pipewire`: `systemctl --user enable --now pipewire`
 - edit `/etc/makepkg.conf` and set `MAKEFLAGS="-j$(nproc)"` to parallelize compilation
 - use `~/.gitconfig` for local git overrides and configuration (i.e. `[user]` section)

# Optional components and configuration

## 🎧

### `mpd` && `beets`

    paru -S mpc ncmpcpp mpd spotify mpdevil \
            beets python-pylast python-http python-pyxdg python-httpx

Now, configure and mount your music dir. Drop the following into `~/.local/beets/config.yaml`:

    directory: /media/chocobo/music
    library: /home/sarumont/.local/beets/library.blb
    import:
      log: /home/sarumont/.local/beets/import.log

And begin the import!

### Easyeffects

    paru -S easyeffects easyeffects-presets

# Local overrides

## shell

Local zsh overrides are supported:
 - `.aliases.zsh` -> `.local/sh/aliases.zsh`
 - `.functions.zsh` -> `.local/sh/functions.zsh`
 - `.zlogin` -> `.local/sh/zlogin`
 - `.zshenv` -> `.local/sh/zshenv`
 - `.zshrc` -> `.local/sh/zshrc`

## vim-notes

The directory for [vim-notes](https://github.com/xolox/vim-notes) is `~/.local/share/vim/notes`. This can be a symlink to e.g. `~/Dropbox/notes` to allow syncing of notes between machines.

## Xresources.local

DPI is machine-dependent, but an example `~/.Xresources.local` is:

    Xft.dpi: 144

    ! These might also be useful depending on your monitor and personal preference:
    Xft.autohint: 0
    Xft.lcdfilter:  lcddefault
    Xft.hintstyle:  hintfull
    Xft.hinting: 1
    Xft.antialias: 1
    Xft.rgba: rgb

# Servers

## GPG forwarding

On the client machine:

`~/.ssh/config`

    Host foo
      RemoteForward /run/user/1000/gnupg/S.gpg-agent /run/user/1000/gnupg/S.gpg-agent.extra

Double-check your UID. Also, season to taste for macOS vs Linux client. Note that the format is `RemoteForward <remote socket> <local socket>`

On the server machine, add `StreamLocalBindUnlink yes` to `/etc/ssh/sshd_config` (or wherever the ssh daemon's config is) and restart it.

----

Shout-out to @notlesh for dropping me [this awesome link](https://www.wezm.net/technical/2019/10/useful-command-line-tools/), which has influenced some of my configuration now.
