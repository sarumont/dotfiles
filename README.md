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
- `neovim`
- `starship`

## Additional Utilities

- `exa`
- `eva`
- `bat`
- `hexyl`
- `universal-ctags`
- `zip` / `unzip`
- `fzf`
- `ripgrep`
- `fd-find`
- `whois`
- `gotop`

## Development 🛠

- Azure CLI (`azure-cli`)
- VSCode
- IntelliJ
- `nvm`

### SDKMan

    curl -s "https://get.sdkman.io" | zsh
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk i maven
    sdk i gradle
    sdk i java 11.0.2-open
    # maybe: sdk i java 8.0.252-zulu

## Desktop (non-headless)

- FiraCode Nerd Font
- `redshift`
- `lightdm`
- `slock`
- `scrot`
- `udevil`
- `awesome` (WM)
- `spacefm`
- `parcellite`
- `xdotool`
- Nordic GTK theme
- `evince` (PDF viewer)
- `vlc`

## Laptop

- `powertop`
- `tpm`

# Setup

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

# Optional components

## 🎧

    sudo apt install python3-pip ncmpcpp mpd mpc
    pip3 install beets[fetchart,lyrics,lastgenre] flask

Now, configure / mount music dir. Drop the following into `~/.local/beets/config.yaml`:

    directory: /media/chocobo/music
    library: /home/sarumont/.local/beets/library.blb
    import:
      log: /home/sarumont/.local/beets/import.log

And begin the import!

## PulseAudio

    ### Enable Echo/Noise-Cancellation
    load-module module-echo-cancel use_master_format=1 aec_method=webrtc aec_args="analog_gain_control=0\ digital_gain_control=1"
    set-default-source echoCancel_source
    set-default-sink echoCancel_sink

## dasht

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
