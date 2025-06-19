" ===========================
" BASIC INDENTATION SETTINGS
" ===========================

set expandtab        " Use spaces instead of tabs
set smarttab         " Make tabbing smarter (uses shiftwidth for tabs)
set shiftwidth=2     " Number of spaces to use for autoindent
set tabstop=2        " Number of spaces that a <Tab> in the file counts for

" ===========================
" FILETYPE AND INDENTATION
" ===========================

filetype plugin on   " Enable filetype-specific plugins
filetype indent on   " Enable filetype-specific indenting

set ai               " Auto-indent new lines
set si               " Smart indenting for C-like programs
set wrap             " Wrap long lines to fit screen width

" ===========================
" FILE HANDLING
" ===========================

set autoread 		        " Automatically reload files changed outside Vim
set backspace=eol,start,indent	" Make backspace work as expected

" ===========================
" BRACKET MATCHING
" ===========================

set showmatch        " Show matching bracket when cursor is over one
set mat=2            " Blink delay when showing a match (tenths of a second)

" ===========================
" UI BEHAVIOR
" ===========================

set noerrorbells     " Don't beep on error
set novisualbell     " Don't flash the screen on error
set t_vb=            " Disable visual bell (useful for macOS)
set tm=500           " Timeout length for mapped sequences (ms)

" ===========================
" SYNTAX AND ENCODING
" ===========================

syntax enable        " Enable syntax highlighting
set encoding=utf8    " Set file encoding to UTF-8
set ffs=unix,dos,mac " Use Unix file format by default, but allow DOS/mac

" ===========================
" FILE BACKUPS
" ===========================

set nobackup         " Don't make backup files
set nowb             " Don't write backup files
set noswapfile       " Don't create swap files (less clutter)

" ===========================
" RESTORE LAST POSITION
" ===========================

autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
     " When reopening a file, return to the last editing position

set viminfo^=%       " Remember file marks and info between sessions

" ===========================
" QUALITY OF LIFE ADDITIONS
" ===========================

set number           " Show line numbers
set relativenumber   " Show relative line numbers (useful for movement)
set cursorline       " Highlight the current line
set showcmd          " Show partial commands in bottom right
set ruler            " Show cursor position
set wildmenu         " Enable enhanced command-line completion
set hlsearch         " Highlight all search results
set incsearch        " Show matches as you type
set ignorecase       " Ignore case when searching...
set smartcase        " ...unless uppercase is used

" ===========================
" MOUSE SUPPORT (macOS friendly)
" ===========================

set mouse=a          " Enable mouse support in all modes

" ===========================
" CLIPBOARD INTEGRATION
" ===========================

" set clipboard=unnamedplus " Use system clipboard (great for macOS)

" ===========================
" COLORS
" ===========================

colorscheme desert   " Set a simple, readable colorscheme (change as preferred)

