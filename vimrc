call pathogen#runtime_append_all_bundles()

set nocompatible
set vb

if &t_Co >= 256 || has("gui_running")
  colorscheme mustang
  set number
  set guifont=Droid\ Sans\ Mono\ Slashed:h12
  set relativenumber
else
  colorscheme desert
endif

set hidden
set backspace=indent,eol,start

set nobackup		
set history=100	
set ruler		
set showcmd		
set incsearch	 
set noswapfile
set scrolloff=5

if has('mouse')
  set mouse=a
endif

syntax on
set hlsearch

if $VIM_CRONTAB == "true"
    set nobackup
    set nowritebackup
endif

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
  set autoindent
endif 

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

set guioptions-=T
set cot-=preview
set ruler
set nohls

" Search
set incsearch
set ignorecase
set smartcase

" This is done so we can walk around with the cursor
set virtualedit=all
 
nnoremap # :set hlsearch<cr>#
nnoremap / :set hlsearch<cr>/
nnoremap ? :set hlsearch<cr>?
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>
let maplocalleader=','

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
 
vmap j gj
vmap k gk
nmap j gj
nmap k gk

nmap <c-m> :nohlsearch<cr>
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

map <Leader>b :MiniBufExplorer<cr>
map <Leader>t :TlistToggle<cr>
map <Leader><Tab> :Scratch<cr>
map <Leader>y :YRShow<cr>
map <Leader>a :Ack 
map <leader>g :GundoToggle<cr>

let g:fuzzy_ignore = "*.pyc"
let g:fuzz_matching_limit = 20

" MiniBuff explorer settings
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1 
let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'

noremap  <Up> <nop>
noremap  <Down> <nop>
noremap  <Left> <nop>
noremap  <Right> <nop>

" FUCKING MAN GO DIE IN HELL
noremap K <nop>

" ASSHOLE EX MODE NEEDS TO DIE TO. FUCKER.
noremap gQ <nop>

nnoremap <tab> :

" search buffer by pattern.
function! BufSel(pattern)
  let bufcount = bufnr("$")
  let currbufnr = 1
  let nummatches = 0
  let firstmatchingbufnr = 0
  while currbufnr <= bufcount
    if(bufexists(currbufnr))
      let currbufname = bufname(currbufnr)
      if(match(currbufname, a:pattern) > -1)
        echo currbufnr . ": ". bufname(currbufnr)
        let nummatches += 1
        let firstmatchingbufnr = currbufnr
      endif
    endif
    let currbufnr = currbufnr + 1
  endwhile
  if(nummatches == 1)
    execute ":buffer ". firstmatchingbufnr
  elseif(nummatches > 1)
    let desiredbufnr = input("Enter buffer number: ")
    if(strlen(desiredbufnr) != 0)
      execute ":buffer ". desiredbufnr
    endif
  else
    echo "No matching buffers"
  endif
endfunction

" splits buffer vertically by number
function! BufVSplit(num)
  execute ":vert sb ". a:num
endfunction

"Bind the BufSel() function to a user-command
command! -nargs=1 Bs :call BufSel("<args>")
command! -nargs=1 Vbuff :call BufVSplit("<args>")
map <leader>be :Bs  
map <leader>bv :Vbuff 
map <leader>bs :sbuff 
map <leader>x :BufClose<CR>

" \1 \2 \3 : go to buffer 1/2/3 etc
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

fu! DoRunPyBuffer2()
pclose! " force preview window closed
setlocal ft=python

" copy the buffer into a new window, then run that buffer through python
sil %y a | below new | sil put a | sil %!python -
" indicate the output window as the current previewwindow
setlocal previewwindow ro nomodifiable nomodified

" back into the original window
winc p
endfu

command! RunPyBuffer call DoRunPyBuffer2()
map <Leader>rp :RunPyBuffer<CR>
map <Leader>pc :pclose!<cr>

" ctags
map <silent> <c-]> :set noic<cr>g<c-]><silent>:set ic<cr>

" verify js files
au BufNewFile,BufRead *.js set makeprg=gjslint\ %
au BufNewFile,BufRead *.js set errorformat=%-P-----\ FILE\ \ :\ \ %f\ -----,Line\ %l\\,\ E:%n:\ %m,%-Q,%-GFound\ %s,%-GSome\ %s,%-Gfixjsstyle%s,%-Gscript\ can\ %s,%-G
au BufRead,BufNewFile /usr/local/Cellar/nginx/0.7.65/conf/* set ft=nginx 
au BufNewFile,BufRead *pentadactylrc*,*.penta set filetype=pentadactyl
au BufRead,BufNewFile Vagrantfile set filetype=ruby

au FocusLost * :wa

cmap w!! %!sudo tee > /dev/null %
map <Leader>E :Explore<cr>

" fuck you i want my clipboard to be awesome
set clipboard=unnamed

" java + eclim thingies
map <Leader>ji :JavaImportMissing<cr>
map <Leader>js :JavaSearchContext<cr>
map <Leader>jm :JavaImpl<cr>
map <Leader>jp :Project

" org mode thingies
let g:org_agenda_files = ['~/org/work.org', '~/org/personal.org']
let g:org_todo_keywords=['TODO', 'ONGOING', 'FEEDBACK', '|', 'DONE', 'DELEGATED', 'WONTFIX']

let g:utl_cfg_hdl_scm_http_system = "silent !open -a firefox '%u'"
