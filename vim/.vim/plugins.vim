" Script for plugin settings
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

" NerdCommenter -----------------------
let g:NERDCommentEmptyLines = 1

" Airline ------------------------------
let g:airline_powerline_fonts = 1
let g:airline_theme = 'bubblegum'
let g:airline#extensions#whitespace#enabled = 0

" Snippets ----------------------------
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<c-f>"
"let g:UltiSnipsJumpBackwardTrigger="<c-d>"

" If you want :UltiSnipsEdit to split your window.
"let g:UltiSnipsEditSplit="vertical"

if $TERM=='screen-256color'
    let g:oscyank_term = 'tmux'
else
    let g:oscyank_term = 'kitty'
endif

" Settings for indentLine
let g:vim_json_syntax = 0
let g:indentLine_concealcursor = ""
let g:indentLIne_conceallevel = 2

" For kitty
"let &t_ut=''
" for screen loading
"set t_vb=

" For fzf
" Border style (rounded / sharp / horizontal)
"let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Todo', 'border': 'sharp' } }
