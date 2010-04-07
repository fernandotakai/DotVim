":syntax on
"set cindent
"set smartindent
"set autoindent
"set expandtab
"set tabstop=2
"set shiftwidth=2

if has("gui_running")
  colorscheme mustang  
else
  colorscheme desert
endif

" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Jul 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup		" keep a backup file
set history=100	" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
syntax on
set hlsearch

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
  set tabstop=4
  set shiftwidth=4
  set expandtab

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=80

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

set guioptions-=T
set ruler
set nohls

" Search
set incsearch
set ignorecase
set smartcase

nnoremap * :set hlsearch<cr>*
nnoremap # :set hlsearch<cr>#
nnoremap / :set hlsearch<cr>/
nnoremap ? :set hlsearch<cr>?
nnoremap <silent> <C-l> :nohl<CR><C-l>

" This is done so we can walk around with the cursor
set virtualedit=all

" FuzzyFinder
nmap <c-e> :FuzzyFinderTag<cr>
nmap <c-s> :FuzzyFinderBuffer<cr>
nmap <c-f> :FuzzyFinderTextMate<cr>

let g:fuzzy_ignore = "*.pyc"
let g:fuzz_matching_limit = 20

" MiniBuff explorer settings
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1 

" \b goes to minibufexplorer 
map <Leader>b :MiniBufExplorer<cr>

" \t toggls the taglist window
map <Leader>t :TlistToggle<cr>
"imap <S-Tab> <C-o><<
nmap <c-m> :nohlsearch<cr>


au! BufRead,BufNewFile *.json setfiletype json 
