
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

  if &mod == 1 | echoerr "Current buffer has unsaved changes." | return | endif

  let car = <SID>ZekRun('trees', a:000, [])

  if car[0] != 0 | return | endif

  let fn = '_zktr___' . JmNtr(join(a:000, '_'))
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

  put= car[1]

  " TODO continue me ...

endfunction " ZekTrees
"function! JmShowTree(start)
"
"  if &mod == 1 | echoerr "Current buffer has unsaved changes." | return | endif
"
"  let fn = '_t___' . JmNtr(a:start)
"
"  "let bn = bufnr(fn)
"  let bn = JmBufferNumber(fn)
"
"  if bn > -1 | exe '' . bn . 'bwipeout!' | endif
"    " close previous GitLog if any
"
"  exe 'new | only'
"    " | only makes it full window
"
"  exe 'silent file ' . fn
"
"  setlocal buftype=nofile
"  setlocal bufhidden=hide
"  setlocal noswapfile
"  setlocal cursorline
"
"  exe '%d'
"    " delete all the lines
"  normal O
"  exe 'silent r! ' . g:_python . ' ~/.vim/scripts/tree.py ' . a:start
"  exe 'silent g/^The system cannot find the path specified\./d'
"  exe 'silent %s/\v\[ *([0-9.]+[KMGTPE]?)\]  (.+)$/\2 \1/e'
"  exe 'silent %s/\v\* / /ge'
"  exe 'silent %s/\\ / /ge'
"    " e to silent when no pattern match
"  normal 1G
"  setlocal syntax=showtreeout
"  setlocal nomodifiable
"
"  nnoremap <buffer> o :call JmOpenTreeFile()<CR>
"  nnoremap <buffer> e :call JmOpenTreeFile('edit')<CR>
"  nnoremap <buffer> <space> :call JmOpenTreeFile()<CR>
"  nnoremap <buffer> <CR> :call JmOpenTreeFile()<CR>
"
"  nnoremap <buffer> C :call JmCopyTreeFile()<CR>
"  nnoremap <buffer> D :call JmDeleteTreeFile()<CR>
"  nnoremap <buffer> R :call JmRenameTreeFile()<CR>
"  nnoremap <buffer> M :call JmMoveTreeFile()<CR>
"  nnoremap <buffer> ga :call JmGitAddTreeFile()<CR>
"  nnoremap <buffer> gr :call JmGitUnaddTreeFile()<CR>
"  nnoremap <buffer> gu :call JmGitUnaddTreeFile()<CR>
"  nnoremap <buffer> p :exe "echo JmDetermineTreePath()"<CR>
"  nnoremap <buffer> r :call JmReloadTree(0)<CR>
"  nnoremap <buffer> T :call JmGitCommitTreeFile()<CR>
"
"  nmap <buffer> v /
"
"  nnoremap <buffer> <silent> a j:call search('\v [^ ]+\/', '')<CR>0zz
"  nnoremap <buffer> <silent> A :call search('\v [^ ]+\/', 'b')<CR>0zz
"
"  nnoremap <buffer> <silent> q :bd<CR>
"
"  "nnoremap <buffer> <silent> <leader>j :call <SID>MoveHalfDown()<CR>
"  "nnoremap <buffer> <silent> <leader>k :call <SID>MoveHalfUp()<CR>
"  nnoremap <buffer> <silent> J :call <SID>MoveHalfDown()<CR>
"  nnoremap <buffer> <silent> K :call <SID>MoveHalfUp()<CR>
"  nnoremap <buffer> <silent> m :call <SID>MoveToModified(1)<CR>
"
"  exe 'nnoremap <buffer> F :! fe ' . a:start . '*<CR>'
"  "nnoremap <buffer> f :call JmShowTreeImage()<CR>
"endfunction " ShowTree

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

