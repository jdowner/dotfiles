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

" Custom setting for ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPLastMode'
let g:ctrlp_custom_ignore='\v(3rdparty|build)/'

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

