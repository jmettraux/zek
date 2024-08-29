
"
" zek/commands.vim

function! s:ZekMake() range

  let lib = expand('%:p:h') . '/lib'

  let ls = [ 'make' ] + getline(a:firstline, a:lastline)

  let @z = system(g:_zek_ruby . ' -I ' . lib . ' ' . lib . '/zek.rb', ls)
  echo @z

endfunction " ZekMake

vnoremap <buffer> zz :call <SID>ZekMake()

