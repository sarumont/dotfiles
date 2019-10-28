Dotfiles for my home directory.

I used to have another repository in my `$HOME` setup called `homes.git`. It was representative of actual `$HOME` and had submodules for `dotfiles.git` (this repo) and, optionally, `privfiles.git` (ssh configs, etc.). There were many symlinks into the common and local. `homes.git` had a branch per machine/VM to allow `.local` to contain differing configurations.

Now, this repository is an amalgamation of the old `homes.git` and `dotfiles.git`. Part of this is
driven by the fact that I generally only have one machine to maintain now. It is also driven by
desire to have a more portable config for managing remote servers and/or spinning up docker images
for development work.

# Usage

## Prerequisites

- `git`
- `zsh`

### Ubuntu

    # basic utilities
    sudo apt install git zsh keychain neovim silversearcher-ag zip unzip tmux universal-ctags docker whois fd-find

    # TODO: use official docker repository...?

    # If it's a desktop environment
    sudo apt install fonts-firacode htop scrot slock awesome udevil redshift lightdm slick-greeter \
        lightdm-settings libgtk-3-dev gtk-doc-tools fonts-ubuntu fonts-noto-color-emoji

    # grab Cascadia Code from Github, and drop it into ~/.local/share/fonts && fc-cache -f
    # 
    # TODO can use something like this to grab release from GH:
    # wget -q --show-progress https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz
    #
    # https://github.com/sharkdp/bat/releases
    # https://github.com/sharkdp/hexyl/releases

    # If it's a laptop
    sudo apt install powertop tpm

    # set shell to zsh
    chsh 

## Setup

TODO: make this a script

    ssh-keygen -t rsa -b 4096 -f /tmp/id_rsa
    ssh-agent

    # <set env vars to use agent>
    # <add public key to Github>

    ssh-add /tmp/id_rsa
    git init .
    git remote add -t \* -f origin git@github.com:sarumont/dotfiles.git

    git checkout master
    git branch --set-upstream-to=origin/master master
    git pull
    git submodule update --init --recursive
    mv /tmp/id_rsa* ~/.ssh/

    # optional: git clone git@github.com:sarumont/privfiles.git .privfiles
    # or mkdir -p ~/.privfiles/ssh

    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    rm ~/.bash*
    rm ~/.profile

    echo "Please log out, log back in, and run 'viup' to initialize your neovim setup."

    # If desktop:
    mkdir -p ~/.config/awesome
    cd ~/.config/awesome
    git clone --recursive git@github.com:sarumont/awesome-copycats.git 
    ln -s awesome-copycats/{freedesktop,lain,themes} .
    ln -s themes/powerarrow-dark/my-theme.lua .

Note that if you don't have a `privfiles` equivalent, the only links that need to be considered are:
 - `.ssh/authorized_keys` -> `.privfiles/ssh/authorized_keys`
 - `.ssh/config` -> `.privfiles/ssh/config`

## Optional components

### SDKMan

    curl -s "https://get.sdkman.io" | zsh
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk i maven
    sdk i gradle
    sdk i java 11.0.2-open
    # maybe: sdk i java 8.0.222-zulu

### More stuff

    # TODO: browser, gtk theme, Dropbox, Zoom, VPN, sound
    # https://github.com/microsoft/cascadia-code/releases
    sudo apt install arc-theme spacefm parcellite xdotool

### 🎧

    sudo apt install python3-pip ncmpcpp mpd mpc
    pip3 install beets[fetchart,lyrics,lastgenre] flask

Now, configure / mount music dir. Drop the following into `~/.local/beets/config.yaml`:

    directory: /media/chocobo/music
    library: /home/sarumont/.local/beets/library.blb
    import:
      log: /home/sarumont/.local/beets/import.log

And begin the import!

### dasht

    sudo apt install golang w3m sqlite3
    go get github.com/william8th/javadocset

# Local overrides

## shell

Local zsh overrides are supported:
 - `.aliases.zsh` -> `.local/sh/aliases.zsh`
 - `.functions.zsh` -> `.local/sh/functions.zsh`
 - `.zlogin` -> `.local/sh/zlogin`
 - `.zshenv` -> `.local/sh/zshenv`
 - `.zshrc` -> `.local/sh/zshrc`

# TODO: VSCode

## vim-notes

The directory for [vim-notes](https://github.com/xolox/vim-notes) is `~/.local/share/vim/notes`. This can be a symlink to e.g. `~/Dropbox/notes` to allow syncing of notes between machines.

# Niceties

## Italics

To get Italics working in both vim and tmux (on macOS):

 - https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/
 - https://apple.stackexchange.com/questions/249307/tic-doesnt-read-from-stdin-and-segfaults-when-adding-terminfo-to-support-italic/249385

## Undervolting

[intel-undervolt](https://github.com/kitsunyan/intel-undervolt)

Shout-out to @notlesh for dropping me [this awesome link](https://www.wezm.net/technical/2019/10/useful-command-line-tools/), which has influenced some of my configuration now.
