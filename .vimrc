" This is a modified file from the following repo
" Fisa-vim-config
" http://fisadev.github.io/fisa-vim-config/
" version: 8.3.1

let vim_plug_just_installed = 0
let vim_plug_path = expand('~/.vim/autoload/plug.vim')
if !filereadable(vim_plug_path)
    echo "Installing Vim-plug..."
    echo ""
    silent !mkdir -p ~/.vim/autoload
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let vim_plug_just_installed = 1
endif

if vim_plug_just_installed
    :execute 'source '.fnameescape(vim_plug_path)
endif

" Active plugins
call plug#begin('~/.vim/plugged')
" Surroundings
Plug 'tpope/vim-surround'
" Fuzzy match
Plug 'ctrlpvim/ctrlp.vim'
" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Vim-fugitive (for git integration)
Plug 'tpope/vim-fugitive'
" Better file browser
Plug 'scrooloose/nerdtree'
" Code commenter
Plug 'scrooloose/nerdcommenter'
" Yank history navigation
Plug 'vim-scripts/YankRing.vim'
" Git/mercurial/others diff icons on the side of the file lines
Plug 'mhinz/vim-signify'
" vimwiki
Plug 'vimwiki/vimwiki'
" colorscheme for gruvbox
Plug 'morhetz/gruvbox'
" auto pairs
Plug 'jiangmiao/auto-pairs'
" Completion with Tab
Plug 'ervandew/supertab'
call plug#end()

" Install plugins the first time vim runs
if vim_plug_just_installed
    echo "Installing Bundles, please ignore key map error messages"
    :PlugInstall
endif

" Vim settings and mappings
" no vi-compatible
set nocompatible
" allow plugins by file type (required for plugins!)
filetype plugin on
filetype indent on
" set number and relativenumber
set number relativenumber
" tabs and spaces handling
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
" tab length exceptions on some file types
autocmd FileType html setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType htmldjango setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType javascript setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4
" always show status bar
set ls=2
" incremental search
set incsearch
" highlighted search results
set hlsearch
" syntax highlight on
syntax on
" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=3
" navigate windows with meta+hjkl
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" run current python script
nnoremap <buffer> <F9> :w<CR>:!clear;python3 %<CR>
" set up colorscheme
set bg=dark
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox
" autocompletion of files and commands behaves like shell
set wildmode=list:longest
" better backup, swap and undos storage
set directory=~/.vim/dirs/tmp     " directory to place swap files in
set backup                        " make backup files
set backupdir=~/.vim/dirs/backups " where to put backup files
set undofile                      " persistent undos - undo after you re-open the file
set undodir=~/.vim/dirs/undos
set viminfo+=n~/.vim/dirs/viminfo
" store yankring history file there too
let g:yankring_history_dir = '~/.vim/dirs/'
" create needed directories if they don't exist
if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
endif
if !isdirectory(&directory)
    call mkdir(&directory, "p")
endif
if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif

" NERDTree ----------------------------- 
" toggle nerdtree display
map <F3> :NERDTreeToggle<CR>
" open nerdtree with the current file selected
nmap ,t :NERDTreeFind<CR>
" don;t show these file types
let NERDTreeIgnore = ['\.pyc$', '\.pyo$']

" vimwiki -----------------------------
let g:vimwiki_list = [{'path': '~/', 
                     \ 'syntax': 'markdown', 'ext': '.md'}]
" Airline ------------------------------
let g:airline_powerline_fonts = 0
let g:airline_theme = 'bubblegum'
let g:airline#extensions#whitespace#enabled = 0
