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

" vimwiki -----------------------------
let g:vimwiki_list = [{'path': '~/',
                     \ 'template_path': '~/vimwiki/templates/',
                     \ 'template_default': 'default',
                     \ 'path_html': '~/vimwiki_html/',
                     \ 'syntax': 'markdown', 'ext': '.md',
                     \ 'custom_wiki2html': 'vimwiki_markdown',
                     \ 'template_ext': '.tpl'}]
" Airline ------------------------------
let g:airline_powerline_fonts = 1
let g:airline_theme = 'bubblegum'
let g:airline#extensions#whitespace#enabled = 0

" Syntastic ----------------------------
let g:syntastic_mode_map = {'mode': 'passive',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': [] }

" Snippets ----------------------------
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-d>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

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
let &t_ut=''
" for screen loading
set t_vb=

" For fzf
" Border style (rounded / sharp / horizontal)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Todo', 'border': 'sharp' } }
