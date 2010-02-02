"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
"set mouse=a
set statusline=%<%F%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P%y
set laststatus=2
set fileencodings=utf8,cp936
set spelllang=en_us
" Search file in <dir of file>, <pwd>, </usr/include>
" for cmd like gf, ctrl-w f, :find
set path=.,,/usr/include

" Enable modeline
set modeline
" Split at right and bottom
set splitright splitbelow

" Better completion
set wildmode=longest,full
set wildmenu

" Syntax and highlighting staff
syntax on
filetype plugin indent on
set foldmethod=syntax
set incsearch hlsearch
"set ignorecase smartcase

" Colorscheme
colorscheme wombat
"set background=dark
"if $TERM =~ '^rxvt-unicode' && ! has("gui_running")
"	set t_Co=256
"	set background=dark
"	colorscheme delek
"else
"	colorscheme wombat
"endif

" Shortcut
let mapleader = ","
" Fast reloading of the .vimrc
map <silent> <leader>ss :source ~/.vimrc<cr>
" Fast editing of .vimrc
map <silent> <leader>ee :e ~/.vimrc<cr>
" When .vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

" Cscope
"set cscopequickfix=c-,d-,e-,g-,i-,s-,t-

" Tab settings
"set tabstop=4
"set softtabstop=4
"set shiftwidth=4
"set expandtab

" Javascript
"augroup js
"	autocmd BufRead *.js set ts=4 sw=4 expandtab ai
"augroup END

" Mutt
"autocmd BufRead /tmp/mutt-* set tw=72

" Ctags
"set tags=./tags,tags,../tags,/home/azuwis/tmp/tags

" Taglist
nnoremap <silent> <F8> :TlistToggle<CR>

" Latex
"set grepprg=grep\ -nH\ $*
"let g:tex_flavor='latex'
"let g:Tex_DefaultTargetFormat='pdf'

" Quickfix
nnoremap <silent> <F5> :make<CR>
nnoremap <silent> <F3> :cnext<CR>
nnoremap <silent> <F2> :cprev<CR>
nnoremap <silent> <F4> :QFix<CR>
" http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window
command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
	if exists("g:qfix_win") && a:forced == 0
		cclose
		unlet g:qfix_win
	else
		copen 10
		let g:qfix_win = bufnr("$")
	endif
endfunction

" Don't use Ex mode, use Q for formatting
map Q gq

" Vimdiff the original file
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	\ | wincmd p | diffthis

" Highlight unwanted spaces
" From http://vim.wikia.com/wiki/Highlight_unwanted_spaces
"highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
"match ExtraWhitespace /\s\+$\| \+\ze\t/
let c_space_errors = 1

" Enter to separate lines
"nmap <CR> i<CR><Esc>
