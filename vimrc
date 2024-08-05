" disable bells
autocmd! GUIEnter * set vb t_vb=
" don't be vi-compatible
set nocompatible

" Mouse & Clipboard
set mouse=a "i dare you to call me lazy
set clipboard^=unnamed,unnamedplus "use system clipboard (cross-platform)

vmap <C-C> "+y

" Show autocomplete menus. Make it work like bash completion.
set wildmenu
set wildmode=list:longest

" fzf config - use neovim's floating window feature
let $FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_layout = { 'window': 'call FloatingFZF()' }
function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  let height = float2nr(&lines * 0.9)
  let width = float2nr(&columns * 0.9)
  let horizontal = float2nr((&columns - width) / 2)
  let vertical = 1
  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height
        \ }
  call nvim_open_win(buf, v:true, opts)
endfunction

" Easier split pane navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" show hidden characters
set listchars=tab:▸\ ,eol:¬,space:.,trail:\!
set list!

" download vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

filetype off
call plug#begin()
"UI/Themes
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'mhinz/vim-startify'
Plug 'machakann/vim-highlightedyank'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'christoomey/vim-tmux-navigator'
"Files/Git/Search
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'danro/rename.vim'
"Linting/Normalizing
Plug 'w0rp/ale'
Plug 'editorconfig/editorconfig-vim'
"Languages/Syntax
Plug 'LnL7/vim-nix'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-markdown'
Plug 'mzlogin/vim-markdown-toc'
Plug 'cnlinbo/markdown-preview.nvim', { 'branch': 'linbo', 'do': 'cd app && yarn install' }
Plug 'rust-lang/rust.vim'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'neoclide/coc.nvim', { 'branch': 'master', 'do': 'yarn install --frozen-lockfile' }
call plug#end()
filetype plugin indent on

syntax enable
set background=dark

nnoremap <C-p> :Files<Cr>
map <C-\> :NERDTreeToggle<CR>

if executable('rg')
  set grepprg=rg\ --color=never\ --vimgrep
  let g:rg_command = '
    \ rg --column --line-number --no-heading --fixed-strings --smart-case --hidden --follow --color "always"
    \ -g "*.{sql,R,rs,java,jbuilder,js,jsx,json,php,ctp,css,scss,md,styl,jade,html,config,py,cpp,c,go,hs,rb,erb,conf}"
    \ -g "!{.git,node_modules,vendor}/*" '
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"Use 24-bit (true-color) mode in Vim/Neovim (requires tmux 2.2 or later!)
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

colorscheme onedark

set laststatus=2
let g:airline_theme='onedark'
let g:airline_powerline_fonts = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]' " hide the type if it's expected
let g:airline#extensions#hunks#enabled=0
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#ale#enabled = 1
let g:ale_ruby_rubocop_executable = 'bundle'

" highlight yanked but for less time
let g:highlightedyank_highlight_duration = 300

" trip trailing whitespace EXCEPT for markdown files
fun! StripTrailingWhitespace()
    " Only strip if the b:noStripeWhitespace variable isn't set
    if exists('b:noStripWhitespace')
        return
    endif
    %s/\s\+$//e
endfun
autocmd BufWritePre * call StripTrailingWhitespace()
autocmd FileType markdown let b:noStripWhitespace=1

" RUBY
let ruby_no_expensive=1

" RUST
let g:rustfmt_autosave = 1

set updatetime=100
set timeoutlen=1000 ttimeoutlen=10
set autoindent
set expandtab
set autoread
set autowrite
set backspace=indent,eol,start
set encoding=utf8
set fileformats=unix,dos,mac
set ignorecase
set incsearch
set infercase
set laststatus=2
set linebreak
set number
set signcolumn=yes "keep gutter expanded
set wildignore+=*/.git/*,*/tmp/*,*.swp
set nowrap
set ve+=onemore "put cursor at end of line

" faster drawing
set lazyredraw
set ttyfast

autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType html setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType typescript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" Spell-check Markdown files and Git Commit Messages
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell
