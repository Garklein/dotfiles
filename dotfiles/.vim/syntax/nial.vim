"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" vim nial highlighter
" written by Garklein <garklein97@gmail.com>
" made with BNF from the language definition
" only common infix functions are highlighted (ops group)
" and aliases such as `gets` and `add` aren't supported
" some symbols, such as ~, work as valid identifiers in Q'Nial
" however, they aren't in the grammar, and thus aren't highlighted
" if you want that, or aliases, highlighted, modify the file  : )
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if exists("b:current_syntax")|fini|en|sy case ignore

sy keyword const true false pi null
sy keyword kws is gets op operation tr transformer if then elseif else endif case from endcase begin end for with endfor while do endwhile repeat until endrepeat
sy match kws ':'|sy match kws ':='|sy match kws ';'
sy match ops '+'|sy match ops '-'|sy match ops '*'|sy match ops '/'
sy match ops '='|sy match ops '\~='|sy match ops '<'|sy match ops '>'|sy match ops '>='|sy match ops '<='
sy keyword ops mod and not or
sy match ops '@@'|sy match ops '#'|sy match ops '@'|sy match ops '|'
sy match iden '[&_a-zA-Z][&_a-zA-Z0-9]*'
sy match bool '\v(^|\s)[lo]+(\s|$)'
sy match ft '?[^()\[\]{}#,;]*'
sy match ph '"[^()\[\]{}#,;]*'
sy match char '`.'
sy region str start="'" end="'"
sy region bCom start="^\s*#" end="\n\s*\n"
sy region nCom start="%" end=";"
sy match num '-\=\d\+'
sy match real '-\=\d\+\([eE][+-]\=\d\+\)\='
sy match real '-\=\d\+\.\d*\([eE][+-]\=\d\+\)\='
sy match real '-\=\d*\.\d\+\([eE][+-]\=\d\+\)\='

hi link const Constant
hi link kws Statement
hi link ops Function
hi link iden Identifier
hi link bool Boolean
hi link ft Constant
hi link ph Constant
hi link char Character
hi link str String
hi link bCom Comment
hi link nCom Comment
hi link num Number
hi link real Float

let b:current_syntax="nial"
