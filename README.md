Dotfiles for my home directory.

I used to have another repository in my `$HOME` setup called `homes.git`. It was representative of actual `$HOME` and had submodules for `dotfiles.git` (this repo) and, optionally, `privfiles.git` (ssh configs, etc.). There were many symlinks into the common and local. `homes.git` had a branch per machine/VM to allow `.local` to contain differing configurations.

Now, this repository is an amalgamation of the old `homes.git` and `dotfiles.git`. Part of this is
driven by the fact that I generally only have one machine to maintain now. It is also driven by
desire to have a more portable config for managing remote servers and/or spinning up docker images
for development work.

# Usage

    ssh-keygen -t rsa -b 4096 -f /tmp/id_rsa
    ssh-agent

    # <set env vars to use agent>
    # <add public key to Github>

    ssh-add /tmp/id_rsa
    git init .
    git remote add -t \* -f origin git@github.com:sarumont/dotfiles.git

    git checkout ng

    # optional: git submodule add git@github.com:sarumont/privfiles.git .privfiles

    git submodule update --init --recursive
    mv /tmp/id_rsa* ~/.ssh/

    # clean up default shit in $HOME

    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    nvim -c ":PlugInstall"
