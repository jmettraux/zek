
"
" zek/auto.vim

" place here autocommands for when opening notes and list of notes...

function! s:OnZekNote()
  " TODO
  nnoremap <buffer> gg :call <SID>Zek()<CR>
endfunction " onZekNote

autocmd BufRead $ZEK_REPO_PATH/*/*/*.md call <SID>OnZekNote()

