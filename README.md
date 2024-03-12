My dotfiles. The current iteration utilizes [GNU Stow](https://www.gnu.org/software/stow/) via `make`. This setup is inspired by [this post](https://venthur.de/2021-12-19-managing-dotfiles-with-stow.html).

This `README` is designed to be almost a lights-out installation and setup guide for new machines, too.

# Prerequisites

1. Create a user
1. Add user to `sudoers`
1. Install package manager

## paru (Arch Linux)

    sudo pacman -Syu
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd ~
    rm -rf paru

## macports

MacPorts is assumed for macOS. Use `sudo port selfupdate` to update the local ports tree.

# Software

## basic utilities

### Arch
    paru -S zsh starship neovim openssh go-yq exa eva bat hexyl zip unzip fzf ripgrep fd \
            whois gotop jq tmux direnv at keychain zoxide usbutils stow

### macOS
    sudo port install starship neovim tmux tmux-pasteboard exa bat hexyl ripgrep fd gotop \
                      direnv yq pinentry-mac keychain zoxide

## zsh
    # oh my zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # change shell to zsh (Arch: /usr/bin/zsh, macOS: /bin/zsh)
    chsh

## `tmux`

    # install tmux plugin manager (tpm)
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    # start tmux and run <prefix>I to install all plugins

## `neovim`

    cd ~/git/dotfiles
    make install-nvchad 

## GUI

    paru -S sway waybar swaylock swaybg wob \
            alacritty firefox man-db gammastep adw-gtk-theme \
            polkit playerctl grimshot xorg-xwayland \
            yubioath-desktop yubikey-manager \
            imv mpv nautilus udevil devmon cifs-utils evince neofetch \
            wl-clipboard xdg-desktop-portal-wlr
    systemctl --user enable --now playerctld
    systemctl --user enable --now devmon

### alacritty

    mkdir -p ~/.config/alacritty/themes
    git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

### Fonts
    paru -S noto-fonts-emoji otf-fira-code-symbol ttf-dejavu \
            ttf-ubuntu-nerd ttf-ubuntu-mono-nerd ttf-roboto \
            ttf-roboto-mono ttf-ms-fonts noto-fonts-jp-vf

## Misc

    paru -S syncthing 
    systemctl --user enable --now syncthing

    paru -S tailscale
    sudo systemctl enable --now tailscaled
    sudo tailscale login
    sudo tailscale up --operator=$(whoami) --accept-routes

## Laptop Utilities

    paru -S battop wluma light

    # cpupower 

## 🎧

    paru -S pipewire pipewire-pulse easyeffects easyeffects-presets spotify \
            pavucontrol lsp-plugins plexamp-appimage
    systemctl --user enable --now pipewire

    # configure easyeffects

### `mpd` 

    paru -S mpc ncmpcpp mpd mpdevil

### `beets`

    paru -S beets python-pylast python-http python-pyxdg python-httpx python-flask python-requests imagemagick

Now, configure and mount your music dir. Drop the following into `~/.local/beets/config.yaml`:

    directory: /media/chocobo/music
    library: /home/sarumont/.local/beets/library.blb
    import:
      log: /home/sarumont/.local/beets/import.log

And begin the import!

## Dev

Development tools. Season these to taste based on your needs.

### Arch

    paru -S kcat-cli rubygems jwt-cli httpie aws-cli-v2-bin docker vault

### DB

    gem install schema-evolution-manager

### Golang

#### Arch

    paru -S go delve

#### macOS

    sudo port install go delve

### Java

    curl -s "https://get.sdkman.io" | zsh
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk i maven
    sdk i gradle
    sdk ls java
    sdk i java <whatever version you want/need>

## Kubernetes

    paru -S kubectl terragrunt helm telepresence2

### Local cluster

    paru -S rancher-k3d-bin

# Thinkpad X1C 9th Gen

Most of this is from the [Arch Wiki](https://wiki.archlinux.org/title/Lenovo_ThinkPad_X1_Carbon_(Gen_9))

    paru -S sof-firmware intel-media-driver fprintd gnome-polkit

# Machine Setup

    # Generate a new SSH key
    ssh-keygen -t ed25519
    # add ~/.ssh/id_ed25519.pub to Github

    mkdir ~/git/
    git clone git@github.com:sarumont/dotfiles.git ~/git/dotfiles
    cd ~/git/dotfiles
    make # installs all links

## add user to useful groups

    sudo gpasswd -a sarumont disk
    sudo gpasswd -a sarumont storage
    sudo gpasswd -a sarumont users
    sudo gpasswd -a sarumont input
    sudo gpasswd -a sarumont audio
    sudo gpasswd -a sarumont video

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
 - enable/start `devmon`: `systemctl --user enable --now devmon`
 - edit `/etc/makepkg.conf` and set `MAKEFLAGS="-j$(nproc)"` to parallelize compilation
 - enable/start `avahi`: `sudo systemctl enable --now avahi-daemon.service`


# TODO
- [x] GDM
- [x] wluma (need autostart)
- [x] gammastep (need autostart)
- [x] fprintd
- [x] alacritty config
- [x] missing devicons..?
- [x] GDM fprint
- [x] dark mode/light mode
- [x] geoclue?
- [ ] local overrides
- [ ] privfiles (same as local overrides)
- [ ] plex (downloads)
- [ ] bluetooth
- [ ] screen auto locking (w/ fprint?)
- [ ] power management
- [ ] Tailscale statusbar
- [ ] printing
- [ ] darkman (see if it works, add config gotchas to README)

# TODO: everything below here is old and needs updated

## Privfiles
    # optional privfiles
    git clone git@github.com:sarumont/privfiles.git .privfiles

Note that if you don't have a `privfiles` equivalent, the only links that need to be considered are:
 - `.ssh/allowed_signers` -> `.privfiles/ssh/allowed_signers`
 - `.ssh/authorized_keys` -> `.privfiles/ssh/authorized_keys`
 - `.ssh/config` -> `.privfiles/ssh/config`

### Sway

Set background (managed via `systemd`):

    gsettings set org.gnome.desktop.background picture-uri ~/Drive/Pictures/bg/jason-abdilla-tvs3SeHBWDI-unsplash.jpg    

# Optional components and configuration

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
