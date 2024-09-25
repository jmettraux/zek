
"
" zek/auto.vim

" autocmd at the bottom of the file...

function! s:ZekFollowLink()

  let w = expand('<cWORD>')
  let m = matchlist(w, '\v\(([^)]+)\)')

  if ! empty(m[1])
    call ZekOpenLink(m[1])
  endif
endfunction " ZekFollowLink


function! s:ZekGoParent()

  for i in range(1, line('$'))
    let l = getline(i)
    let m = matchlist(getline(i), '\v\[parent\]\(([^)]+)\)')
    if ! empty(m)
      call ZekOpenLink(m[1])
      return
    endif
  endfor
  echo "no parent for this note"
endfunction " ZekGoParent


function! s:ZekGoRoot()

  let car = ZekRun('root', [ expand('%:t') ], [])

  if car[0] == 0
    call ZekOpenLink(car[1])
  endif
endfunction " ZekGoRoot


function! s:ZekGoTrees()

  if bufexists("_zktr___")
    edit _zktr___
  else
    exe ":ZekTrees"
  endif
endfunction " ZekGoTrees


function! s:ZekWriteNote()

  call ZekUpdateMtime()
endfunction " ZekWriteNote


function! s:OnZekNote()

  nnoremap <buffer> gg :call <SID>ZekFollowLink()<CR>
  "nnoremap <buffer> T :ZekTrees<CR>
  nnoremap <buffer> T :call <SID>ZekGoTrees()<CR>
  nnoremap <buffer> gp :call <SID>ZekGoParent()<CR>
  nnoremap <buffer> gr :call <SID>ZekGoRoot()<CR>

  autocmd BufWritePre <buffer> call <SID>ZekWriteNote()
endfunction " onZekNote


exe "autocmd BufRead " . ZekFileJoin(ZekRepoPath(), '*/*/*.md') . " call <SID>OnZekNote()"

