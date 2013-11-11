"==========================================
" Plugins
"==========================================

if has('vim_starting')
  set nocompatible
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc', { 'build': {
  \   'windows': 'make -f make_mingw32.mak',
  \   'cygwin': 'make -f make_cygwin.mak',
  \   'mac': 'make -f make_mac.mak',
  \   'unix': 'make -f make_unix.mak',
  \ } }

" Fuzzy search
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'

" Utils
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-commentary'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'Townk/vim-autoclose'
NeoBundle 'edsono/vim-matchit'
NeoBundle 'Valloric/MatchTagAlways'
NeoBundle 'AndrewRadev/switch.vim'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'godlygeek/tabular'
NeoBundle 'vim-scripts/Emmet.vim'

" UI
NeoBundle 'bling/vim-airline'
NeoBundle 'airblade/vim-gitgutter'

" Snippets
NeoBundle 'SirVer/ultisnips'

" Filetypes
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'othree/html5-syntax.vim'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'wlangstroth/vim-haskell'
NeoBundle 'hspec/hspec.vim'
NeoBundle 'cakebaker/scss-syntax.vim'

" Colors
NeoBundle 'altercation/vim-colors-solarized'

" Tmux
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'jgdavey/tslime.vim'

NeoBundleCheck

"==========================================
" General
"==========================================

filetype plugin indent on
syntax enable
set shell=zsh
set history=1000
set undolevels=1000
set autowrite
set relativenumber
set numberwidth=4
set autoread
set timeoutlen=1000
set hidden
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smartindent
set autoindent
set foldenable
set foldmethod=syntax
set foldcolumn=0
set foldlevelstart=99
set foldlevel=20
set backspace=indent,eol,start
set wildmenu
set wildmode=list:longest
set ignorecase
set smartcase
set nobackup
set noswapfile
set nospell
set spelllang=en_us
set tags=./tags,tags;$HOME
set splitbelow
set splitright
set list listchars=tab:»·,trail:·
set list
match ErrorMsg '\%>100v.\+'

"==========================================
" Auto commands
"==========================================
" Jump to last cursor position unless it's invalid or in an event handler
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

autocmd FileType scss,sass,css,html setlocal foldmethod=indent
autocmd BufRead,BufNewFile *.scss set filetype=scss

" in sml files highlight lines that are longer than 80 chars
autocmd FileType sml match ErrorMsg '\%>80v.\+'

" in markdown files don't highlight long lines
autocmd FileType mkd match ErrorMsg '\%>99999v.\+'

" disable folding in markdown files
autocmd FileType mkd set nofoldenable

" automatically insert a semicolon in CSS files
autocmd FileType css imap : : ;<left>

" automatically insert closing bracket in HTML
autocmd FileType html imap < <><left>

"==========================================
" UI
"==========================================

set background=dark
colorscheme solarized
set t_Co=256
if has("gui_running")
  set guioptions=egmrt
  set guifont=Monaco:h14
  set guioptions-=r
else
endif
set cmdheight=1
set scrolloff=3
set cursorline
set ruler
set showcmd
set showmode
set laststatus=2
set wrap
set incsearch
set hlsearch
set visualbell
set linebreak

"==========================================
" Key (re)mappings
"==========================================

let mapleader = ','

map Q <Nop>
map K <Nop>

command! W w
command! Q q
command! Qall qall

nnoremap Y y$

nmap k gk
nmap j gj

map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>

map <up> <C-W>+
map <down> <C-W>-
map <left> 3<C-W>>
map <right> 3<C-W><

map <return> :nohlsearch<cr>

map <leader><leader> <C-^>

"a
map <leader>ac :Unite -no-split grep:.<cr>
map <leader>ao :Unite -no-split -start-insert outline<cr>
map <leader>ab :Unite -no-split -quick-match buffer<cr>
map <leader>ar :Unite -no-split -start-insert file_mru<cr>
map <leader>aa maggVG"*y`a
vmap <leader>a :Tabularize /
"b
map <leader>b :call ToggleBackgroundColor()<cr>
map <leader>bi :source $MYVIMRC<cr>:nohlsearch<cr>:BundleInstall<cr>
map <leader>bu :source $MYVIMRC<cr>:nohlsearch<cr>:BundleUpdate<cr>
map <leader>bc :source $MYVIMRC<cr>:nohlsearch<cr>:BundleClean!<cr>
map <leader>bb :source $MYVIMRC<cr>:nohlsearch<cr>:BundleClean!<cr>:BundleUpdate<cr>:BundleInstall<cr>
"c
" comment closing HTML tag
map <leader>ct my^lyy%p/classf"v0c.f"D:s/ /./eg<cr>gcckJ:nohlsearch<cr>`y
map <leader>cc :CtrlPClearAllCache<cr>
"d
" delete wrapping HTML tag
map <leader>dt ^lma%mb'ajV'bk<'add'bdd
map <leader>do ma^/do<cr>ciw{<esc>lxJJ$ciw}<esc>`a
"e
map <leader>ea :tabnew ~/dropbox/code/toolsharpeninglist.md<cr>
map <leader>ee :tabnew ~/dropbox/code/vimcheatsheet.md<cr>
map <leader>ev :tabnew $MYVIMRC<cr>
map <leader>es :UltiSnipsEdit<cr>
"f
map <leader>f :Unite -no-split -start-insert file_rec/async<cr>
"g
map <leader>gg :topleft 20 :split Gemfile<cr>
map <leader>gr :topleft 20 :split config/routes.rb<cr>
map <leader>gv :CtrlPClearCache<cr>:CtrlP app/views<cr>
map <leader>gc :CtrlPClearCache<cr>:CtrlP app/controllers<cr>
map <leader>gm :CtrlPClearCache<cr>:CtrlP app/models<cr>
map <leader>ga :CtrlPClearCache<cr>:CtrlP app/assets<cr>
map <leader>gs :CtrlPClearCache<cr>:CtrlP specs<cr>
"h
map <leader>hh :call ToggleHardMode()<cr>
map <leader>ha <esc>:call ToggleHardMode()<CR>
"i
"j
"k
"l
"m
map <leader>mh yypVr=k
map <leader>m2h yypVr-k
vmap <leader>mlc ^:s/(\*/ */g<cr>gv:s/ \*)//g<cr>A *)<esc>gvo<esc>r(gvo<esc>:nohlsearch<cr>
"n
"o
map <leader>o :only<cr>
"p
map <leader>p <esc>o<esc>"*]p
"q
map <leader>q :q<cr>
map <leader>Q :qall<cr>
"r
map <leader>rn :call RenameFile()<cr>
map <leader>re :%s/\r\(\n\)/\1/eg<cr>:retab<cr>:%s/\s\+$//e<cr>
map <leader>rt :!ctags -R --exclude=.svn --exclude=.git --exclude=log --exclude=tmp --exclude=vendor *<cr>:CtrlPTag<cr>
"s
map <leader>s :source $MYVIMRC<cr>:nohlsearch<cr>
map <leader>sw :Switch<cr>
"t
map <leader>t :call RunCurrentTests()<cr>
map <leader>T :call RunCurrentFile()<cr>
"u
"v
"w
map <leader>w :w<cr>
map <leader>W :wq<cr>
"x
map <leader>x :set filetype=
"y
map <leader>y "*y
"z
map <leader>z :call CorrectSpelling()<cr>

"==========================================
" Plugin configs
"==========================================
let g:UltiSnipsEditSplit = 'horizontal'
let g:UltiSnipsSnippetDirectories = ["snippets"]

let g:switch_custom_definitions =
    \ [
    \   ['white', 'black'],
    \   ['right', 'left'],
    \   ['top', 'bottom'],
    \   ['red', 'blue'],
    \   ['width', 'height'],
    \   ['min', 'max'],
    \   ['require', 'require_relative'],
    \   ['margin', 'padding'],
    \   ['foo', 'bar', 'baz'],
    \   ['block', 'inline-block', 'inline']
    \ ]

autocmd FileType sml set commentstring=(*\ %s\ *)

highlight link hspecDescribe Type
highlight link hspecIt Identifier
highlight link hspecDescription String

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

highlight clear SignColumn

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
  \ 'ignore_pattern', join([
  \ '\.git/',
  \ '\.sass-cache/',
  \ '\vendor/',
  \ ], '\|'))

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  let b:SuperTabDisabled=1

  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)

  imap <silent><buffer><expr> <C-s> unite#do_action('split')
  imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

  nmap <buffer> <ESC> <Plug>(unite_exit)
endfunction

"==========================================
" Abbreviation
"==========================================

" When typing %% expand it into the path to the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>

cabbrev gs Gstatus
cabbrev ga Gwrite
cabbrev gc Gcommit


"==========================================
" Functions
"==========================================

" Rename the current file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction

function! CorrectSpelling()
  set spell
  normal 1z=
  set nospell
endfunction

" Toggle background color
function! ToggleBackgroundColor()
  if &background == 'dark'
    set background=light
  else
    set background=dark
  endif
endfunction

function! RunCurrentFile()
  write

  if FilenameIncludes("\.rb")
    call RunCommand("ruby", PathToCurrentFile())
  elseif FilenameIncludes("\.sml")
    call RunCommand("rlwrap mosml -P full", PathToCurrentFile())
  elseif FilenameIncludes("\.js")
    call RunCommand("node", PathToCurrentFile())
  elseif FilenameIncludes("\.sh")
    call RunCommand("sh", PathToCurrentFile())
  elseif FilenameIncludes("\.py")
    call RunCommand("python", PathToCurrentFile())
  elseif FilenameIncludes("\.hs")
    call RunCommand("ghci", PathToCurrentFile())
  elseif FilenameIncludes("\.coffee")
    call RunCommand("run_coffeescript", PathToCurrentFile())
  else
    echo "Dunno how to run such a file..."
  endif
endfunction

function! RunCurrentTests()
  write

  if FilenameIncludes("\.rb")
    if InRailsApp()
      echo "Haven't setup how to run tests in a rails app"
    else
      if FilenameIncludes("_spec")
        let g:dgp_test_file = PathToCurrentFile()
        call RunCommand("rspec", g:dgp_test_file)
      elseif exists("g:dgp_test_file")
        call RunCommand("rspec", g:dgp_test_file)
      else
        call RunCommand("rspec", PathToCurrentFile())
      endif
    endif
  elseif FilenameIncludes("\.sml")
    call RunCommand("run_sml_tests", PathToCurrentFile())
  elseif FilenameIncludes("\.js")
    call RunCommand("karma run", "")
  elseif FilenameIncludes("\.coffee")
    call RunCommand("karma run", "")
  elseif FilenameIncludes("\.hs")
    call RunCommand("runhaskell", PathToCurrentFile() . " -f progress")
  else
    echo "Dunno how to test such a file..."
  endif
endfunction

function! RunCommand(cmd, args)
  let command = 'clear; ' . a:cmd . " " . a:args

  if InTmux() && NumberOfTmuxPanes() > 1
    let command = 'Tmux ' . command
  else
    let command = '!' . command
  endif

  exec command
endfunction

function! PathToCurrentFile()
  return expand('%:p')
endfunction

function! InTmux()
  silent exec '!in_tmux'
  exec "redraw!"

  if v:shell_error
    return 0
  else
    return 1
  endif
endfunction

function! NumberOfTmuxPanes()
  return system('number_of_tmux_panes')
endfunction

function! InRailsApp()
  return filereadable("app/controllers/application_controller.rb")
endfunction

function! FilenameIncludes(pattern)
  return match(expand('%:p'), a:pattern) != -1
endfunction
