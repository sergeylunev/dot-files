" Let filetype handling off. Needed by Vundle. On in end of file
filetype off
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle options && Bundle installing options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Add vundle path
set rtp+=~/.vim/bundle/vundle/
" Call Vundle
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" Switch to zenburn theme. Much more comfortable for my eyes
Bundle 'Zenburn'

" NerdTREE - https://github.com/scrooloose/nerdtree
" The NERD tree allows you to explore your filesystem and to open 
" files and directories. It presents the filesystem to you in the 
" form of a tree which you manipulate with the keyboard and/or mouse. 
" It also allows you to perform simple filesystem operations.
Bundle 'scrooloose/nerdtree'

" tComment plugin — plugin for better commenting
Bundle 'tComment'

" Minibuff Explorer plugin
Bundle 'fholgado/minibufexpl.vim'

" Matchit plugin, form mutching tags and otver
Bundle 'matchit.zip'

" twig syntax bundle
" https://github.com/beyondwords/vim-twig.git
Bundle 'beyondwords/vim-twig.git'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" End Vundle setup
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Start fyle type support
filetype plugin indent on
" Включаем подсветку синтаксиса
syntax on
" Выключаем обратную совместимость с vi
set nocompatible
" Заделывает кое какие дыры в безопасности
set modelines=0
" Настройки табуляции
" Ставим табуляцию равную 4 символам
set tabstop=4
set shiftwidth=4
set softtabstop=4
" Заменяем табы на пробелы
set smarttab
" Удаляем пробелы в начале строки одним нажатием
set expandtab
" Задаем кодировку текста по умолчанию: utf-8
set encoding=utf-8
" Если на utf-8 то открываем как cp1251
set fileencodings=utf-8,cp1251,koi8-r,cp866
" Сколько строк остается под или над курсором
set scrolloff=5
" Включаем автоматический отступы
set smartindent
" Когда буфер теряет фокус, то он не убивается, а просто прячется
set hidden

" Включаем появление меню при автодополнении в командной строке
set wildmenu
" When more than one match, list all matches and complete till longest common string.
set wildmode=list:longest

" Dont use visual bell instead of beeping.
set novisualbell
" Dont use ringing bell
set noerrorbells

" Highlight the screen line of the cursor with CursorLine
set cursorline
" hi CursorLine ctermbg=125 cterm=none

" Indicates a fast terminal connection. Improves smoothness of redrawing
set ttyfast

" Set ruler at bottom of screen and set its format
set ruler

" allow backspacing over autoindent
" allow backspacing over line breaks (join lines)
" allow backspacing over the start of insert
set backspace=indent,eol,start

" Status line will shown always
set laststatus=2

" Show the line number relative to the line with the cursor in front of each line
set relativenumber

" Ignore case in search patterns.
set ignorecase
" Override the 'ignorecase' option if the search pattern contains upper case characters.
set smartcase
" While typing a search command, show where the pattern, as it was typed so far, matches.
set incsearch
" When there is a previous search pattern, highlight all its matches
set hlsearch

" When on, lines longer than the width of the window will wrap and displaying 
" continues on the next line
set wrap
" Maximum width of text that is being inserted. A longer line will be broken 
" after white space to get this width
set textwidth=79

" This is a sequence of letters which describes how automatic formatting is to be done
" q: Allow formatting of comments with "gq".
" r: Automatically insert the current comment leader after hitting <Enter> in Insert mode.
" n: When formatting text, recognize numbered lists.
" 1: Don't break a line after a one-letter word.  It's broken before it
"    instead (if possible).
set formatoptions=qrn1

" Characters to fill the statuslines and vertical separators.
set fillchars=fold:\-

" Autosave on focus lost, but dont know need it or not
au FocusLost * :wa

" Set russian keymap for keyboard
set keymap=russian-jcukenwin
" Make latin default keymap in insert mode
set iminsert=0
" Make latin default keymap in search mode
set imsearch=0
" Languages for spell checking. TODO enable this option
" set spelllang=en,ru

" Chose colorscheme
colorscheme zenburn

" Set default font : Consolas 12
set guifont=Consolas\ 12
" Set cursor behavior
" TODO: think aboit cursor behavior
highlight Cursor guifg=white guibg=#565656
highlight iCursor guifg=white guibg=steelblue
set guicursor=n-v-c:block-Cursor
set guicursor+=i:ver100-iCursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkwait0

" Save last 150 commands
set history=250

" Open fullscreen in linux
" set lines=64
" set columns=239

" Close panels and menus in gVim
set guioptions-=T
set guioptions-=m
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R

" When on, Vim will change the current working directory whenever you
" open a file, switch buffers, delete a buffer or open/close a window.
" It will change to the directory containing the file which was opened
" or selected.
" set autochdir

" Folding method is: manual
set foldmethod=manual
" When non-zero, a column with the specified width is shown at the side
" of the window which indicates open and closed folds.
set foldcolumn=2

" When a file has been detected to have been changed outside of Vim and
" it has not been changed inside of Vim, automatically read it again.
set autoread
    
" информация о флагах файла и его пути в строке статуса
set statusline=%1*%m%*%2*%r%*%3*%h%w%*%{expand(\"%:p:~\")}\ %<
" информация о положении курсора в строке статуса
set statusline+=%=Col:%3*%03c%*\ Ln:%3*%04l/%04L%*
" информация о типе и атрибутах файла в строке статуса
set statusline+=%(\ File:%3*%{join(filter([&filetype,&fileformat!=split(&fileformats,\",\")[0]?&fileformat:\"\",&fileencoding!=split(&fileencodings,\",\")[0]?&fileencoding:\"\"],\"!empty(v:val)\"),\"/\")}%*%)

" Enable title string
set title
" Set format for title string
set titlestring=%t%(\ %m%)%(\ %r%)%(\ %h%)%(\ %w%)%(\ (%{expand(\"%:p:~:h\")})%)\ -\ VIM

" This option defines the behavior of the selection. Old let chose next line.
set selection=old

" Round indent to multiple of 'shiftwidth'
set shiftround

" When 'confirm' is on, certain operations that would normally
" fail because of unsaved changes to a buffer, e.g. ":q" and ":e",
" instead raise a |dialog| asking if you wish to save the current file(s).
set confirm
" Some shortner message string
set shortmess=fimnrxoOtTI
" Threshold for reporting number of lines changed.  When the number of
" changed lines is more than 'report' a message will be given for most
" ":" commands.  If you want it always, set 'report' to 0.
set report=0

" When on, splitting a window will put the new window right of the current one
set splitright

" When on, all the windows are automatically made the same size after
" splitting or closing a window.
set noequalalways

" Higlight some symbols
set list
" List of symbols to higlight.
set listchars=tab:❘-,extends:»,precedes:«,nbsp:×

" Allow specified keys that move the cursor left/right to move to the
" previous/next line when the cursor is on the first/last character in
" the line.
set whichwrap=b,s,h,l,<,>,~,[,]

" Mouse context menu
set mousemodel=popup

" Let mouse focusing windows
set mousefocus

" Dont hide mouse when typing
set nomousehide

" Which directory to use for the file browser
" buffer    Use the directory of the related buffer
set browsedir=buffer

" Show (partial) command in the last line of the screen.
set showcmd

" Make a backup before overwriting a file.  Leave it around after the
" file has been successfully written. Set to off
set nobackup
" Use a swapfile for the buffer.  This option can be reset when a
" swapfile is not wanted for a specific buffer. Turned off
set noswapfile

" Changes the effect of the |:mkview| command.  It is a comma separated
" list of words.  Each word enables saving and restoring something:
"       cursor - cursor position in file and in window
"       folds - manually created folds, opened/closed folds and local fold options
set viewoptions=cursor,folds

" 'colorcolumn' is a comma separated list of screen columns that are
" highlighted with ColorColumn
set colorcolumn=80,120
hi ColorColumn guibg=#444444

set timeoutlen=250

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key's defenition
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Leader is: \
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Insert mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make 'jj' as <esc>. Its rly faster. I sware
inoremap jj <ESC>
" Turn off arrow keys
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
" Turn F1 off. So annoing...
inoremap <F1> <ESC>
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
" Insert 'loreum ipsum'
inoremap <leader>l Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi malesuada, ante at feugiat tincidunt, enim massa gravida metus, commodo lacinia massa diam vel eros. Proin eget urna. Nunc fringilla neque vitae odio. Vivamus vitae ligula.
" F2 - save filse
imap <F2> <esc>:w<cr>i
" <c-f> — change vim keymap
inoremap <c-f> <c-^>
" Toggle NerdTree
inoremap <F3> <ESC>:NERDTreeToggle<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Normal mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn F1 off. So annoing...
nnoremap <F1> <ESC>
" Turn off arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
" Easy moving betwen lines when wrap enabled
nnoremap j gj
nnoremap k gk
" Remove higlight to previous search result
nnoremap <leader><space> :noh<cr>
" Split window vertical
nnoremap <leader>w <C-w>v<C-w>l
" Open and reload .vimrc
nmap <silent> <leader>ev :e $HOME/.vimrc<cr>
nmap <silent> <leader>sv :so $HOME/.vimrc<cr>
" F2 - save filse
nmap <F2> :w<cr>
" Switch betwen buffers
nnoremap <F5> :bp<cr>
nnoremap <F6> :bn<cr>
" Toggle NerdTree
nnoremap <F3> <ESC>:NERDTreeToggle<cr>
" Keep search matches in the middle of the window.
nnoremap n nzz
nnoremap N Nzz
" When making a change the cursor position is remembered.  One position is
" remembered for every change that can be undone, unless it is close to a
" previous change.  Two commands can be used to jump to positions of changes,
" also those that have been undone:
" g;			Go to [count] older position in change list.
nnoremap g; g;zz
" g,			Go to [count] newer cursor position in change list.
nnoremap g, g,zz
" Insert comments with tComment
nnoremap // :TComment<CR>
" IndentGuides Toggle
nmap <Leader>g :IndentGuidesToggle<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn F1 off. So annoing...
vnoremap <F1> <ESC>
" Easy moving betwen lines when wrap enabled
vnoremap j gj
vnoremap k gk
" When indent in visual mode start Visual mode with the same area as the 
" previous area and the same mode
vnoremap < <gv
vnoremap > >gv
" F2 - save filse
vmap <F2> <esc>:w<cr>i
" Toggle NerdTree
vnoremap <F3> <ESC>:NERDTreeToggle<cr>
" Insert comments with tComment
vnoremap // :TComment<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Other things
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indent guieds setings
let g:indent_guides_color_change_percent = 5
let g:indent_guides_guide_size = 1
