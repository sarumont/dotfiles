" vim-plug {{{
call plug#begin('~/.config/nvim/.plugins')

" Visual
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'rakr/vim-one'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ryanoasis/vim-devicons'
Plug 'machakann/vim-highlightedyank'

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
" Plug 'ervandew/supertab'

" Code 
Plug 'scrooloose/nerdcommenter' 
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'adelarsq/vim-matchit'
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'roryokane/detectindent'
Plug 'pedrohdz/vim-yaml-folds'

" Navigation
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
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

call plug#end()
"}}}

" misc {{{
let mapleader = ","
let g:mapleader = ","
filetype plugin indent on
let g:notes_directories = [$HOME . "/.local/share/vim/notes"]
let g:agprg="ag --nocolor --nogroup --column --smart-case"
set wildignore=*/generated/*,*/.git/*,*.pyc,.svn,*.jar,*.class,*.un~,*.swp,*.swo,*.png,*.jpg,*.ttf,*.woff,*/javadoc/*,*.gif,*.ogg,*.mp3,*.mp4,*/node_modules/*
set ignorecase
set smartcase
set nohlsearch
set title
set formatoptions=croqlj
set number
set lazyredraw

" watch for file changes
au CursorHold,CursorHoldI,WinEnter,BufWinEnter * checktime

" TMUX renaming
" if exists('$TMUX')
    " autocmd BufEnter * call system("tmux rename-window '" . expand("%:t") . "'")
    " autocmd VimLeave * call system("tmux setw automatic-rename")
" endif

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

colorscheme one
let g:one_allow_italics = 1 
let g:onedark_terminal_italics=1
exec "source " . $HOME . "/.config/nvim/bg.vim"
set cursorline
set colorcolumn=120

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
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

let g:VimuxHeight = "30"

"}}}

" Code Formatting {{{

autocmd FileType yaml set foldlevel=2
let g:sql_type_default = 'pgsql'

" }}}

" Indentation {{{
set copyindent
set expandtab       " default to hard tabs
set shiftwidth=4    " shift operation == tabstob
set tabstop=4       " show tabs as 4 spaces
set softtabstop=4   " soft tab == 4 spaces

augroup DetectIndent
    autocmd!
    autocmd BufReadPost *  DetectIndent
augroup END
" }}}

" Tags {{{
let g:gutentags_ctags_tagfile = '.tags'
" let g:gutentags_modules = ['ctags', 'cscope']
" }}}

" CoC {{{
" inoremap <silent><expr> <TAB>
            " \ pumvisible() ? "\<C-n>" :
            " \ <SID>check_back_space() ? "\<TAB>" :
            " \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()
imap <silent> <C-x><C-o> <Plug>(coc-complete-custom)

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

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
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'
nnoremap <silent> <C-p> :Files<cr>
" }}}

"{{{ Navigation

" Windows 
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

let g:sneak#label = 1
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

"}}}

"{{{ Keymaps 
" nnoremap <silent> <Leader>a :Ag!
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
nnoremap <silent> <Leader>gs :Gstatus<cr>
nnoremap <silent> <Leader>gb :Gblame -w -M<cr>
nnoremap <silent> <Leader>gc :Gcommit<cr>
nnoremap <silent> <Leader>gp :Gpush<cr>
nnoremap <silent> <Leader>amend :Git commit --amend<cr>
nnoremap <silent> <Leader>stash :Git stash<cr>
nnoremap <silent> <Leader>pop :Git stash pop<cr>

" IntelliJ IDEA-like keymaps
nnoremap <silent> <F2> :w<cr>:cNext<cr>
nnoremap <silent> <S-F2> :w<cr>:cPrev<cr>
nnoremap <silent> <F12> :TagbarOpen fjc<cr>

" Code miscellany
nnoremap <silent> <Leader>pj :%!python -m json.tool<cr>
nnoremap <silent> <Leader>fi :CocCommand java.action.organizeImports<cr>

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

nnoremap <Leader>vgp  :VimuxPromptCommand("gradlew ")<CR>
nnoremap <Leader>vgf :VimuxRunCommand("gradlew clean build publishToMavenLocal")<CR>

nnoremap <Leader>vmp  :VimuxPromptCommand("mvn ")<CR>
nnoremap <Leader>vmf  :VimuxPromptCommand("mvn clean install")<CR>

nnoremap <Leader>vq  :VimuxCloseRunner<CR>
nnoremap <Leader>vz  :VimuxZoomRunner<CR>

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
" }}}

" vim:foldmethod=marker:foldlevel=0
