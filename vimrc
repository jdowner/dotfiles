call pathogen#infect()
call pathogen#helptags()

set textwidth=80
set colorcolumn=80
set expandtab
set tabstop=2
set autoindent
set copyindent
set number
set shiftwidth=2
set shiftround
set showmatch
set ignorecase
set smartcase
set hlsearch
set incsearch
set autowriteall
set nobackup
set noswapfile
set nocompatible
set nowrap
set modeline
set runtimepath^=~/.vim/bundle/ctrlp.vim
syntax on
filetype plugin indent on
set wildignore+=*.pyc

au BufRead,BufNewFile *.cpp set tabstop=4
au BufRead,BufNewFile *.cpp set shiftwidth=4
au BufRead,BufNewFile *.hpp set tabstop=4
au BufRead,BufNewFile *.hpp set shiftwidth=4
au FileType python setl sw=4 sts=4 et

let python_no_builtin_highlight = 1

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

colorscheme reburn

" pyflake8
hi clear PyFlakes
hi PyFlakes ctermfg=Red cterm=underline

" Custom nerdtree settings
nnoremap <F8> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc']
let NERDTreeQuitOnOpen=1

" PyMatcher for CtrlP
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

" Custom setting for ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore='\v\.(git|install|build)/'
let g:ctrlp_lazy_update = 350
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_max_files = 0
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files . -co --exclude-standard'],
    \ },
  \ 'fallback': 'find %s -type f'
  \ }

if executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor
  " let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --ignore ''.git'' --hidden -g ""'
endif


""""""""""""""""""""
" GnuPG Extensions "
""""""""""""""""""""

let g:GPGDefaultRecipients=['Joshua Downer']

" Tell the GnuPG plugin to armor new files.
let g:GPGPreferArmor=1

" Tell the GnuPG plugin to sign new files.
let g:GPGPreferSign=1

augroup GnuPGExtra
" Set extra file options.
    autocmd BufReadCmd,FileReadCmd *.\(gpg\|asc\|pgp\) call SetGPGOptions()
" Automatically close unmodified files after inactivity.
    autocmd CursorHold *.\(gpg\|asc\|pgp\) quit
augroup END

function SetGPGOptions()
" Set updatetime to 1 minute.
    set updatetime=60000
" Fold at markers.
    set foldmethod=marker
" Automatically close all folds.
    set foldclose=all
" Only open folds with insert commands.
    set foldopen=insert
endfunction


" Journal settings
nmap \jj :JournalToggle<CR>
let g:journal_directory="~/.journal"
let g:journal_encrypted=1

" This opens up a list of the current buffers for easy selection
nnoremap <F5> :buffers<CR>:buffer<Space>

nmap \qq :e #<CR>

" No ex mode
nnoremap Q <Nop>

" Remove highlighting
nmap <F12> :noh<CR>

" Simple block commenting
nmap \cc :s/^/\/\/<CR>:noh<CR>
nmap \cx :s/^\/\//<CR>:noh<CR>
vmap \cc :s/^/\/\/<CR>:noh<CR>
vmap \cx :s/^\/\//<CR>:noh<CR>

" Remove trailing whitespace
nmap \wc :%s/\s*$//<CR>:noh<CR>
vmap \wc :s/\s*$//<CR>:noh<CR>

" Toggle line numbers
nnoremap \nn :set nonumber!<CR>

" Cycle through grep results
nmap <silent> cn :cn<CR>zz
nmap <silent> cp :cp<CR>zz

" Handle tmux $TERM quirks in vim
if $TERM =~ '^screen-256color'
  map <Esc>OH <Home>
  map! <Esc>OH <Home>
  map <Esc>OF <End>
  map! <Esc>OF <End>
endif

" Whitespace highlighting
:highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen

" Show trailing whitespace:
:match ExtraWhitespace /\s\+\%#\@<!$/

" neovim specific
if has('nvim')
    tnoremap <A-n> <C-\><C-n>

    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l
endif

" Show syntax highlighting groups for word under cursor
nmap <leader>z :call SynStack()<CR>
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
