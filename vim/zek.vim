
"
" zek.vim
"
" cd ~/.vim/scripts && ln -s ~/zek/vim/zek.vim .

" TODO

echo expand('%')
echo expand('%:p')
echo expand('%:p:h')
exe 'runtime! ' . expand('%:p:h') . '/**/zek/*.vim'
exe 'source ' . expand('%:p:h') . '/**/zek/*.vim'

