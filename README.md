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

    yay -S starship neovim zsh git gnupg openssh

## Additional Utilities 🛠

    yay -S go-yq exa eva bat hexyl zip unzip fzf ripgrep fd whois gotop jq aws-cli-v2-bin docker \
           tmux neofetch httpie direnv vault kcat-cli rubygems

    gem install schema-evolution-manager

## Desktop Utilities (non-headless)

    yay -S sway waybar swaylock swaybg termite firefox arc-gtk-theme flat-remix man-db gammastep \
           polkit playerctl synology-drive grimshot wob xorg-xwayland yubioath-desktop \
           imv nautilus udevil cifs-utils evince yubikey-manager 

### Fonts
    yay -S noto-fonts-emoji nerd-fonts-fira-code ttf-dejavu nerd-fonts-ubuntu-mono ttf-roboto \
           ttf-roboto-mono ttf-ubuntu-font-family ttf-ms-fonts noto-fonts-jp-vf

### Laptop Utilities

    yay -S battop power-profiles-daemon cpupower lightc python-gobject

## Kubernetes

    yay -S kubectl terragrunt helm telepresence2

### Local cluster

    yay -S rancher-k3d-bin

## SDKMan (Java SDK manager)

    curl -s "https://get.sdkman.io" | zsh
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk i maven
    sdk i gradle
    sdk ls java
    sdk i java <whatever version you want/need>

# Setup

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

    git init .
    git remote add -t \* -f origin git@github.com:sarumont/dotfiles.git
    git pull
    rm .gnupg/gpg.conf
    git checkout master
    git submodule update --init --recursive

    # optional: git clone git@github.com:sarumont/privfiles.git .privfiles
    # or mkdir -p ~/.privfiles/ssh

    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    chsh # set to /usr/bin/zsh

    rm ~/.bash*
    rm ~/.profile

    echo "Please log out, log back in, and run 'viup' twice to initialize your neovim setup."

## Privfiles

Note that if you don't have a `privfiles` equivalent, the only links that need to be considered are:
 - `.ssh/authorized_keys` -> `.privfiles/ssh/authorized_keys`
 - `.ssh/config` -> `.privfiles/ssh/config`

# Misc configuration

 - Enable color output in `pacman/yay` - uncomment `Color` in `/etc/pacman.conf`

# Optional components

## 🎧

### `mpd` && `beets`

    yay -S mpc ncmpcpp mpd spotify mpdevil \
           beets python-pylast python-http python-pyxdg python-httpx

Now, configure and mount your music dir. Drop the following into `~/.local/beets/config.yaml`:

    directory: /media/chocobo/music
    library: /home/sarumont/.local/beets/library.blb
    import:
      log: /home/sarumont/.local/beets/import.log

And begin the import!

### Easyeffects

    yay -S easyeffects easyeffects-presets

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

# Niceties

## Undervolting

[intel-undervolt](https://github.com/kitsunyan/intel-undervolt)

Shout-out to @notlesh for dropping me [this awesome link](https://www.wezm.net/technical/2019/10/useful-command-line-tools/), which has influenced some of my configuration now.
