
"
" zek/commands.vim

"
" ~protected~

highlight ZekRedEchoHighlight ctermfg=red ctermbg=none
highlight ZekGreenEchoHighlight ctermfg=green ctermbg=none
  "
function! s:ZekRedEcho(...)
  echohl ZekRedEchoHighlight | echo join(a:000, ' ') | echohl None
endfunction
function! s:ZekGreenEcho(...)
  echohl ZekGreenEchoHighlight | echo join(a:000, ' ') | echohl None
endfunction


function! s:ZekRun(cmd, args, lines)

  let cmd = a:cmd . ' ' . join(a:args, ' ')

  let s = system(g:_zek_ruby . ' ' . g:_zek_rb . ' ' . cmd, a:lines)
  let e = v:shell_error

  return [ e, trim(s) ]

endfunction " ZekRunAndRead


"
" ~public~

"
"  * note trees
"  * note lists
"  * note
"

" Create a new note
"
function! s:ZekMake() range

  let ls = getline(a:firstline, a:lastline)

  let car = <SID>ZekRun('make', [], ls)

  if car[0] == 0
    call <SID>ZekGreenEcho("Added note " . car[1])
  else
    call <SID>ZekRedEcho("error " . car[1])
  endif
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
  let car = <SID>ZekRun('trees', a:000, [])
  echo 'code:' car[0]
  echo 'result:' car[1]

endfunction " ZekTrees

command! -nargs=* ZekTrees :call <SID>ZekTrees(<f-args>)


" Fetch a list of notes
"
function! s:ZekList(flavour)

  let car = <SID>ZekRun('list ' . a:flavour, [])

endfunction " ZekList

command! -nargs=* ZekList :call <SID>ZekList(<f-args>)


" Trigger Zek indexation of the repository
"
function! s:ZekIndex()

  let car = <SID>ZekRun('index', [])

endfunction " ZekIndex

command! -nargs=0 ZekIndex :call <SID>ZekIndex()


" dev helper
"
function! s:ZekArgs(...)

  echo a:000

endfunction " ZekArgs

command! -nargs=* ZekArgs :call <SID>ZekArgs(<f-args>)
  " f-args stands for "function args"...

