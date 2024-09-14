
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
  let s = trim(s)

  let e = v:shell_error

  if e != 0
    call <SID>ZekRedEcho("exit code " . e)
    call <SID>ZekRedEcho("  |")
    call <SID>ZekRedEcho(s)
  endif

  return [ e, s ]

endfunction " ZekRunAndRead


function! s:ZekOpenNote()

  let l = getline('.')
  let m = matchlist(l, '\v [0-9a-f]{32} ')
  if empty(m) == 1 | return | endif

  let u = trim(m[0])
  let car = <SID>ZekRun('path ' . u, [], [])
  if empty(car[1]) | return | endif

  execute 'edit ' . car[1]
endfunction " ZekOpenNote


function! s:ZekOpenRoot()

  if exists('*JmShowTree')
    call JmShowTree($ZEK_REPO_PATH)
  else
    edit $ZEK_REPO_PATH
  endif
endfunction " ZekOpenRoot


function! ZekNtr(s)

  return substitute(a:s, '[^a-zA-Z0-9]', '_', 'g')
endfunction " ZekNtr

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
  endif
endfunction " ZekMake

vnoremap zz :call <SID>ZekMake()


function! s:ZekTrees(...)

  if &mod == 1 | echoerr "Current buffer has unsaved changes." | return | endif

  let car = <SID>ZekRun('trees', a:000, [])

  if car[0] != 0 | return | endif

  let fn = '_zktr___' . ZekNtr(join(a:000, '_'))
  let bn = JmBufferNumber(fn)

  if bn > -1 | exe '' . bn . 'bwipeout!' | endif
    " close previous zek buffer if any

  exe 'new | only'
    " | only makes it full window

  exe 'silent file ' . fn

  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal cursorline

  silent put= car[1]

  "normal 1G
  setlocal syntax=zektree
  setlocal nomodifiable

  nnoremap <buffer> o :call <SID>ZekOpenNote()<CR>
"  nnoremap <buffer> e :call JmOpenTreeFile('edit')<CR>
"  nnoremap <buffer> <space> :call JmOpenTreeFile()<CR>
"  nnoremap <buffer> <CR> :call JmOpenTreeFile()<CR>

  nnoremap <buffer> R :call <SID>ZekOpenRoot()<CR>

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

