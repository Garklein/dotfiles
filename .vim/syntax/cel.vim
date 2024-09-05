if exists("b:current_syntax")|fini|en
sy keyword celBlockCmd RA Dec Mass AbsMag Distance nextgroup=celNumber skipwhite
sy keyword celBlockcmd SpectralType nextgroup=celDexc
" Integer with - + or nothing in front
sy match celNumber '\d\+'
sy match celNumber '[-+]\d\+'

" Floating point number with decimal no E or e 
sy match celNumber '[-+]\d\+\.\d*'

" Floating point like number with E and no decimal point (+,-)
sy match celNumber '[-+]\=\d[[:digit:]]*[eE][\-+]\=\d\+'
sy match celNumber '\d[[:digit:]]*[eE][\-+]\=\d\+'

" Floating point like number with E and decimal point (+,-)
sy match celNumber '[-+]\=\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+'
sy match celNumber '\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+'

sy region celString start='"' end='"' contained
sy region celDesc start='"' end='"'

sy match celHip '\d\{1,6}' nextgroup=celString
sy region celDescBlock start="{" end="}" fold transparent contains=ALLBUT,celHip,celString

sy keyword celTodo contained TODO FIXME XXX NOTE
sy match celComment "#.*$" contains=celTodo

let b:current_syntax = "cel"

hi def link celTodo Todo
hi def link celComment     Comment
hi def link celBlockCmd    Statement
hi def link celHip         Type
hi def link celString      Constant
hi def link celDesc        PreProc
hi def link celNumber      Constant
