" vim-plug {{{
call plug#begin('~/.config/nvim/.plugins')

" VSCode LSP completion
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

Plug 'easymotion/vim-easymotion'

Plug 'joshdick/onedark.vim'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'itchyny/lightline.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'numkil/ag.nvim'
Plug 'scrooloose/nerdcommenter' 
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-fugitive'
Plug 'terryma/vim-expand-region'
Plug 'airblade/vim-gitgutter'
Plug 'majutsushi/tagbar'
Plug 'w0rp/ale'

call plug#end()
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

" misc {{{
filetype plugin indent on
let g:yankring_history_file='.yankring_history'
let g:notes_directories = [$HOME . "/.local/share/vim/notes"]
let g:agprg="ag --nocolor --nogroup --column --smart-case"
set wildignore=*/generated/*,.git,*.pyc,.svn,*.jar,*.class,*.un~,*.swp,*.swo,*.png,*.jpg,*.ttf,*.woff,*/javadoc/*,*.gif,*.ogg,*.mp3,*.mp4,*/node_modules/*
set smartcase
set nohlsearch
"}}}

" Tags {{{
let g:gutentags_ctags_tagile = '.tags'
" }}}

"{{{ Keymaps 
let mapleader = ","
let g:mapleader = ","

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
nnoremap <silent> <Leader>GC :Git svn dcommit<cr>
nnoremap <silent> <Leader>GR :Git svn rebase<cr>:CommandTFlush<cr>
nnoremap <silent> <Leader>amend :Git commit --amend<cr>
nnoremap <silent> <Leader>stash :Git stash<cr>
nnoremap <silent> <Leader>pop :Git stash pop<cr>

nnoremap <silent> <Leader>o :TagbarToggle<cr>

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

" vim:foldmethod=marker:foldlevel=0
