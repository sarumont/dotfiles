# tmux

`tmux` is a terminal multiplexer. It works in the most basic of terminals, which
is what I generally use.

## Workflow

My tmux config and tooling was influenced a lot by [this
post](https://waylonwalker.com/tmux-nav-2021/). Generally:

1. all my projects live, as symlinks, in `~/work` or `~/git`
2. I run a fullscreen terminal (Ghostty, currently) attached to one session
3. I have a "visor" terminal (iTerm2 on mac, another Ghostty on Linux) that I
   summon from the top of my screen attached to a scratch tmux session for
   non-project stuff (updating packages, dotfiles, etc.)
4. Each project tmux session will generally have the following windows:
    1. neovim (probably with a horizontal split for running shell commands via
       christoomey/vim-tmux-runner)
    2. Claude Code or Codex
    3. maybe a utility terminal, depending on what I'm doing
