
"
" zek/commands.vim

function! s:ZekRun(lines)

  let @z = system(g:_zek_ruby . ' ' . g:_zek_rb, a:lines)
  echo @z

  "if v:shell_error == 0
  "  echo "Command succeeded"
  "else
  "  echo "Command failed with exit status" v:shell_error
  "endif
endfunction " ZekRun

function! s:ZekMake() range

  let ls = [ 'make' ] + getline(a:firstline, a:lastline)

  call <SID>ZekRun(ls)

  " TODO

endfunction " ZekMake

vnoremap <buffer> zz :call <SID>ZekMake()


function! s:ZekIndex() range

  " TODO

endfunction " ZekIndex

command! -nargs=0 ZekIndex :call <SID>ZekIndex()

