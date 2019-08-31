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
    sudo apt install git zsh keychain neovim silversearcher-ag zip unzip tmux exuberant-ctags

    # If it's a desktop environment
    sudo apt install fonts-firacode

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

Note that if you don't have a `privfiles` equivalent, the only links that need to be considered are:
 - `.ssh/authorized_keys` -> `.privfiles/ssh/authorized_keys`
 - `.ssh/config` -> `.privfiles/ssh/config`

## Optional components

### SDKMan

    curl -s "https://get.sdkman.io" | zsh
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk i maven
    sdk i java 11.0.2-open
    sdk i java 8.0.222-zulu

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

# Niceties

## Italics

To get Italics working in both vim and tmux (on macOS):

 - https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/
 - https://apple.stackexchange.com/questions/249307/tic-doesnt-read-from-stdin-and-segfaults-when-adding-terminfo-to-support-italic/249385
