" =============================
" Beginner-friendly Vim config
" =============================

" Show line numbers
set number

" Enable syntax highlighting
syntax on

" Enable mouse support
set mouse=a

" Enable clipboard support (system clipboard)
set clipboard=unnamedplus

" Set tabs and indentation
set expandtab       " use spaces instead of tabs
set tabstop=4       " number of spaces a tab counts for
set shiftwidth=4    " number of spaces to use for autoindent

" Enable search highlighting
set hlsearch
set incsearch

" Enable auto indentation
set autoindent
set smartindent

" Show status line
set laststatus=2

" Make backspace more intuitive
set backspace=indent,eol,start

" Make typing messages less annoying
set shortmess+=I

" Basic key shortcuts
" Save file: Ctrl+s
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Quit Vim: Ctrl+q
nnoremap <C-q> :q<CR>
inoremap <C-q> <Esc>:q<CR>

" Automatically redraw Vim when terminal regains focus
au FocusGained,BufEnter * :redraw!
