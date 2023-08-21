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
1. Install package manager

### paru (Arch Linux)

    sudo pacman -Syu
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si

### macports

MacPorts is assumed for macOS. Use `sudo port selfupdate` to update the local ports tree.

## Additional Utilities 🛠

### General

#### Arch

    paru -S starship neovim zsh openssh go-yq exa eva bat hexyl zip unzip fzf ripgrep fd \
            whois gotop jq tmux direnv at keychain

#### macOS

    sudo port install starship neovim tmux tmux-pasteboard exa bat hexyl ripgrep fd gotop \
                      direnv yq pinentry-mac keychain

#### Debian-based systems

    sudo apt install zsh git tmux snapd fzf ripgrep fd-find at zip unzip direnv jq whois hexyl \
                     bat exa 
    ## grab gotop manually: https://github.com/xxxserxxx/gotop/releases
    ## missing: eva, go-yq
    sudo snap install --classic nvim # necessary to get a modern neovim for e.g. Raspbian

    ## Starship
    curl -sS https://starship.rs/install.sh | sh

### Dev

#### Arch

    paru -S kcat-cli rubygems jwt-cli httpie aws-cli-v2-bin docker vault

#### macOS

#### Generic

    gem install schema-evolution-manager

#### Go

##### Arch

    paru -S go delve

###### macOS

    sudo port install go delve

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

## General setup

    # Generate a new SSH key
    ssh-keygen -t ed25519
    # add ~/.ssh/id_ed25519.pub to Github
    # TODO: need to re-add the temp key process I used to have here

    git init .
    git remote add -t \* -f origin git@github.com:sarumont/dotfiles.git
    git pull

    git checkout master
    git submodule update --init --recursive

    # install nvchad (neovim base config)
    git clone https://github.com/NvChad/NvChad ~/.config/nvim.nv --depth 1
    mv .config/nvim.nv/lua/* .config/nvim/lua/
    rmdir .config/nvim.nv/lua 
    mv .config/nvim.nv/* .config/nvim/                                    
    mv .config/nvim.nv/.* .config/nvim/
    rmdir .config/nvim.nv

    # install tmux plugin manager (tpm)
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    # start tmux and run <prefix>I to install all plugins

    # change shell to zsh (Arch: /usr/bin/zsh, macOS: /bin/zsh)
    chsh

    rm ~/.bash*
    rm ~/.profile
    rm -rf paru

    echo "Please log out and log back in"

## Privfiles
    # optional privfiles
    git clone git@github.com:sarumont/privfiles.git .privfiles

Note that if you don't have a `privfiles` equivalent, the only links that need to be considered are:
 - `.ssh/allowed_signers` -> `.privfiles/ssh/allowed_signers`
 - `.ssh/authorized_keys` -> `.privfiles/ssh/authorized_keys`
 - `.ssh/config` -> `.privfiles/ssh/config`

## keychain

`keychain` is used to optionally manage SSH keys. To enable, use `~/.local/sh/zshenv` to set `SSH_KEY` to key IDs to be loaded. For SSH keys, this is the filename of the key (i.e. `id_ed25519`).

## Local git configuration

This repo stores global git configuration in `~/.config/git/config`. This leaves `~/.gitconfig` for local overrides. You can set your name and email:

    git config --global user.name Zaphod Beeblebrox
    git config --global user.email zaphod@heartofgold.com

### Signing git commits with your SSH key

We need to configure `git` to use your SSH key as the signing key. There should only be one key in your keyring if you've followed these instructions. If you have multiple keys, copy-paste the one you want to use rather than using the `ssh-add -L` command below.

    git config --global user.signingkey "$(ssh-add -L)"
    git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
    echo EMAIL $(ssh-add -L) > ~/.ssh/allowed_signers


# Misc configuration

 - Enable color output in `pacman/yay/paru` - uncomment `Color` in `/etc/pacman.conf`
 - add `vers=3.0` to `cifs` mount options in `/etc/udevil/udevil.conf` (both allowed and default)
 - enable/start `playerctld`: `systemctl --user enable --now playerctld`
 - enable/start `devmon`: `systemctl --user enable --now devmon`
 - enable/start `syncthing`: `systemctl --user enable --now syncthing`
 - enable/start `pipewire`: `systemctl --user enable --now pipewire`
 - edit `/etc/makepkg.conf` and set `MAKEFLAGS="-j$(nproc)"` to parallelize compilation

# Optional components and configuration

## 🎧

### `mpd` && `beets`

    paru -S mpc ncmpcpp mpd spotify mpdevil \
            beets python-pylast python-http python-pyxdg python-httpx python-flask python-requests imagemagick

Now, configure and mount your music dir. Drop the following into `~/.local/beets/config.yaml`:

    directory: /media/chocobo/music
    library: /home/sarumont/.local/beets/library.blb
    import:
      log: /home/sarumont/.local/beets/import.log

And begin the import!

### Easyeffects

    paru -S easyeffects easyeffects-presets

## Symlink gallery

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

# Local overrides

## shell

Local zsh overrides are supported:
 - `.aliases.zsh` -> `.local/sh/aliases.zsh`
 - `.functions.zsh` -> `.local/sh/functions.zsh`
 - `.zlogin` -> `.local/sh/zlogin`
 - `.zshenv` -> `.local/sh/zshenv`
 - `.zshrc` -> `.local/sh/zshrc`

## obsidian.nvim

You can set `OBSIDIAN_VAULT_DIR` in your `~/.local/sh/zshenv` to point to an Obsidian Vault. This allows [`obsidian.nvim`](https://github.com/epwalsh/obsidian.nvim) to utilize it.

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

----

Shout-out to @notlesh for dropping me [this awesome link](https://www.wezm.net/technical/2019/10/useful-command-line-tools/), which has influenced some of my configuration now.
