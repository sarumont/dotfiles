# Neovim keymaps (LazyVim, leader = `,`)

LazyVim's defaults apply unless listed here
(<https://www.lazyvim.org/keymaps>). Overrides live in
`home/dot_config/nvim/lua/config/keymaps.lua` and `lua/plugins/*.lua`.
`<leader>?` shows buffer keymaps; `<leader>sk` searches all of them.

## Leader-related

- Leader is `,`. flash.nvim's `;`/`,` f/t-repeat keys are disabled so `,` is a
  clean leader; repeat a jump by pressing `f`/`t` again.
- `,,` lists buffers (LazyVim's `<leader>,`).

## Editing

| Key | Action | Note |
|---|---|---|
| `;` | `:` | |
| `jk` (insert) | Escape | |
| `<C-b>` / `<C-e>` (insert) | line start / end | from NvChad |
| `<C-h/j/k/l>` (insert) | cursor left/down/up/right | from NvChad |
| `<C-h/j/k/l>` (normal) | move between splits and tmux/herdr panes | tmux navigator outside herdr, herdr navigator inside |
| `gK` | signature help | `<C-k>` in insert is cursor-up |
| `<C-s>` | save | |
| `<C-c>` | copy whole file | |
| `<leader>/` | toggle comment (normal + visual) | LazyVim's grep moved to `<leader>fw` / `<leader>sg` |
| `s` / `S` | flash jump / flash treesitter (normal, op-pending) | replaces vim-sneak |
| `+` / `_` | expand / shrink region | `<C-space>` (repeat to grow, `<BS>` to shrink) also works |
| `cs` / `ds` / `ys`, `S` (visual) | vim-surround | visual `S` taken back from flash |
| `<leader>J` | split/join (treesj) | |
| `[b` | jump to enclosing block start | buffers: `<S-h>` / `<S-l>` |
| `<A-j>` / `<A-k>` | move line/selection | LazyVim |
| `<leader>cw` | Whop: transform buffer (base64, json, hashes, ...) | |
| `<leader>fm` | format | alias of LazyVim's `<leader>cf` |

## Find

| Key | Action |
|---|---|
| `<leader>ff` / `<leader><space>` | files, including hidden; Git ignores still apply |
| `<leader>fa` | all files (hidden + ignored) |
| `<leader>fw` | grep |
| `<leader>fb` / `,,` | buffers |
| `<leader>fo` | recent files (LazyVim `<leader>fr`) |
| `<leader>fz` | search current buffer (LazyVim `<leader>sb`) |
| `<leader>fh` | help (LazyVim `<leader>sh`) |
| `<leader>sR` | resume last picker |

## File tree (neo-tree)

| Key | Action |
|---|---|
| `<C-n>` | toggle |
| `<leader>e` / `<leader>E` | toggle at project root / cwd |
| `<leader>ge` | git status tree |

## Git

| Key | Action |
|---|---|
| `]h` / `[h`, `]H` / `[H` | next/prev hunk, last/first hunk (`]c`/`[c` are free) |
| `<leader>hs` / `hr` | stage / reset hunk (also visual) |
| `<leader>hS` / `hR` / `hu` | stage buffer / reset buffer / undo stage |
| `<leader>hp` | preview hunk |
| `<leader>hb` / `hB` | blame line / blame buffer |
| `<leader>hd` / `hD` | diff this / diff against `~` |
| `ih` (operator/visual) | select hunk |
| `<leader>gb` | blame line |
| `<leader>tb` | toggle inline blame |
| `<leader>gs` `gl` `gc` `gp` `ga` `gup` `gbf` | fugitive: status, log, commit, push, amend, `git up`, blame file |
| `<leader>gd` `gD` `gh` `gH` `gx` | diffview: working tree, vs origin/main, file history, repo history, close |
| `<leader>gB` / `gY` | open in browser / copy URL (replaces gitlinker) |
| `<leader>gg` | lazygit |

## Tests, debugging, coverage

| Key | Action |
|---|---|
| `<leader>tr` / `<leader>tn` | run nearest |
| `<leader>tt` / `<leader>tf` | run file |
| `<leader>ts` / `to` / `tO` | summary / output / output panel |
| `<leader>td` / `<leader>df` | debug nearest / debug file |
| `<leader>tcl` / `tct` / `tcs` | coverage load / toggle / summary |
| `<leader>db` / `dc` / `dC` | breakpoint / continue / **run to cursor** |
| `<leader>di` / `dO` / `do` | step into / over / out |
| `<leader>dr` / `du` / `de` | REPL / DAP UI / eval |

## Diagnostics, LSP, UI

| Key | Action |
|---|---|
| `<leader>xx` / `xX` / `xL` / `xQ` | Trouble: diagnostics / buffer / loclist / quickfix |
| `<leader>cs` / `cS` | symbols / LSP references (Trouble) |
| `<leader>ca` / `cr` / `cl` | code action / rename / LSP info |
| `<leader>ul` / `uL` | toggle line numbers / relative numbers |
| `<leader>uz` / `uZ` | zen / zoom |
| `<leader>uC` | colorschemes (Omarchy sets the theme itself) |

## Other plugins

| Key | Action |
|---|---|
| `<leader>vp` / `vrl` / `vq` | tmux runner: prompt / re-run last / kill (outside herdr) |
| `<leader>rc` / `ro` / `rs` | review.nvim: add comment / open `.review.md` / refresh |
| `<leader>sc` (visual) | silicon screenshot to file |
| `<C-p>` | Obsidian quick switch |

## Removed on purpose

- Terminals (`<C-/>`, `<leader>ft`, `<leader>fT`, NvChad's `<A-h/v/i>`, `<C-x>`): tmux/herdr own terminals.
- NvChad `<leader>ma` (marks), `<leader>th` (themes), `<leader>n`/`<leader>rn`, `<leader>ch`, `<leader>ds`.
