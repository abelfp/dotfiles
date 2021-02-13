" Mappings for vim
" navigate windows with meta+hjkl
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" Source vimrc
map ,re :source $MYVIMRC<CR>
" check syntax
nnoremap <leader>E :SyntasticCheck<CR>
nnoremap <leader>R :SyntasticReset<CR>
" For copying with leader k
vnoremap <leader>k :OSCYank<CR>
" Fuzzy finding Gfiles
nnoremap <leader>p :GFiles<CR>
" shortcut to formatting line
nnoremap <leader>l v0o$gq
" run current python script
nnoremap <F9> :w<CR>:!clear;python3 %<CR>
