
"
" zek/commands.vim

"
" ~protected~

function! s:ZekRun(cmd, lines)

  let @z = system(g:_zek_ruby . ' ' . g:_zek_rb . ' ' . a:cmd, a:lines)
  echo @z

  if v:shell_error == 0
    echo "Command succeeded"
  else
    echo "Command failed with exit status" v:shell_error
  endif
endfunction " ZekRun


"
" ~public~

" Create a new note
"
function! s:ZekMake() range

  let ls = getline(a:firstline, a:lastline)

  call <SID>ZekRun('make', ls)

  " TODO

endfunction " ZekMake

vnoremap zz :call <SID>ZekMake()


" Fetch one note
"
function! s:ZekFetch(...)

  " TODO
  echo a:000
  "for arg in a:000
  "  echo arg
  "endfor

endfunction " ZekFetch

command! -nargs=* ZekFetch :call <SID>ZekFetch(<f-args>)

function! s:ZekTrees(...)

  "call <SID>ZekRun('trees ' . a:000, [])
  call <SID>ZekRun('trees', [])

endfunction " ZekTrees

command! -nargs=* ZekTrees :call <SID>ZekTrees(<f-args>)


" Fetch a list of notes
"
function! s:ZekList(flavour)

  call <SID>ZekRun('list ' . a:flavour, [])

endfunction " ZekList

command! -nargs=* ZekList :call <SID>ZekList(<f-args>)


" Trigger Zek indexation of the repository
"
function! s:ZekIndex()

  call <SID>ZekRun('index', [])

endfunction " ZekIndex

command! -nargs=0 ZekIndex :call <SID>ZekIndex()


" dev helper
"
function! s:ZekArgs(...)

  echo a:000

endfunction " ZekArgs

command! -nargs=* ZekArgs :call <SID>ZekArgs(<f-args>)
  " f-args stands for "function args"...

