
"
" zek/auto.vim

" place here autocommands for when opening notes and list of notes...

function! s:ZekFollowLink()

  let w = expand('<cWORD>')
  let m = matchlist(w, '\v\(([^)]+)\)')

  if ! empty(m[1])
    call ZekOpenLink(m[1])
  endif
endfunction " ZekFollowLink

function! s:OnZekNote()

  nnoremap <buffer> gg :call <SID>ZekFollowLink()<CR>
endfunction " onZekNote

autocmd BufRead $ZEK_REPO_PATH/*/*/*.md call <SID>OnZekNote()

