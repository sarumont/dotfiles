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

## Setup

    ssh-keygen -t rsa -b 4096 -f /tmp/id_rsa
    ssh-agent

    # <set env vars to use agent>
    # <add public key to Github>

    ssh-add /tmp/id_rsa
    git init .
    git remote add -t \* -f origin git@github.com:sarumont/dotfiles.git

    # optional: git submodule add git@github.com:sarumont/privfiles.git .privfiles

    git checkout master
    git pull
    git submodule update --init --recursive
    mv /tmp/id_rsa* ~/.ssh/

    # clean up default shit in $HOME

    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    nvim -c ":PlugInstall"

Note that if you don't have a `privfiles` equivalent, the only links that need to be considered are:
 - `.ssh/authorized_keys` -> `.privfiles/ssh/authorized_keys`
 - `.ssh/config` -> `.privfiles/ssh/config`

## Optional components

### SDKMan

    curl -s "https://get.sdkman.io" | zsh
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk install maven
    sdk install java 8.0.191-oracle
    # sdk install java 8.0.181-zulu

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
