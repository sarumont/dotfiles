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
4. Each project tmux session is created by `ta` with one of three modes:
    - `generic` — plain shell (default `--start` behavior)
    - `code` — window 1: neovim
    - `ai` — window 1: neovim, window 2: Claude Code (`claude`), window 3: shell
5. New worktree-based projects are spun up with `twt [ticket]`, which:
    - Uses `gibr` to generate a branch name from a Linear ticket number
    - Creates a git worktree at `~/worktrees/<repo>-<branch>`
    - Symlinks it into the same galleries (`~/git`, `~/work`) as the parent repo
    - Opens a new `ai`-mode tmux session for the worktree
    - `twt --remove` tears it all down interactively
