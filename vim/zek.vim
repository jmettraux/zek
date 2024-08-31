
"
" zek.vim
"
" cd ~/.vim/scripts && ln -s ~/zek/vim/zek.vim .


"
" find a local Ruby

let g:_zek_ruby = $ZEK_RUBY
  "
if empty(g:_zek_ruby)
  let rubies = glob('/usr/local/bin/ruby*', 0, 1)
  let rubies = filter(rubies, { idx, val -> val =~# 'ruby\d*$' })
  let g:_zek_ruby = reverse(sort(rubies))[0]
endif

let g:_zek_rb = expand('%:p:h') . '/lib/zek.rb'


"
" load $zek/vim/zek/*.vim

exe 'set runtimepath+=' . expand('%:p:h') . '/vim'

runtime! zek/**/*.vim

