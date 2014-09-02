call pathogen#infect()

set textwidth=80
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

" let g:solarized_termcolors=256

" set background=dark
" colorscheme solarized
colorscheme reburn

au FileType python setl sw=4 sts=4 et

set wildignore+=*.pyc

" Custom nerdtree settings
nnoremap \nto :NERDtree<CR>
nnoremap \ntc :NERDtreeClose<CR>

" PyMatcher for CtrlP
if !has('python')
  echo 'In order to use pymatcher plugin, you need +python compiled vim'
else
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif

" Custom setting for ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_custom_ignore='\v(3rdparty|build)/'
let g:ctrlp_lazy_update = 350
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_files = 0
if executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --ignore ''.git'' --hidden -g ""'
endif

" Journal settings
nmap \jj :JournalToggle<CR>
let g:journal_directory="~/.journal"

" This opens up a list of the current buffers for easy selection
nnoremap <F5> :buffers<CR>:buffer<Space>

" No ex mode
nnoremap Q <Nop>

" Remove highlighting
nmap <F12> :noh<CR>

" Simple block commenting
nmap \cc :s/^/\/\/<CR>:noh<CR>
nmap \cx :s/^\/\//<CR>:noh<CR>
vmap \cc :s/^/\/\/<CR>:noh<CR>
vmap \cx :s/^\/\//<CR>:noh<CR>

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

