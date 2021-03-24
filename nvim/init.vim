" {{{ defaults
scriptencoding utf-8
" if filereadable(expand('$VIMRUNTIME/defaults.vim'))
"     unlet! g:skip_defaults_vim
"     source $VIMRUNTIME/defaults.vim
" endif
" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Enable file type detection and do language-dependent indenting.
filetype plugin indent on

" Switch syntax highlighting on
syntax on


" }}}

" Plugin loading and settings

call plug#begin(stdpath('config') . '/plugged')

Plug 'w0ng/vim-hybrid'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'itchyny/vim-cursorword'
Plug 'tpope/vim-commentary'
Plug 'romainl/vim-cool'
Plug 'kizza/actionmenu.nvim'

call plug#end()

set spelllang=en
set spell

" actionmenu
let g:loaded_actionmenu = 1
" Default icon for the actionmenu (see nerdfonts.com)
let g:actionmenu_icon = { 'character': 'ÔÉ´', 'foreground': 'yellow' }
command! -nargs=0 ActionMenu call s:actionmenu()
function! s:actionmenu()
	let l:cword = expand('<cword>')
	call actionmenu#open(s:build_menu(l:cword), function('s:apply_action'))
endfunction

function! s:apply_action(timer_id)
	let [l:index, l:item] = g:actionmenu#selected
	if ! empty(get(l:item, 'user_data'))
		execute l:item['user_data']
	endif
endfunction

function! s:build_menu(cword)
	let l:items = []
	let l:filetype = &filetype

	if empty(a:cword)

		" Blank operations
		if l:filetype ==# 'go'
			let l:items = extend(l:items, [
				\ { 'word': 'If err', 'user_data': 'GoIfErr' },
				\ { 'word': 'Vet', 'user_data': 'GoVet' },
				\ { 'word': 'Run', 'user_data': 'GoRun' },
				\ ])
		endif

		let l:items = extend(l:items, [
			\ { 'word': 'Select all', 'user_data': 'normal! ggVG' },
			\ { 'word': '-------' },
			\ ])

	else

		" Filetype operations
		if l:filetype ==# 'python'
			let l:items = extend(l:items, [
				\ { 'word': 'Definition', 'user_data': 'call jedi#goto()' },
				\ { 'word': 'References…', 'user_data': 'call jedi#usages()' },
				\ { 'word': '--------' },
				\ ])
		elseif l:filetype ==# 'go'
			let l:items = extend(l:items, [
				\ { 'word': 'Callees…', 'user_data': 'GoCallees' },
				\ { 'word': 'Callers…', 'user_data': 'GoCallers' },
				\ { 'word': 'Definition', 'user_data': 'GoDef' },
				\ { 'word': 'Describe…', 'user_data': 'GoDescribe' },
				\ { 'word': 'Implements…', 'user_data': 'GoImplements' },
				\ { 'word': 'Info', 'user_data': 'GoInfo' },
				\ { 'word': 'Referrers…', 'user_data': 'GoReferrers' },
				\ { 'word': '--------' },
				\ ])
		elseif l:filetype ==# 'javascsript' || l:filetype ==# 'jsx'
			let l:items = extend(l:items, [
				\ { 'word': 'Definition', 'user_data': 'TernDefSplit' },
				\ { 'word': 'References…', 'user_data': 'TernRefs' },
				\ { 'word': '--------' },
				\ ])
		endif

		" Word operations
		let l:items = extend(l:items, [
			\ { 'word': 'Find symbol…', 'user_data': 'DeniteCursorWord tag:include -no-start-filter' },
			\ { 'word': 'Paste from…', 'user_data': 'Denite neoyank -default-action=replace -no-start-filter' },
			\ { 'word': 'Grep…', 'user_data': 'DeniteCursorWord grep -no-start-filter' },
			\ { 'word': '-------' },
			\ ])
	endif

	" File operations
	let l:items = extend(l:items, [
		\ { 'word': 'Lint', 'user_data': 'Neomake' },
		\ { 'word': 'Bookmark', 'user_data': 'BookmarkToggle' },
		\ { 'word': 'Git diff', 'user_data': 'Gdiffsplit' },
		\ { 'word': 'Unsaved diff', 'user_data': 'DiffOrig' },
		\ { 'word': 'Open in browser', 'user_data': 'OpenSCM' },
		\ ])

	return l:items
endfunction


" vim-hybrid
set background=dark
colorscheme hybrid
set cursorline
" set termguicolors
" vim-hybrid

" vim-hybrid
let g:airline_powerline_fonts=1
let g:airline_theme = 'wombat'
let g:airline#extensions#tabline#enabled = 1
function! ArilineInit()
  let g:airline_section_a = airline#section#create(['mode', ' ', 'branch'])
  let g:airline_section_b = airline#section#create_left(['ffenc', 'hunks', '%F'])
  let g:airline_section_c = airline#section#create(['filetype'])
  let g:airline_section_x = airline#section#create(['%P'])
  let g:airline_section_y = airline#section#create(['%B'])
  let g:airline_section_z = airline#section#create_right(['%l', '%c'])
endfunction
" vim-airline

" {{{ conditional settings
if &diff
    nnoremap <C-q> :qa!<cr>
    set foldmethod=diff
    set list
    set nowrap
    augroup diff
        autocmd!
        autocmd VimEnter * ALEDisable
    augroup end
endif

" {{{ common settings
set path+=** "find files
set synmaxcol=1000
set modeline
set report=0
set lazyredraw " to avoid scrolling problems
set nowrapscan
set hls
set mouse=nv
set encoding=utf-8
set novisualbell
set noerrorbells
set fileformats=unix,dos,mac
set virtualedit=block
" set formatoptions+=1

" autocmd BufEnter * silent! lcd %:p:h

" if sudo, disable vim swap/backup/undo/shada/viminfo writing
if $SUDO_USER !=# '' && $USER !=# $SUDO_USER
		\ && $HOME !=# expand('~'.$USER)
		\ && $HOME ==# expand('~'.$SUDO_USER)

	set noswapfile
	set nobackup
	set nowritebackup
	set noundofile
endif

" History saving
set history=1000

" clipboard
if has('clipboard')
	set clipboard& clipboard+=unnamedplus
endif

" Wildmenu
if has('wildmenu')
	" set nowildmenu
	" set wildmode=list:longest,full
	" set wildoptions=tagfile
	" set wildignorecase
	set wildignore+=.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out,*~,%*
	set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
	set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
	set wildignore+=application/vendor/**,**/vendor/ckeditor/**,media/vendor/**
	set wildignore+=__pycache__,*.egg-info,.pytest_cache
endif

 " Tabs and Indents
" set textwidth=120 " Text width maximum chars before wrapping
set expandtab       " Don't expand tabs to spaces.
set tabstop=2       " The number of spaces a tab is
set softtabstop=2   " While performing editing operations
set shiftwidth=2    " Number of spaces to use in auto(indent)
set smarttab        " Tab insert blanks according to 'shiftwidth'
set autoindent      " Use same indenting on new lines
set smartindent     " Smart autoindenting on new lines
set shiftround      " Round indent to multiple of 'shiftwidth'

" searching
set ignorecase      " Search ignoring case
set smartcase       " Keep case when searching with *
set infercase       " Adjust case in insert completion mode
set incsearch       " Incremental search
set wrapscan        " Searches wrap around the end of the file
set showmatch       " Jump to matching bracket
set matchpairs+=<:> " Add HTML brackets to pair matching
set matchtime=1     " Tenths of a second to show the matching paren
set cpoptions-=m    " showmatch will wait 0.5s or until a char is typed
set showfulltag     " Show tag and tidy search in completion
"set complete=.      " No wins, buffs, tags, include scanning

if exists('+inccommand')
	set inccommand=nosplit
endif

" Behavior
set nowrap                      " No wrap by default
set noautochdir
set linebreak                   " Break long lines at 'breakat'
set breakat=\ \	;:,!?           " Long lines break chars
set nostartofline               " Cursor in same column for few commands
set whichwrap+=h,l,<,>,[,],~    " Move to following line on certain keys
set splitbelow splitright       " Splits open bottom right
set switchbuf=useopen,usetab    " Jump to the first open window in any tab
set switchbuf+=vsplit           " Switch buffer behavior to vsplit
set backspace=indent,eol,start  " Intuitive backspacing in insert mode
set diffopt=filler,iwhite       " Diff mode: show fillers, ignore whitespace
set completeopt=menuone         " Always show menu, even for one item
set completeopt+=noselect       " Do not select a match in the menu

" Editor UI
set noshowmode          " Don't show mode in cmd window
set shortmess=aoOTI     " Shorten messages and don't show intro
set scrolloff=2         " Keep at least 2 lines above/below
set sidescrolloff=5     " Keep at least 5 lines left/right
set number              " Don't show line numbers
set relativenumber
set noruler             " Disable default status ruler
set list                " Show hidden characters

set showtabline=2       " Always show the tabs line
set winwidth=30         " Minimum width for active window
set winminwidth=10      " Minimum width for inactive windows
set winheight=4         " Minimum height for active window
set winminheight=1      " Minimum height for inactive window
set pumheight=15        " Pop-up menu's line height
set helpheight=12       " Minimum help window height
set previewheight=12    " Completion preview height

set showcmd             " Show command in status line
set cmdheight=2         " Height of the command line
set cmdwinheight=5      " Command-line lines
set equalalways         " Resize windows on split or close
set laststatus=2        " Always show a status line
set colorcolumn=120      " Highlight the 80th character limit
set display=lastline
hi ExtraWhitespace cterm=underline
match ExtraWhitespace /\s\+$/

" UI Symbols
" icons:  ▏│ ¦ ╎ ┆ ⋮ ⦙ ┊ 
set showbreak=↪
set listchars=tab:\▏\ ,extends:⟫,precedes:⟪,nbsp:␣,trail:·
"set fillchars=vert:▉,fold:─
" }}}

" {{{ mappings

" comment all the mappings to train my muscle
let mapleader=";"
inoremap jj <Esc>
inoremap kkk <Esc>
inoremap hhh <Esc>
inoremap llll <Esc>

" use ctrl+h/j/k/l switch window
" noremap <C-h> <C-w>h
" noremap <C-j> <C-w>j
" noremap <C-k> <C-w>k
" noremap <C-l> <C-w>l

" double leader toggle visual
nmap <leader><leader> V

" Toggle fold
nnoremap <CR> za


" Start an external command with a single bang
nnoremap ! :!

" Sudo to write
cnoremap w!! w !sudo tee % >/dev/null

" Shortcut to use blackhole register by default
nnoremap d "_d
vnoremap d "_d
nnoremap D "_D
vnoremap D "_D
nnoremap c "_c
vnoremap c "_c
nnoremap C "_C
vnoremap C "_C
nnoremap x "_x
vnoremap x "_x
nnoremap X "_X
vnoremap X "_X

" Shortcut to use clipboard with <leader>
nnoremap <leader>d dd
vnoremap <leader>d dd
nnoremap <leader>D DD
vnoremap <leader>D DD
nnoremap <leader>c c
vnoremap <leader>c c
nnoremap <leader>C C
vnoremap <leader>C C
nnoremap <leader>x x
vnoremap <leader>x x
nnoremap <leader>X X
vnoremap <leader>X X

function! CleverTab()
  if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
    return "\<Tab>"
  elseif strpart( getline('.'), col('.')-2, 2) =~ '\s$'
    return "\<Tab>"
  else
    return "\<C-N>"
  endif
endfunction

inoremap <Tab> <C-R>=CleverTab()<CR>


inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

inoremap <C-f> <Right>
inoremap <C-h> <Left>
" }}}
