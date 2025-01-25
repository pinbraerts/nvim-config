scriptencoding utf-8
language en_US.utf8
filetype plugin indent on
syntax on
let &t_EI = "\e[2 q"
let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
set ttimeout
set ttimeoutlen=1
set ttyfast
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
set shiftwidth=2
set tabstop=4
set expandtab
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

" disable highlight
nnoremap <esc> <cmd>nohls<cr>
vnoremap <esc> <c-c>

" paste from clipboard while typing
inoremap <c-v> <c-c>"*pa

" replace without overriding register
vnoremap R "_dP

" move lines on alt
nnoremap <silent> <a-k>      <cmd>m-2<cr>==
nnoremap <silent> <a-j>      <cmd>m+1<cr>==
inoremap <silent> <a-j> <c-c><cmd>m+1<cr>==a
inoremap <silent> <a-k> <c-c><cmd>m-2<cr>==a

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

if getenv("TMUX") != v:null
  function! Navigate(direction, tmux_direction)
    let num_before = winnr()
    exec "wincmd " . a:direction
    if winnr() == num_before
      silent call job_start(['tmux', 'select-pane', a:tmux_direction])
    endif
  endfunction
  nnoremap <c-j> <cmd>call Navigate("j", "-D")<cr>
  nnoremap <c-k> <cmd>call Navigate("k", "-U")<cr>
  nnoremap <c-h> <cmd>call Navigate("h", "-L")<cr>
  nnoremap <c-l> <cmd>call Navigate("l", "-R")<cr>
else
  nnoremap <c-j> <c-w>j
  nnoremap <c-k> <c-w>k
  nnoremap <c-h> <c-w>h
  nnoremap <c-l> <c-w>l
endif

" command line remaps
cnoremap <c-h> <left>
cnoremap <c-j> <down>
cnoremap <c-k> <up>
cnoremap <c-l> <right>

function! ToggleText()
  if &wrap
    set nowrap
    set nolinebreak
    silent! nunmap <buffer> gj
    silent! nunmap <buffer> gk
    silent! nunmap <buffer> j
    silent! nunmap <buffer> k
  else
    set wrap
    set linebreak
    nnoremap <buffer> gj j
    nnoremap <buffer> gk k
    nnoremap <buffer> j gj
    nnoremap <buffer> k gk
  endif
endfunction

function! ProcessModifiable()
  if &modifiable
    silent! nunmap <buffer> q
    silent! nunmap <buffer> d
    silent! nunmap <buffer> u
    set wrap
    call ToggleText()
  else
    nnoremap <buffer> q <cmd>bd<cr>
    nnoremap <buffer> d <c-d>
    nnoremap <buffer> u <c-u>
    set nowrap
    call ToggleText()
  endif
endfunction

command! ToggleText call ToggleText()

augroup MyAutoCmds
  au!
  au VimEnter * silent !echo -ne "\e[2 q"
  au BufAdd,BufNew,BufEnter * call ProcessModifiable()
  au OptionSet modifiable     call ProcessModifiable()
  au FileType netrw setl bufhidden=wipe
augroup END
