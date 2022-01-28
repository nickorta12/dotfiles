call plug#begin(stdpath('data') . '/plugged')
Plug 'nathanaelkane/vim-indent-guides', { 'for': 'python' }
Plug 'vim-airline/vim-airline'
Plug 'cespare/vim-toml'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'tmhedberg/SimpylFold'
Plug 'vim-scripts/indentpython.vim'
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'jnurmine/Zenburn'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf.vim'
Plug 'nathanalderson/yang.vim'
call plug#end()

let g:vim_markdown_folding_disabled = 1
let g:airline_powerline_fonts = 1

highlight CocFloating ctermbg=black

" youcompleteme
"let g:ycm_autoclose_preview_window_after_completion = 0

" coc source settings
source ~/.config/nvim/coc-config.vim

set encoding=utf-8
set nocompatible
set modelines=0
set backspace=indent,eol,start
set relativenumber
set number

set laststatus=2
set tabstop=8
set shiftwidth=4
set softtabstop=0
set expandtab
set smarttab
set smartindent
set ignorecase
set smartcase
set signcolumn=no

set noshowmode
set showcmd
set t_Co=256
set bg=dark
set foldlevel=99

let mapleader=" "

nnoremap / /\v
vnoremap / /\v

" split navigations
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

nnoremap <tab> %
vnoremap <tab> %

nnoremap <leader><space> :nohlsearch<CR><C-L>
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>
nnoremap <leader>bls :ls<CR>
nnoremap <leader>f :call CocAction('format')<CR>

" restore-last-position
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

au BufRead,BufNewFile *.service set filetype=systemd
au BufRead,BufNewFile *.target set filetype=systemd
au BufRead,BufNewFile *.socket set filetype=systemd
