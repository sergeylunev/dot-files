" CONFIGS ---------------------------------------------------------------- {{{
" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of
" file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Dont use visual bell instead of beeping.
set novisualbell
" Dont use ringing bell
set noerrorbells

" Add numbers to each line on the left-hand side.
set number

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Use space characters instead of tabs.
set expandtab

" Do not save backup files.
set nobackup

" Use a swapfile for the buffer.  This option can be reset when a
" swapfile is not wanted for a specific buffer. Turned off
set noswapfile

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=5

" Set default encoding
set encoding=utf-8

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" While searching though a file incrementally highlight matching characters
" as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=1000

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" 'colorcolumn' is a comma separated list of screen columns that are
" highlighted with ColorColumn
set colorcolumn=80,120
hi ColorColumn guibg=#444444

" When on, splitting a window will put the new window right of the current one
set splitright

" Tunr on smartindents
set smartindent
" Dont kill buffer when it lose focus
set hidden

" allow backspacing over autoindent
" allow backspacing over line breaks (join lines)
" allow backspacing over the start of insert
set backspace=indent,eol,start

" Show the line number relative to the line with the cursor in front of each
" line
set relativenumber

" Autosave on focus lost, but dont know need it or not
au FocusLost * :wa

set background=dark
colorscheme solarized

" }}}

" PLUGINS ---------------------------------------------------------------- {{{
call plug#begin('~/.vim/plugged')
     Plug 'preservim/nerdtree'
     Plug 'arcticicestudio/nord-vim'
call plug#end()
" }}}

" MAPPINGS --------------------------------------------------------------- {{{

" Set the backslash as the leader key.
" let mapleader = "\"

" Press \\ to jump back to the last cursor position.

nnoremap <leader>\ ``

inoremap jj <esc>

" Turn off arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

" Center the cursor vertically when moving to the next word during a search.
nnoremap n nzz
nnoremap N Nzz
" When making a change the cursor position is remembered.  One position is
" remembered for every change that can be undone, unless it is close to a
" previous change.  Two commands can be used to jump to positions of changes,
" also those that have been undone:
" g;            Go to [count] older position in change list.
nnoremap g; g;zz
" g,            Go to [count] newer cursor position in change list.
nnoremap g, g,zz

" Yank from cursor to the end of line.
nnoremap Y y$

" You can split the window in Vim by typing :split or :vsplit.
" Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or
" CTRL+l.
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
noremap <c-up> <c-w>-
noremap <c-down> <c-w>+
noremap <c-left> <c-w><
noremap <c-right> <c-w>>

" Turn F1 off. So annoing...
vnoremap <F1> <ESC>
" F2 - save filse
nmap <F2> :w<cr>
" NERDTree specific mappings.
" Map the F3 key to toggle NERDTree open and close.
nnoremap <F3> :NERDTreeToggle<cr>
" Switch betwen buffers
nnoremap <F5> :bp<cr>
nnoremap <F6> :bn<cr>

" Auto add closing bracket
inoremap { {}<left>
inoremap ( ()<left>
inoremap [ []<left>
" And if we need only one just press two times
inoremap {{ {
inoremap (( (
inoremap [[ [
" Auto add double quotes
inoremap ' ''<left>
inoremap " ""<left>
" When we need only one quote
inoremap "" "
inoremap '' '

" Have nerdtree ignore certain files and directories.
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']


" }}}

" VIMSCRIPT -------------------------------------------------------------- {{{
" This will enable code folding.
" Use the marker method of folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" If GUI version of Vim is running set these options.
if has('gui_running')

    " Set the background tone.
    set background=dark

    " Set the color scheme.
    colorscheme nord

    " Set a custom font you have installed on your computer.
    " Syntax: set guifont=<font_name>\ <font_weight>\ <size>
    set guifont=JetBrains\ Mono\ 14

    " Display more of the file by default.
    " Hide the toolbar.
    set guioptions-=T

    " Hide the the left-side scroll bar.
    set guioptions-=L

    " Hide the the right-side scroll bar.
    set guioptions-=r

    " Hide the the menu bar.
    set guioptions-=m

    " Hide the the bottom scroll bar.
    set guioptions-=b

    " Map the F4 key to toggle the menu, toolbar, and scroll bar.
    " <Bar> is the pipe character.
    " <CR> is the enter key.
    nnoremap <F4> :if &guioptions=~#'mTr'<Bar>
        \set guioptions-=mTr<Bar>
        \else<Bar>
        \set guioptions+=mTr<Bar>
        \endif<CR>

endif
" }}}

" STATUS LINE ------------------------------------------------------------ {{{
" Clear status line when vimrc is reloaded.
set statusline=
"
" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R
"
" Use a divider to separate the left side from the right side.
set statusline+=%=
"
" Status line right side.
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%
"
" Show the status on the second to last line.
set laststatus=2

" }}} 

