
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


function! s:ZekGoTrees()

  if bufexists("_zktr___")
    edit _zktr___
  else
    exe ":ZekTrees"
  endif
endfunction " ZekGoTrees


function! s:OnZekNote()

  nnoremap <buffer> gg :call <SID>ZekFollowLink()<CR>
  "nnoremap <buffer> T :ZekTrees<CR>
  nnoremap <buffer> T :call <SID>ZekGoTrees()<CR>
endfunction " onZekNote

autocmd BufRead $ZEK_REPO_PATH/*/*/*.md call <SID>OnZekNote()

