" [ 1 ] https://gist.github.com/gosukiwi/080d1d3f87f861a15c44
" turn on syntax highlighting
set nocompatible
syntax on
" make vim try to detect file types and load plugins for them
filetype on
filetype plugin on
filetype indent on
" reload files changed outside vim
" by default, in insert mode backspace won't delete over line breaks, or 
" " automatically-inserted indentation, let's change that

set backspace=indent,eol,start
" dont't unload buffers when they are abandoned, instead stay in the
" " background
set hidden
" keep powerbar open
set laststatus=2
"
" " set unix line endings
set fileformat=unix
" " when reading files try unix line endings then dos, also use unix for new
" " buffers
set fileformats=unix,dos
set autoread 
set encoding=utf-8
set fileencoding=utf-8
"filetype off                  " required
set clipboard=unnamed
" windows like clipboard
" yank to and paste from the clipboard without prepending "* to commands
let &clipboard = has('unnamedplus') ? 'unnamedplus' : 'unnamed'
" " map c-x and c-v to work as they do in windows, only in insert mode
vm <c-x> "+x
vm <c-c> "+y
cno <c-v> <c-r>+
if !exists("g:bracketed_paste_tmux_wrap")
  let g:bracketed_paste_tmux_wrap = 1
endif

function! WrapForTmux(s)
  if !g:bracketed_paste_tmux_wrap || !exists('$TMUX') || system('tmux -V')[5] >= '2'
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_ti .= WrapForTmux("\<Esc>[?2004h")
let &t_te .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin(ret)
  set pastetoggle=<f29>
  set paste
  return a:ret
endfunction

execute "set <f28>=\<Esc>[200~"
execute "set <f29>=\<Esc>[201~"
map <expr> <f28> XTermPasteBegin("i")
imap <expr> <f28> XTermPasteBegin("")
vmap <expr> <f28> XTermPasteBegin("c")
cmap <f28> <nop>
cmap <f29> <nop>

au FileType python setlocal formatprg=autopep8\ -
set pastetoggle=<f9>
" enable matchit plugin which ships with vim and greatly enhances '%'
runtime macros/matchit.vim
packadd! matchit
" fonts for macVIm
"set guifont=Liberation_Mono_for_Powerline:h10 
"set guifont=Source\ Code\ Pro\ for\ Powerline "make sure to escape the spaces in the name properly
let g:airline_powerline_fonts=1
let g:Powerline_symbols='unicode'
"let g:Powerline_symbols = 'fancy'
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

	" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace ='Ξ'
" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
" On File Types
" --------------------------------------------------------
set textwidth=80
set colorcolumn=80
au BufNewFile,BufRead *.py,*.js,*.html,*.css
    \ set autoindent |
    \ set expandtab |
    \ set smartindent |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
" FLag unecessary whitepsace
highlight BadWhitespace ctermbg=red guibg=red
" bad tab at new line
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
"   .md files are markdown files
autocmd BufNewFile,BufRead *.md setlocal ft=markdown
"   "   .twig files use html syntax
autocmd BufNewFile,BufRead *.twig setlocal ft=html
"   "   .less files use less syntax
autocmd BufNewFile,BufRead *.less setlocal ft=less
"   "   .jade files use jade syntax
autocmd BufNewFile,BufRead *.jade setlocal ft=jade
" filenames like *.xml, *.html, *.xhtml, ...
let g:closetag_filenames = "*.jsx,*.js,*.html,*.xhtml,*.phtml"
" run JSHint when a file with .js extension is saved
" " this requires the jsHint2 plugin
autocmd BufWritePost *.js silent :JSHint
" JSX syntax
let g:jsx_ext_required = 0
let g:xptemplate_brace_complete = '([{<'

" --------------------- PYTHON CONFIG -----------------------
"--------------------- PEP 8 ---------------------------
"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF
" Python 3 config - UTF8
" Enable folding
set foldmethod=indent
set foldlevel=80
" ------------------- KEYS ------------
"  Set leader key
let mapleader = ","
" Enable folding with the spacebar
nnoremap <space> za
" allow Tab and Shift+Tab to
" " tab  selection in visual mode
vmap <Tab> >gv
vmap <S-Tab> <gv 
" search settings
" set incsearch        " find the next match as we type the search
" set hlsearch         " hilight searches by default
" " use ESC to remove search higlight
" nnoremap <esc> :noh<return><esc>
"
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')


" SimpylFold package 
let g:SimpylFold_docstring_preview=1

let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
let python_hightlight_all=1
syntax on

" Color Scheme config
set t_Co=256
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark='hard'
"set termguicolors
"source "$HOME/.vim/bundle/gruvbox/gruvbox_256palette.sh"

"if has('gui_running')
"	set background=dark
"	colorscheme solarized
"else
"	colorscheme zenburn
"endif
"call togglebg#map("<F5>")
" Tabbing
map <C-t><up> :tabr<cr>
map <C-t><down> :tabl<cr>
map <C-t><left> :tabp<cr>
map <C-t><right> :tabn<cr>
" move between two latest files
nnoremap <leader><leader> <c-^>

" File Browsing config
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
" Super search

" Line Numbering
set nu

" System clipboard
set clipboard=unnamed

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)

"virtual env
"
"
" ---------------------- PLUGIN CONFIGURATION -------------------
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" generalge Vundle, required
Plugin 'gmarik/Vundle.vim'
" Syntax checking config
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
" color schemes & themes
Plugin 'morhetz/gruvbox'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
" file system browsing
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'vim-airline/vim-airline-themes'
" super search
Plugin 'kien/ctrlp.vim'
Plugin 'vim-airline/vim-airline'
" status bar
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
" git integration
Plugin 'tpope/vim-fugitive'
" Python
Plugin 'jmcantrell/vim-virtualenv'
Plugin 'tmhedberg/SimpylFold'
" Auto-Indentation package
Plugin 'vim-scripts/indentpython.vim'
" Python autocomplete config
Bundle 'Valloric/YouCompleteMe'
" Webdev
Plugin 'Shutnik/jshint2.vim'        
Plugin 'mattn/emmet-vim'            
Plugin 'kchmck/vim-coffee-script'   
Plugin 'groenewege/vim-less'        
" JSX
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'

"Plugin 'skammer/vim-css-color'      
"Plugin 'hail2u/vim-css3-syntax'     
Plugin 'digitaltoad/vim-jade'      
"Plugin 'alvan/vim-closetag'
Plugin 'drmingdrmer/xptemplate'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" start NERDTree on start-up and focus active window
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p

" map FuzzyFinder
noremap <leader>b :FufBuffer<cr>
noremap <leader>f :FufFile<cr>

" use zencoding with <C-E>
let g:user_emmet_leader_key = '<c-e>'


" set the color theme to wombat256
" colorscheme wombat256
" " make a mark for column 80
set colorcolumn=80
" " and set the mark color to DarkSlateGray
highlight ColorColumn ctermbg=lightgray guibg=lightgray
