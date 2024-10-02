
"
" zek/vim/syntax/zektree.vim

  " (<pattern>)@<=<match>  ~~~ positive lookbehind
  " <match>(<pattern>)@=   ~~~ positive lookahead
  " (<pattern>)@!<match>   ~~~ negative lookbehind
  " <match>(<pattern>)@!   ~~~ negative lookahead

highlight ColorColumn ctermbg=16
  " disable > 80 column highlight

hi! zktTitle cterm=NONE ctermfg=238 ctermbg=16
hi! zktRoot cterm=NONE ctermfg=darkgrey ctermbg=16

hi! zktNote cterm=NONE ctermfg=green ctermbg=16
hi! zktSlash cterm=NONE ctermfg=darkyellow ctermbg=16
hi! zktUuid cterm=NONE ctermfg=238 ctermbg=16
hi! zktSizes cterm=NONE ctermfg=darkgreen ctermbg=16
hi! zktLine cterm=NONE ctermfg=white ctermbg=16
hi! zktPipe cterm=NONE ctermfg=darkgrey ctermbg=16
hi! zkwWord cterm=NONE ctermfg=red ctermbg=16

syn match zktTitle '\v^# .+' contains=zktRoot
syn match zktRoot '\v(# )@<=[^ ]+' contained

syn match zktNote '\v *\/ .+$' contains=zktSlash,zktUuid,zktSizes,zktLine,zktPipe
syn match zktSlash '\v( *)@<=\/( )@=' contained
syn match zktUuid '\v( \| )@<=[0-9a-f]{32}( [0-9])@=' contained
syn match zktSizes '\v([0-9a-f] )@<=[0-9]+ [0-9]+l( \|)@=' contained
syn match zktLine '\v([0-9]l \|)@<= .*' contained
syn match zktPipe '\v( )\|( ?)@=' contained

syn match zkwWordHeader '\v^## .+:$' contains=zkwWord
syn match zkwWord '\v(^## )@<=[^:]+(:$)@=' contains=zkwWord contained

let b:current_syntax = "zektree"

