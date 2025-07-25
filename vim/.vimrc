" Check if vim-plug is installed, if not install it
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
" colorscheme for gruvbox
Plug 'morhetz/gruvbox'

" --- Key bindings and Typing
" auto pairs
Plug 'jiangmiao/auto-pairs'
" Code commenter
Plug 'scrooloose/nerdcommenter'
" vim repeat
Plug 'tpope/vim-repeat'
" Fuzzy finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Indent lines with a character
Plug 'junegunn/fzf.vim'
" NerdTree
Plug 'preservim/nerdtree'

" --- Syntax
" Trailing white-space
Plug 'bronson/vim-trailing-whitespace'
" For git diff on files
Plug 'mhinz/vim-signify'
" Show tabs
Plug 'Yggdroot/indentLine'
" Autocomplete with tabs
Plug 'ervandew/supertab'

" --- Storage
" Yank history navigation
Plug 'vim-scripts/YankRing.vim'

" --- Aesthetics
" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Vim-figutive (for git integration)
Plug 'tpope/vim-fugitive'

" --- Copying
" For copying
Plug 'ojroques/vim-oscyank', {'branch': 'main'}
" For pasting
Plug 'ConradIrwin/vim-bracketed-paste'
call plug#end()

" Install plugins the first time vim runs
if vim_plug_just_installed
    echo "Installing Bundles, please ignore key map error messages"
    :PlugInstall
endif

" Vim settings and mappings
" no vi-compatible
set nocompatible
set backspace=0" Set no backspace for new lines or tabs
set mouse=" Fuck mouse in vim
set nowrap
set number relativenumber
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set cursorline
set culopt=number
set colorcolumn=80,100
set ls=2" always show status bar
set incsearch
set hlsearch
set splitbelow
set splitright
set list" show tabs and linefeeds
set listchars=eol:¬
set scrolloff=5
set novisualbell" For visualbell
syntax on
filetype plugin on
filetype indent on
highlight ColorColumn ctermbg=None guibg=lightgrey
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType htmldjango setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType javascript setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4

" set up colorscheme
set bg=dark
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox
hi Normal guibg=NONE ctermbg=NONE
" Spell check
"set spell spelllang=en
" autocompletion of files and commands behaves like shell
set wildmode=list:longest
" better backup, swap and undos storage
set directory=~/.vim/dirs/tmp     " directory to place swap files in
set backup                        " make backup files
set backupdir=~/.vim/dirs/backups " where to put backup files
set undofile                      " persistent undos - undo after you re-open the file
set undodir=~/.vim/dirs/undos
set viminfo+=n~/.vim/dirs/viminfo

" This script contains plugin configurations
source ~/.vim/plugins.vim
" This scrip contains mappings
source ~/.vim/mapping.vim
" This script is for higlights
source ~/.vim/highlight.vim

" Snippets are separated from the engine. Add this if you want them
"Plug 'honza/vim-snippets'
" Track the engine.
"Plug 'SirVer/ultisnips'
" HTML
"Plug 'adelarsq/vim-matchit'
" Coc.nvim
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Check the following resources:
" https://github.com/fannheyward/coc-pyright
" https://github.com/neoclide/coc.nvim
