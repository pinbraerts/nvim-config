scriptencoding utf-8
language en_US.utf8
filetype plugin indent on
syntax on
let &t_EI = "\e[2 q"
let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
set t_RV=
set t_u7=
set autoindent
set smartindent
set cindent
set cino=:0
set encoding=utf-8
set ff=unix
set hlsearch
set ignorecase
set incsearch
set showmatch
set smartcase
set smartindent
set listchars=space:.,eol:$,trail:-,tab:\|\ " prevent removing whitespace
set nocompatible
set noswapfile
set undofile
set nowrap
set number
set relativenumber
set splitright
set shiftwidth=4
set tabstop=4
set noexpandtab
set scrolloff=10
set noshowmode
set undofile
set termguicolors
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯЖ;ABCDEFGHIJKLMNOPQRSTUVWXYZ:,фисвуапршолдьтщзйкыегмцчняж;abcdefghijklmnopqrstuvwxyz;
set title
nohls

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_fastbrowse = 0

" yank to end of line
nnoremap Y yg$

" disable highlight
nnoremap <esc> <cmd>nohls<cr>
vnoremap <esc> <c-c>

" paste from clipboard while typing
inoremap <c-v> <c-c>"*pa

" replace without overriding register
vnoremap R "_dP

" enter maps
nnoremap <enter> i<cr><c-c>
nnoremap <silent> <c-enter>        <cmd>call append(line('.')-1,'')<cr>
nnoremap <silent> <s-enter>        <cmd>call append(line('.')  ,'')<cr>
inoremap <silent> <c-enter> <c-c>  <cmd>call append(line('.')-1,'')<cr>a
inoremap <silent> <s-enter> <c-c>  <cmd>call append(line('.')  ,'')<cr>a
vnoremap <silent> <c-enter> <c-c>`<<cmd>call append(line('.')-1,'')<cr>gv
vnoremap <silent> <s-enter> <c-c>`><cmd>call append(line('.')  ,'')<cr>gv

" move lines on alt
nnoremap <silent> <a-k>      <cmd>m-2<cr>==
nnoremap <silent> <a-j>      <cmd>m+1<cr>==
inoremap <silent> <a-j> <c-c><cmd>m+1<cr>==a
inoremap <silent> <a-k> <c-c><cmd>m-2<cr>==a

" select double quotes
onoremap aq a"
onoremap iq i"
xnoremap aq a"
xnoremap iq i"

function! ToggleStyle()
	if &list
		set colorcolumn=
		set nocursorline
		set nocursorcolumn
		set nolist
	else
		set colorcolumn=80
		set cursorline
		set cursorcolumn
		set list
	endif
endfunction

let mapleader=" "
nnoremap <silent> <leader>= <cmd>call ToggleStyle()<cr>

" clipboard maps
 noremap <leader>p "+p
 noremap <leader>P "+P
 noremap <leader>y "+y
 noremap <leader>Y "+Y

" scroll buffers
nnoremap [b <cmd>bp<cr>
nnoremap ]b <cmd>bn<cr>

" scroll quickfix
nnoremap [q <cmd>cp<cr>
nnoremap ]q <cmd>cn<cr>

" window maps
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" command line remaps
cnoremap <c-h> <left>
cnoremap <c-j> <down>
cnoremap <c-k> <up>
cnoremap <c-l> <right>

function! ProcessModifiable()
	if &modifiable
		silent! nunmap <buffer> q
		silent! nunmap <buffer> gj
		silent! nunmap <buffer> gk
		silent! nunmap <buffer> d
		silent! nunmap <buffer> u
	else
		nnoremap <buffer> q <c-w>q
		nnoremap <buffer> gj j
		nnoremap <buffer> gk k
		nnoremap <buffer> d <c-d>
		nnoremap <buffer> u <c-u>
	endif
endfunction

augroup NotModifiableBuffer
	au!
	au BufAdd,BufNew,VimEnter * call ProcessModifiable()
	au OptionSet modifiable     call ProcessModifiable()
augroup END

augroup CloseNetrw
	au!
	au FileType netrw setl bufhidden=wipe
augroup END
