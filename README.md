Dotfiles for my home directory.

I used to have another repository in my `$HOME` setup called `homes.git`. It was representative of actual `$HOME` and had submodules for `dotfiles.git` (this repo) and, optionally, `privfiles.git` (ssh configs, etc.). There were many symlinks into the common and local. `homes.git` had a branch per machine/VM to allow `.local` to contain differing configurations.

Now, this repository is an amalgamation of the old `homes.git` and `dotfiles.git`. Part of this is
driven by the fact that I generally only have one machine to maintain now. It is also driven by
desire to have a more portable config for managing remote servers and/or spinning up docker images
for development work.

# Software

## Prerequisites

    yay -S starship neovim zsh git gnupg yubikey-manager openssh

## Additional Utilities 🛠

    yay -S go-yq exa eva bat hexyl zip unzip fzf ripgrep fd whois gotop jq aws-cli docker tmux

TODO: haven't been using this. TypeScript integration seems a bit janky
- `universal-ctags`

### SDKMan

    curl -s "https://get.sdkman.io" | zsh
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk i maven
    sdk i gradle
    sdk i java 11.0.2-open

## Desktop (non-headless)

    yay -S sway waybar swaylock termite firefox noto-fonts-emoji nerd-fonts-fira-code

TODO: not up to date with Wayland-ification

- `redshift`
- `lightdm`
- `slock`
- `scrot`
- `udevil`
- `awesome` (WM)
- `spacefm`
- `parcellite`
- `xdotool`
- Arc GTK theme
- `evince` (PDF viewer)
- `vlc`
- `ttf-dejavu`

## Laptop

    yay -S battop power-profiles-daemon

# Setup

TODO: make this a script

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
