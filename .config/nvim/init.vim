" vim-plug {{{
call plug#begin('~/.config/nvim/.plugins')

" Visual
Plug 'rakr/vim-one'
Plug 'itchyny/lightline.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ryanoasis/vim-devicons'
Plug 'machakann/vim-highlightedyank'
Plug 'pangloss/vim-javascript'
Plug 'justincampbell/vim-eighties'

" Misc
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'tpope/vim-fugitive'
Plug 'terryma/vim-expand-region'
Plug 'sunaku/vim-dasht'
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'junegunn/vim-peekaboo'
Plug 'embear/vim-localvimrc'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'mtth/scratch.vim'
Plug 'junegunn/goyo.vim'
Plug 'mbbill/undotree'

" Code 
Plug 'scrooloose/nerdcommenter' 
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'adelarsq/vim-matchit'
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-sleuth'
Plug 'pedrohdz/vim-yaml-folds'
Plug 'stephpy/vim-yaml'

" Navigation
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'

" Filetype
Plug 'sheerun/vim-polyglot'
Plug 'lifepillar/pgsql.vim'

" Utility
Plug 'benmills/vimux'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" put this at the end to map <Tab> last
" Plug 'ervandew/supertab'

call plug#end()
"}}}

" misc {{{
let mapleader = ","
let g:mapleader = ","
filetype plugin indent on
let g:notes_directories = [$HOME . "/.local/share/vim/notes"]
set wildignore=*/generated/*,*/.git/*,*.pyc,.svn,*.jar,*.class,*.un~,*.swp,*.swo,*.png,*.jpg,*.ttf,*.woff,*/javadoc/*,*.gif,*.ogg,*.mp3,*.mp4,*/node_modules/*
set ignorecase
set smartcase
set nohlsearch
set title
set formatoptions=croqlj
set number
set lazyredraw
set splitright
set splitbelow
let g:omni_sql_no_default_maps = 1
let g:gist_token = $GITHUB_GIST_TOKEN

" watch for file changes
au CursorHold,CursorHoldI,WinEnter,BufWinEnter * checktime

" TMUX renaming
if exists('$TMUX') 
  if $TMUX_SESSION_NAME == 'dev'
    " in my 'dev' terminal, I just want my tmux window to have the name of the
    " project (i.e. - the directory). Having 3 windows with titles README.md
    " doesn't really help me to navigate...
    call system("tmux rename-window '" . fnamemodify(getcwd(), ':t') . "'")
  else
    autocmd BufEnter * call system("tmux rename-window '" . expand("%:t") . "'")
    autocmd VimLeave * call system("tmux setw automatic-rename")
  endif
endif

" system clipboard integration
set clipboard=unnamedplus
if has("unix")
    let s:uname = system("echo -n \"$(uname)\"")
    if s:uname == "Darwin"
        nnoremap <silent> <Leader>pp :set paste<cr>$:r ! pbpaste <cr>:set nopaste<cr>$
        let g:gist_clip_command = 'pbcopy'
    else
        nnoremap <silent> <Leader>pp :set paste<cr>$:r ! xclip -o -selection clipboard<cr>:set nopaste<cr>$
        let g:gist_clip_command = 'xclip -selection clipboard'
    endif
endif

" When editing a file, always jump to the last cursor position
au BufReadPost *
			\ if &ft == 'gitcommit' || &ft == 'mail' |
			\   exe "normal! gg" |
			\   exe "startinsert" |
			\ elseif line("'\"") > 1 && line ("'\"") <= line("$") |
			\   exe "normal! g`\"" |
			\ endif

let g:localvimrc_sandbox=0
let g:localvimrc_persistent=2

:command Writemode setlocal spell | Goyo 100
:command Codemode set nospell | Goyo!

let g:SuperTabDefaultCompletionType = "<c-n>"

set undodir=~/.local/share/vim/undo/
set undofile

"}}}

" Visuals {{{

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
    set termguicolors
endif

let g:gruvbox_italic=1
let g:one_allow_italics=1
colorscheme one
set background=dark

" automatically set background mode based on xorg settings
function! SetBackgroundMode(...)
  let s:new_bg = "dark"
  let s:dark = systemlist('grep -i dark ~/.xsettingsd.theme')
  if len(s:dark) == 0
    let s:new_bg = "light"
  else
    let s:new_bg = "dark"
  endif
  if &background !=? s:new_bg
    let &background = s:new_bg
  endif
endfunction
call SetBackgroundMode()
call timer_start(3000, "SetBackgroundMode", {"repeat": -1})

set cursorline
set colorcolumn=100

" Lightline
set laststatus=2
set noshowmode
let g:lightline = {
            \ 'colorscheme': 'one',
            \ 'active': {
            \   'left':  [ [ 'mode', 'paste' ],
            \              [ 'gitbranch', 'readonly', 'filename', 'modified', 'cocstatus' ] ],
            \   'right': [ [ 'lineinfo' ],
            \              [ 'percent' ],
            \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] ]
            \ },
            \ 'component': {
            \   'charvaluehex': '0x%B'
            \ },
            \ 'component_function': {
            \   'gitbranch': 'fugitive#head',
            \   'cocstatus': 'coc#status'
            \ },
            \ }

" IndentGuides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'fzf']

let g:eighties_enabled = 1
let g:eighties_minimum_width = 100
let g:eighties_extra_width = 20
let g:eighties_compute = 1
let g:eighties_bufname_additional_patterns = ['fugitiveblame', 'nerdtree', 'fzf', 'help']

let g:VimuxHeight = "30"

let g:javascript_plugin_jsdoc = 1

"}}}

" Code Formatting {{{

autocmd FileType yaml set foldlevel=2
let g:sql_type_default = 'pgsql'

" }}}

" Indentation {{{
set copyindent
set expandtab       " default to soft tabs
set shiftwidth=2    " shift operation == tabstob
set tabstop=2       " show tabs as 4 spaces
set softtabstop=2   " soft tab == 4 spaces
" }}}

" Tags {{{
let g:gutentags_ctags_tagfile = '.tags'
" let g:gutentags_modules = ['ctags', 'cscope']
" }}}

" CoC {{{
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" inoremap <silent><expr> <TAB>
      " \ pumvisible() ? "\<C-n>" :
      " \ <SID>check_back_space() ? "\<TAB>" :
      " \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
  " let col = col('.') - 1
  " return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

inoremap <silent><expr> <c-space> coc#refresh()
imap <silent> <C-x><C-o> <Plug>(coc-complete-custom)

nnoremap <silent> <Leader>fi :CocCommand java.action.organizeImports<cr>

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use `[c` and `]c` to navigate conflicts
nmap <silent> [c <Plug>(coc-git-prevconflict)
nmap <silent> ]c <Plug>(coc-git-nextconflict)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

nmap <leader>f  <Plug>(coc-format-selected)

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" show yank history
nnoremap <silent> <Leader>yr  :<C-u>CocList -A --normal yank<cr>
" }}}

"{{{ FZF 
let $FZF_DEFAULT_COMMAND = 'TERM=dumb rg --files --hidden  --smart-case --search-zip'
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.5, 'yoffset': 1, 'border': 'top' } }
nnoremap <silent> <C-p> :Files<cr>
nnoremap <silent> <leader>bt :BTags<cr>
nnoremap <silent> <Leader>rg :Rg 

let $FZF_DEFAULT_OPTS=' --color=dark --info=inline --margin 1,4 --color=gutter:-1,marker:4,hl:1,hl+:1 --layout=reverse'
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)

  let height = float2nr(30)
  let width = max([float2nr(&columns * 0.75), min([80, &columns])])
  let horizontal = float2nr((&columns - width) / 2)
  let vertical = 0

  let opts = {
        \ 'relative': 'cursor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
" }}}

"{{{ Navigation

" Windows 
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

noremap Zz <c-w>_ \| <c-w>\|
noremap Zo <c-w>=

let g:sneak#label = 1
let g:sneak#use_ic_scs = 1

let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

" Run a given vim command on the results of alt from a given path.
" See usage below.
function! GetJavaAlts(path, vim_command)
  let l:alternate = systemlist("fdfind -c never -HI '.*" . expand('%:t:r') . ".*.java' -E '" . expand('%:t') . "'")
  if empty(l:alternate)
    echo "No alternate file for " . a:path . " exists!"
  else
    for i in l:alternate
      exec a:vim_command . " " . i
    endfor
  endif
endfunction

" Find the alternate file for the current path and open it
nnoremap <leader>. :w<cr>:call GetJavaAlts(expand('%'), ':vsplit')<cr>

"}}}

"{{{ Keymaps 
"
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" NERDTree
:map <C-I> :NERDTreeToggle<cr>

:map <C-Tab> :tabnext<cr>
:map <C-S-Tab> :tabprev<cr>

:map <Leader>h :set hlsearch!<cr>
:map <Leader>p :set paste!<cr>

" git
nnoremap <silent> <Leader>mc I🔀 <esc>

nnoremap <silent> <Leader>gd :Gdiff<cr>
nnoremap <silent> <Leader>gl :Glog<cr>
nnoremap <silent> <Leader>gs :Git<cr>
nnoremap <silent> <Leader>gb :Gblame -w -M<cr>
nnoremap <silent> <Leader>gc :Git commit<cr>
nnoremap <silent> <Leader>gp :Git push<cr>
nnoremap <silent> <Leader>gup :Git up<cr>
nnoremap <silent> <Leader>amend :Git commit --amend<cr>
nnoremap <silent> <Leader>stash :Git stash<cr>
nnoremap <silent> <Leader>pop :Git stash pop<cr>

" navigate changed hunks
nmap <silent> <Leader>hi <Plug>(coc-git-chunkinfo)
nmap <silent> <Leader>hn <Plug>(coc-git-nextchunk)
nmap <silent> <Leader>hp <Plug>(coc-git-prevchunk)
nmap <silent> <Leader>hs <Plug>(coc-git-chunkstage)
nmap <silent> <Leader>hu <Plug>(coc-git-chunkundo)

" IntelliJ IDEA-like keymaps
nnoremap <silent> <F2> :w<cr>:cNext<cr>
nnoremap <silent> <S-F2> :w<cr>:cPrev<cr>
nnoremap <silent> <F12> :TagbarOpen fjc<cr>

" Code miscellany
nnoremap <silent> <Leader>pj :%!python -m json.tool<cr>

nnoremap <silent> <Leader><Leader>sc :Scratch<cr>

" Dasht

" search related docsets
" nnoremap <Leader>k :Dasht<Space>
" nnoremap <Leader><Leader>k :Dasht!<Space>

" Search docsets for words under cursor:
" nnoremap <silent> <Leader>K :call Dasht([expand('<cword>'), expand('<cWORD>')])<Return>
nnoremap <silent> <Leader><Leader>K :call Dasht([expand('<cword>'), expand('<cWORD>')], '!')<Return>

" Search docsets for your selected text:
" vnoremap <silent> <Leader>K y:<C-U>call Dasht(getreg(0))<Return>
vnoremap <silent> <Leader><Leader>K y:<C-U>call Dasht(getreg(0), '!')<Return>

" vim-notes
nnoremap <silent> <Leader>d ^wiDONE <esc> :r! date +" [\%H:\%M]"<ENTER>kJA<Esc>$

" Vimux
nnoremap <silent> <Leader>rl :wa<cr>:VimuxRunLastCommand<cr>
nnoremap <Leader>vp  :VimuxPromptCommand<CR>

nnoremap <Leader>vgp  :VimuxPromptCommand('gradlew ')<CR>
nnoremap <Leader>vgf :VimuxRunCommand('gradlew clean build publishToMavenLocal')<CR>

nnoremap <Leader>vmp  :VimuxPromptCommand('mvn ')<CR>
nnoremap <Leader>vmf  :VimuxPromptCommand('mvn clean install')<CR>

nnoremap <Leader>vnp  :VimuxPromptCommand('npm run ')<CR>

nnoremap <Leader>vnb  :VimuxRunCommand("npm run build")<CR>
nnoremap <Leader>vncb  :VimuxRunCommand("npm run clean && npm run build")<CR>
nnoremap <Leader>vnit  :VimuxRunCommand("npm run test:integration")<CR>
nnoremap <Leader>vnut  :VimuxRunCommand("npm run test:unit")<CR>

nnoremap <Leader>vq  :VimuxCloseRunner<CR>
nnoremap <Leader>vz  :VimuxZoomRunner<CR>

nnoremap <Leader><Leader>vtp :VimuxRunCommand("export DISABLE_AUTO_TITLE=true")<CR>:call system("tmux rename-window '" . fnamemodify(getcwd(), ':t') . "'")<cr>

"}}}

" NERD {{{
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDTrimTrailingWhitespace = 1

let g:NERDTreeWinSize = 50
" }}}

" Gist {{{
let g:gist_show_privates = 1
let g:gist_post_private = 1
let g:gist_update_on_write = 2
" }}}

" UltiSnips {{{
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=['UltiSnips', $HOME . "/.local/share/vim/vim-snippets"]

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" }}}

" vim:foldmethod=marker:foldlevel=0
