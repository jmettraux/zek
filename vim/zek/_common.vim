
"
" zek/_common.vim


function! ZekNtr(s)

  return substitute(a:s, '[^a-zA-Z0-9]', '_', 'g')
endfunction " ZekNtr


function! ZekFileJoin(...)

  return substitute(join(a:000, '/'), '\v/+', '/', 'g')
endfunction " ZekFileJoin


function! s:ZekReadRepoPath(fn)

  for l in readfile(a:fn)
    let l = trim(l)
    if empty(l) | continue | endif
    if match(l, '\v^#') | continue | endif
    return l
  endfor
  return ''
endfunction " ZekReadRepoPath


function! s:ZekLookupRepoPath(dir)

  if a:dir == '/home' || a:dir == '/' | return '' | endif

  for fn in [ '.zek-repo-path', '.zek_repo_path' ]
    let path = ZekFileJoin(a:dir, fn)
    if ! filereadable(path) | continue | endif
    let repo = <SID>ZekReadRepoPath(path)
    return isabsolutepath(repo) ? repo : ZekFileJoin(a:dir, repo)
  endfor

  return <SID>ZekLookupRepoPath(fnamemodify(a:dir, ':h'))
endfunction " ZekLookupRepoPath


function! ZekRepoPath()

  let p = $ZEK_REPO_PATH
  if (empty(p)) | let p = <SID>ZekLookupRepoPath(getcwd()) | endif
  if (empty(p)) | let p = '.' | endif

  return fnamemodify(p, ':p')
endfunction " ZekRepoPath

