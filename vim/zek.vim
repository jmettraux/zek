
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

let g:_zek_rb = fnamemodify(
  \ fnamemodify(resolve(expand('<sfile>:p')), ':p:h') . '/../lib/zek.rb',
  \ ':p')


"
" load $zek_vim_dir/zek/**/*.vim

let zek_vim_dir = fnamemodify(resolve(expand('<sfile>:p')), ':p:h')
exe 'set runtimepath+=' . zek_vim_dir

"echo "g:_zek_ruby" g:_zek_ruby
"echo "g:_zek_rb" g:_zek_rb
"echo "zek_vim_dir" zek_vim_dir

runtime! zek/**/*.vim

