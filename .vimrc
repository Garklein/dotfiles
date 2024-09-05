set encoding=utf-8
let skip_defaults_vim=1 
set clipboard=unnamedplus
au FileType perl se ft=prolog
filetype detect
if &filetype == 'haskell' || &filetype == 'apl'
	filetype plugin indent on
endif
syntax on
se number
sy on
se hls
se is
se splitright
se splitbelow
se relativenumber

nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
hi Search ctermbg=lightmagenta ctermfg=black
hi Visual ctermbg=lightblue ctermfg=black
hi MatchParen cterm=underline ctermbg=black

hi Identifier ctermfg=lightgrey
hi Comment    ctermfg=darkblue
hi Constant   ctermfg=blue
hi Special    ctermfg=cyan
hi Function   ctermfg=darkred
hi Statement  ctermfg=darkgreen
hi PreProc    ctermfg=darkmagenta
hi Type       ctermfg=lightblue
hi Conceal    ctermbg=black

if &filetype == 'c'
	se tabstop=2
else
	se tabstop=4
endif
let fortran_have_tabs=1
let fortran_free_source=1 

se backupdir=~/.vimtmp
se directory=~/.vimtmp
