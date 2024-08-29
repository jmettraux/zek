
"
" zek.vim
"
" cd ~/.vim/scripts && ln -s ~/zek/vim/zek.vim .


let g:_zek_ruby = 'ruby33'
  " FIXME somehow, fetch some ruby...


exe 'set runtimepath+=' . expand('%:p:h') . '/vim'

runtime! zek/**/*.vim

