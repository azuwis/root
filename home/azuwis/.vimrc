"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
"set mouse=a
set statusline=%<%F%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P%y
set laststatus=2
set fileencodings=utf8,cp936
set spelllang=en_us

set modeline
set splitright

syntax on
filetype plugin indent on
set foldmethod=syntax

set incsearch hlsearch
set ignorecase smartcase
"set background=dark
"colorscheme evening

"if ! has("gui_running")
if $TERM =~ '^rxvt-unicode' && ! has("gui_running")
    set t_Co=256
    set background=dark
    colorscheme delek
else
    colorscheme twilight
endif
" set background=light gives a different style, feel free to choose between them.


" tab
"set tabstop=4
"set softtabstop=4
"set shiftwidth=4
"set expandtab

" javascript
augroup js
	autocmd BufRead *.js set ts=4 sw=4 expandtab ai
augroup END

" mutt
autocmd BufRead /tmp/mutt-* set tw=72

" ctags
set tags=./tags,tags,../tags,/home/azuwis/tmp/tags

" taglist
nnoremap <silent> <F8> :TlistToggle<CR>

" latex
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat='pdf'

" compile
nnoremap <silent> <F5> :make<CR>
nnoremap <silent> <F3> :cnext<CR>
nnoremap <silent> <F2> :cprev<CR>
