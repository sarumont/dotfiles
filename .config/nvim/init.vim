" vim-plug {{{
call plug#begin('~/.config/nvim/.plugins')

" Visual
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'

" Misc
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'numkil/ag.nvim'
Plug 'tpope/vim-fugitive'
Plug 'terryma/vim-expand-region'
Plug 'sunaku/vim-dasht', { 'on': 'Dasht' }
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'vim-scripts/YankRing.vim', { 'on': 'YRShow' }

" Code 
Plug 'w0rp/ale'
Plug 'scrooloose/nerdcommenter' 
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

" Navigation
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'easymotion/vim-easymotion'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'

" Filetype
Plug 'PProvost/vim-ps1'
Plug 'othree/jsdoc-syntax.vim'
Plug 'mustache/vim-mustache-handlebars'

call plug#end()
"}}}

" misc {{{
let mapleader = ","
let g:mapleader = ","
filetype plugin indent on
let g:yankring_history_file='.yankring_history'
let g:notes_directories = [$HOME . "/.local/share/vim/notes"]
let g:agprg="ag --nocolor --nogroup --column --smart-case"
set wildignore=*/generated/*,.git,*.pyc,.svn,*.jar,*.class,*.un~,*.swp,*.swo,*.png,*.jpg,*.ttf,*.woff,*/javadoc/*,*.gif,*.ogg,*.mp3,*.mp4,*/node_modules/*
set ignorecase
set smartcase
set nohlsearch
set clipboard=unnamed
set title

if exists('$TMUX')
    autocmd BufEnter * call system("tmux rename-window '" . expand("%:t") . "'")
    autocmd VimLeave * call system("tmux setw automatic-rename")
endif

if has("unix")
    let s:uname = system("echo -n \"$(uname)\"")
    if s:uname == "Darwin"
        nnoremap <silent> <Leader>pp :set paste<cr>$:r ! pbpaste <cr>:set nopaste<cr>$
        let g:gist_clip_command = 'pbcopy'
    else
        nnoremap <silent> <Leader>pp :set paste<cr>$:r ! xclip -o<cr>:set nopaste<cr>$
        nnoremap <silent> <Leader>pv :set paste<cr>$:r ! xclip -selection clipboard -o<cr>:set nopaste<cr>$
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

colorscheme onedark

" Lightline
set laststatus=2
set noshowmode
let g:lightline = {
            \ 'colorscheme': 'onedark',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
            \   'right': [ [ 'lineinfo' ],
            \              [ 'percent' ],
            \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] ]
            \ },
            \ 'component': {
            \   'charvaluehex': '0x%B'
            \ },
            \ 'component_function': {
            \   'gitbranch': 'fugitive#head'
            \ },
            \ }
"}}}

" Indentation {{{
set copyindent
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
" }}}

" Tags {{{
let g:gutentags_ctags_tagfile = '.tags'
" let g:gutentags_modules = ['ctags', 'cscope']
" }}}

"{{{ Keymaps 

" coc / omni
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()
imap <silent> <C-x><C-o> <Plug>(coc-complete-custom)

nnoremap <silent> <Leader>a :Ag! 

" Windows 
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

" easymotion
let g:EasyMotion_smartcase = 1
nmap f <Plug>(easymotion-overwin-f2)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader> <Plug>(easymotion-prefix)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

" NERDTree
:map <C-I> :NERDTreeToggle<cr>

:map <C-Tab> :tabnext<cr>
:map <C-S-Tab> :tabprev<cr>

:map <Leader>h :set hlsearch!<cr>

" git
nnoremap <silent> <Leader>mc I:twisted_rightwards_arrows: <esc>

nnoremap <silent> <Leader>gd :Gdiff<cr>
nnoremap <silent> <Leader>gl :Glog<cr>
nnoremap <silent> <Leader>gs :Gstatus<cr>
nnoremap <silent> <Leader>gb :Gblame<cr>
nnoremap <silent> <Leader>gc :Gcommit<cr>
nnoremap <silent> <Leader>gp :Gpush<cr>
nnoremap <silent> <Leader>amend :Git commit --amend<cr>
nnoremap <silent> <Leader>stash :Git stash<cr>
nnoremap <silent> <Leader>pop :Git stash pop<cr>

nnoremap <silent> <F12> :TagbarOpen fjc<cr>

" Code miscellany
nnoremap <silent> <Leader>pj :%!python -m json.tool<cr>

" Dasht

" search related docsets
" nnoremap <Leader>k :Dasht<Space>
" nnoremap <Leader><Leader>k :Dasht!<Space>

" Search docsets for words under cursor:
" nnoremap <silent> <Leader>K :call Dasht([expand('<cword>'), expand('<cWORD>')])<Return>
" nnoremap <silent> <Leader><Leader>K :call Dasht([expand('<cword>'), expand('<cWORD>')], '!')<Return>

" Search docsets for your selected text:
" vnoremap <silent> <Leader>K y:<C-U>call Dasht(getreg(0))<Return>
" vnoremap <silent> <Leader><Leader>K y:<C-U>call Dasht(getreg(0), '!')<Return>

nnoremap <silent> <Leader>yr :YRShow<cr>

"}}}

" CtrlP {{{
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_by_filename = 1
" }}}

" NERDCommenter {{{
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDTrimTrailingWhitespace = 1
" }}}

" Gist {{{
let g:gist_show_privates = 1
let g:gist_post_private = 1
let g:gist_update_on_write = 2
" }}}

" vim:foldmethod=marker:foldlevel=0
