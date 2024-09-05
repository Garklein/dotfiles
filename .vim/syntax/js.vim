if exists("b:current_syntax")|fini|en|sy sync fromstart
" arrays objects ``($.)
sy match id '[\$_a-zA-Z][\$_a-zA-Z0-9]*'
sy match parens '(\|)'
sy keyword ty const let var async
sy keyword imp require
sy keyword st if else for in of while do function return switch case default try catch finally throw break continue
sy keyword st await with yield void new delete static this class constructor extends
sy match st ';'|sy match st '='|sy match st '=>'|sy match st ':'|sy match st '?'|sy match st ','
sy match ops '+'|sy match ops '-'|sy match ops '*'|sy match ops '/'|sy match ops '%'|sy match ops '*\*'
sy match ops '<'|sy match ops '>'|sy match ops '<='|sy match ops '>='
sy match ops '&' |sy match ops '|' |sy match ops '\~'|sy match ops '\^'
sy match ops '&&'|sy match ops '||'|sy match ops '!'
sy match ops '=='|sy match ops '==='|sy match ops '!='|sy match ops '!=='
sy match ops '+='|sy match ops '-='|sy match ops '*='|sy match ops '/='|sy match ops '%='|sy match ops '++'|sy match ops '--'
sy match ops '&&='|sy match ops '||='|sy match ops '|='|sy match ops '&='|sy match ops '^='
sy match a '?\=\.'
sy keyword ops typeof instanceof
sy keyword un undefined
sy keyword bl true false
sy match num '-\=\d\+'
sy match num '-\=0b[01]\+'
sy match num '-\=0x[0-9a-fA-F]\+'
sy match fl '-\=\d\+\.\d*'
sy match fl '-\=\d\+\(\.\d*\)\=[eE][+-]\=\d\+'
sy keyword fl NaN Infinity
sy region emb start='${' end='}' contains=ty,st,ops,un,bl,num,fl,str,lCom,bCom,rx,arr,parens,a contained
sy match sp '\\\d\d\d\|\\.'
sy region str start='"' skip='\\\\\|\\"' end='"' contains=sp
sy region str start="'" skip="\\\\\|\\'" end="'" contains=sp
sy region str start="`" skip='\\\\\|\\`' end="`" contains=sp,emb
sy region rx start='\([0-9a-zA-Z\$_\.\])]\s*\)\@<!/' skip='\\\\\|\\/' end='/[dgimsuy]\='
sy match aCo ',' contained
"sy region arr start="\W\s*\[" end="\]" contains=id,ty,st,ops,un,bl,num,fl,str,lCom,bCom,arr,aCo,parens,a
sy region lCom start="//" end="\n"
sy region lCom start="<!--" end="\n"
sy region bCom start="/\*" end="\*/" contains=bCom

hi link id   Identifier
hi link ty   Type
hi link imp  Include
hi link st   Statement
hi link ops  Function
hi link un   Constant
hi link bl   Boolean
hi link num  Number
hi link fl   Float
hi link emb  Special
hi link sp   Special
hi link aCo  Constant
hi link arr  Constant
hi link str  String
hi link rx   Constant
hi link lCom Comment
hi link bCom Comment

let b:current_syntax="js"
