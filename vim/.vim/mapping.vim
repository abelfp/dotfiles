" Mappings for vim
" navigate windows with meta+hjkl
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" Source vimrc
map ,re :source $MYVIMRC<CR>
" For copying with leader k
vnoremap <leader>k :OSCYankVisual<CR>
" Fuzzy finding Gfiles
nnoremap <leader>p :GFiles<CR>
" shortcut to formatting line
nnoremap <leader>l v0o$gq
