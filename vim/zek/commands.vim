
"
" zek/commands.vim

"
" ~protected~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

highlight ZekRedEchoHighlight ctermfg=red ctermbg=none
highlight ZekGreenEchoHighlight ctermfg=green ctermbg=none
highlight ZekYellowEchoHighlight ctermfg=darkyellow ctermbg=none
  "
function! s:ZekRedEcho(...)
  echohl ZekRedEchoHighlight | echo join(a:000, ' ') | echohl None
endfunction
function! s:ZekGreenEcho(...)
  echohl ZekGreenEchoHighlight | echo join(a:000, ' ') | echohl None
endfunction
function! s:ZekYellowEcho(...)
  echohl ZekYellowEchoHighlight | echo join(a:000, ' ') | echohl None
endfunction

function! s:ZekBufferUuid()

  let m = matchlist(expand('%:r'), '\v\/([0-9a-f]{32})_')
  return empty(m) ? '' : m[1]
endfunction " ZekCurrentUuid

function! s:ZekCurrentUuid()

  let m = matchlist(getline('.'), '\v ([0-9a-f]{32}) ')
  return empty(m) ? '' : m[1]
endfunction " ZekCurrentUuid

function! s:ZekOpenNote()

  let u = <SID>ZekCurrentUuid() | if u == '' | return | endif

  call ZekOpenLink(u)
endfunction " ZekOpenNote


function! s:ZekMakeChildNote()

  let u = <SID>ZekCurrentUuid() | if u == '' | return | endif

  let car = ZekRun(
    \ 'make', [], [ "[parent](" . trim(m[0]) . ")", "", "# new note", ""])

  if car[0] == 0 | call ZekOpenLink(car[1]) | endif
endfunction " ZekMakeChildNote


function! s:ZekPrepChildNote()

  let u = <SID>ZekCurrentUuid() | if u == '' | return | endif
  let car = ZekRun('self', [ u ], [])
  if car[0] != 0 | return | endif

  call <SID>ZekPrepNote(car[1])
endfunction " ZekPrepChildNote


function! s:ZekNoteSelections()

  let a = []
    "
  for i in range(1, line('$'))
    let m = matchlist(getline(i), '\v^ *\\ .+ ([0-9a-f]{32}) ')
    if ! empty(m) | call add(a, m[1]) | endif
  endfor

  return a
endfunction " ZekNoteSelections()


function! s:ZekNoteSelection()

  let a = <SID>ZekNoteSelections()
  return empty(a) ? '' : a[0]
endfunction " ZekNoteSelection()


function! s:ZekClearNoteSelection()

  let l = line('.')
  setlocal modifiable
  execute '%s/\v^( *)\\/\1\//ge'
  setlocal nomodifiable
  call cursor(l, 1)
endfunction " ZekClearNoteSelection


function! s:ZekCutNote()

  let cu = <SID>ZekCurrentUuid()
  let su = <SID>ZekNoteSelection()

  call <SID>ZekClearNoteSelection()

  if cu == su | return | endif

  setlocal modifiable
  execute 's/\v^( *)\//\1\\/ge'
  normal 0
  setlocal nomodifiable
endfunction " ZekCutNote


function! s:ZekL7(u)
  return '_' . strcharpart(a:u, len(a:u) - 7)
endfunction " ZekL7


function! s:ZekTieNote()

  let cu = <SID>ZekCurrentUuid()
  let su = <SID>ZekNoteSelection()
  let scu = <SID>ZekL7(cu)
  let ssu = <SID>ZekL7(su)

  if confirm('Tie note ' . ssu . ' to note ' . scu . '?', "&No\n&yes") == 1
    return 0
  endif

  let car = ZekRun('tie', [ cu, su ], [])

  if car[0] == 0
    call <SID>ZekGreenEcho("Re-tied note " . su)
  endif
endfunction " ZekTieNote


function! s:ZekDeleteNote()

  let u = <SID>ZekCurrentUuid() | if u == '' | return | endif

  if confirm('Delete note ' . u . ' ?', "&No\n&yes") == 1 | return 0 | endif

  let car = ZekRun('delete', [ u ], [])

  if car[0] == 0
    call <SID>ZekGreenEcho("deleted note " . u)
  endif
endfunction " ZekDeleteNote


function! s:ZekOpenRoot()

  if exists('*JmShowTree')
    call JmShowTree(ZekRepoPath())
  else
    edit ZekRepoPath()
  endif
endfunction " ZekOpenRoot


function! s:ZekExtractTitle()

  for i in range(1, line('$'))
    let m = matchlist(getline(i), '\v^#{1,2} (.+)$')
    if ! empty(m) | return m[1] | endif
  endfor

  return "no title"
endfunction " ZekExtractTitle


function! s:ZekWriteNote()

  if match(expand('%:p'), '\v__\.md$')

    let t = ZekNtr(<SID>ZekExtractTitle())
    let u = <SID>ZekBufferUuid()

    exe 'file ' . expand('%:h') . '/' . u . '_' . t . '.md'

    let car = ZekRun('mkdirp', [ u ], [])
    if car[0] != 0 | return | endif
  endif

  call ZekUpdateMtime()

  write!
endfunction " ZekWriteNote


function! s:ZekPrepNote(u)

  let car = ZekRun('uuidp', [], [])
  if car[0] != 0 | return | endif

  exe 'new | only'
  setlocal syntax=markdown

  exe "file " . car[1] . "__.md"

  if strlen(a:u) > 0
    exe "normal! i" . "[parent](" . a:u . ")"
  endif
  exe "normal! o## New NoteLore ipsum...<!-- mtime: .now. -->"
  exe "normal! kkk0lll"

  nnoremap <buffer> qq :bdelete!<CR>

  autocmd BufWriteCmd <buffer> call <SID>ZekWriteNote()
    " meh...

  "call <SID>ZekGreenEcho("ww to save, qq to cancel...")

endfunction " ZekPrepNote


"
" ~public~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


function! ZekRun(cmd, args, lines)

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

endfunction " ZekRun


function! ZekRepoPath()

  let car = ZekRun('repo', [], [])

  return car[0] == 0 ? car[1] : ""
endfunction " ZekRepoPath


function! ZekOpenLink(s)

  let car = ZekRun('path ' . trim(a:s), [], [])
  if empty(car[1]) | return | endif

  execute 'edit ' . car[1]
endfunction " ZekOpenLink


" Create a new note
"
function! s:ZekMakeNote() range

  let ls = getline(a:firstline, a:lastline)

  let car = ZekRun('make', [], ls)

  if car[0] == 0
    call <SID>ZekGreenEcho("Added note " . car[1])
  endif
endfunction " ZekMakeNote

vnoremap zz :call <SID>ZekMakeNote()


function! s:ZekTrees(...)

  if &mod == 1 | echoerr "Current buffer has unsaved changes." | return | endif

  let car = ZekRun('trees', a:000, [])

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

  exe "normal i# " . ZekRepoPath() . " trees"

  silent put= car[1]

  exe "normal! Go"

  "normal 1G
  setlocal syntax=zektree
  setlocal nomodifiable

  nnoremap <buffer> o :call <SID>ZekOpenNote()<CR>
  nnoremap <buffer> <CR> :call <SID>ZekOpenNote()<CR>
  "nnoremap <buffer> e :call JmOpenTreeFile('edit')<CR>
  "nnoremap <buffer> <space> :call JmOpenTreeFile()<CR>

  nnoremap <buffer> R :call <SID>ZekOpenRoot()<CR>
  "nnoremap <buffer> c :call <SID>ZekMakeChildNote()<CR>
  nnoremap <buffer> c :call <SID>ZekPrepChildNote()<CR>
  nnoremap <buffer> a :call <SID>ZekPrepNote('')<CR>

  nnoremap <buffer> r :ZekTrees<CR>
  nnoremap <buffer> i :ZekIndex<CR>
  nnoremap <buffer> b :ZekExportBookmarks<CR>

  nnoremap <buffer> D :call <SID>ZekDeleteNote()<CR>

  nnoremap <buffer> x :call <SID>ZekCutNote()<CR>
  nnoremap <buffer> v :call <SID>ZekTieNote()<CR>
endfunction " ZekTrees

command! -nargs=* ZekTrees :call <SID>ZekTrees(<f-args>)


" Trigger Zek indexation of the repository
"
function! s:ZekIndex()

  let car = ZekRun('index', [], [])

  if car[0] != 0 | return | endif

  call <SID>ZekGreenEcho("Indexed " . ZekRepoPath() . " took " . car[1])
endfunction " ZekIndex

command! -nargs=0 ZekIndex :call <SID>ZekIndex()


function! s:ZekExportBookmarks()

  let car = ZekRun('exportb', [], [])

  if car[0] != 0 | return | endif

  call <SID>ZekGreenEcho("Exported bookmarks to " . car[1])
endfunction! " ZekExportBookmarks

command! -nargs=0 ZekExportBookmarks :call <SID>ZekExportBookmarks()


function! s:ZekScratch()

  execute 'edit ' . ZekFileJoin(ZekRepoPath(), 'scratch.md')
  normal G
endfunction " ZekScratch

command! -nargs=0 ZekScratch :call <SID>ZekScratch()


function! s:ZekCommit(message)

  let m = trim(a:message)
  if strlen(m) < 1 | let m = "commit message" | endif
  let m = substitute(m, '"', '\\"', 'g')

  let car = ZekRun('commit', [ '"' . m . '"' ], [])

  if car[0] != 0 | return | endif

  call <SID>ZekGreenEcho("commited " . car[1])
endfunction! " ZekExportBookmarks

"command! -nargs=0 ZekCommit :call <SID>ZekCommit()
command! -nargs=* ZekCommit :call <SID>ZekCommit(<q-args>)


function! s:ZekBackup()

  call <SID>ZekYellowEcho("backing up " . ZekRepoPath() . " ...")

  let car = ZekRun('backup', [], [])

  if car[0] != 0 | return | endif

  call <SID>ZekGreenEcho(car[1])
endfunction! " ZekExportBookmarks

"command! -nargs=0 ZekBak :call <SID>ZekBackup()
command! -nargs=0 ZekBackup :call <SID>ZekBackup()


" dev helper
"
function! s:ZekArgs(...)

  echo a:000

endfunction " ZekArgs

command! -nargs=* ZekArgs :call <SID>ZekArgs(<f-args>)
  " f-args stands for "function args"...

