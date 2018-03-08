" .vimrc
" nick@dischord.org

" {{{ Plugins
silent! call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-vinegar'
Plug 'machakann/vim-sandwich'
Plug 'w0rp/ale', { 'for': ['puppet','go','yaml','python','ruby'] }
Plug 'godlygeek/tabular'
Plug 'cespare/vim-sbd'
Plug 'christoomey/vim-tmux-navigator'
Plug 'stephpy/vim-yaml', { 'for': ['yaml'] }
Plug 'pearofducks/ansible-vim', { 'branch': 'v2', 'for': ['yaml.ansible'] }
Plug 'fatih/vim-go', { 'for': ['go'] }
Plug 'rodjek/vim-puppet', { 'for': ['puppet'] }
Plug 'rking/ag.vim'
Plug 'justinmk/vim-dirvish'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'jszakmeister/vim-togglecursor'
Plug 'skywind3000/asyncrun.vim'
Plug 'chriskempson/base16-vim'
Plug 'yankcrime/vim-colors-off'
Plug 'sjl/badwolf'
Plug 'robertmeta/nofrils'
Plug 'itchyny/lightline.vim'

call plug#end()

" }}} end vim-plug
" {{{ General

set nobackup " Irrelevant these days
let mapleader = "\<Space>" " Define leader key
set noswapfile

set breakindent " indent wrapped lines, by...
set breakindentopt=shift:4,sbr " indenting them another level and showing 'showbreak' char
set showbreak=↪
set number
set noshowmode

set pastetoggle=<F2> " Quickly enable paste mode
set hidden " Don't moan about changes when switching buffers
set matchpairs=(:),{:},[:],<:> " Add <> to % matching

" Emoji completion with CTRL-X CTRL-U
set completefunc=emoji#complete

set modelines=5 " Enable modelines

" set cursorline

set cpo=aABceFs$

set smarttab
set ttyfast

nnoremap <leader>l :set list!<CR>
set listchars=tab:▸\ ,eol:¬,trail:-,
set fillchars+=vert:\│

set backupdir=/tmp//,.
set directory=/tmp//,.

set hlsearch
set incsearch
set ignorecase

set wildmenu

filetype plugin on
set ai

vmap Q gq
nnoremap Q gqap

" Clear search
nnoremap <silent> ,/ :noh<cr>

au BufEnter *.sh if getline(1) == "" | :call setline(1, "#!/usr/bin/env bash") | endif
au BufEnter *.py if getline(1) == "" | :call setline(1, "#!/usr/bin/env python") | endif
au BufEnter *.rb if getline(1) == "" | :call setline(1, "#!/usr/bin/env ruby") | endif

autocmd BufRead ~/.mutt/tmp/*      :source ~/.mutt/mail.vim

set tags=./tags; " Tell vim to look upwards in the directory hierarchy for a tags file until it finds one

" Make vim deal with scoped identifiers instead of just hitting top-level
" modules when using ctags with Puppet code
set iskeyword=-,:,@,48-57,_,192-255
au FileType puppet setlocal isk+=:

cmap w!! w !sudo tee % >/dev/null

" appearance
set t_Co=256
" set termguicolors
colorscheme goodwolf
hi Normal gui=NONE guifg=NONE guibg=NONE ctermfg=none ctermbg=none
hi Statusline cterm=bold ctermbg=237 ctermfg=231 gui=bold
hi StatuslineTerm cterm=bold ctermbg=237 ctermfg=231 gui=bold
hi StatuslineTermNC term=reverse ctermfg=243 ctermbg=236 guifg=#767676 guibg=#303030
hi clear SignColumn
set laststatus=2
set statusline=\ %t\ %m%r%h%w%=\ %{&ft}\ %{&ff}\ %{&fenc}\ %l,%v\ -\ %L\ |

" insert a datestamp at the top of a file
nnoremap <leader>N ggi# <C-R>=strftime("%Y-%m-%d - %A")<CR><CR><CR>

" fugitive shortcuts
noremap <leader>ga :Gwrite<CR>
noremap <leader>gc :Gcommit<CR>
noremap <leader>gp :Gpush<CR>
noremap <leader>gs :Gstatus<CR>

" convenience remap - one less key to press
nnoremap ; :

" juggling with quickfix entries
nnoremap <End>  :cnext<CR>
nnoremap <Home> :cprevious<CR>

" juggling with buffers
nnoremap <PageUp>   :bprevious<CR>
nnoremap <PageDown> :bnext<CR>
nnoremap <BS>       :buffer#<CR>

" super quick search and replace
nnoremap <Space><Space> :'{,'}s/\<<C-r>=expand("<cword>")<CR>\>/
nnoremap <Space>%       :%s/\<<C-r>=expand("<cword>")<CR>\>/

" terminal stuff
tnoremap <leader><Esc> <C-W>N

" do some sensible things with listings
cnoremap <expr> <CR> <SID>CCR()
function! s:CCR()
	command! -bar Z silent set more|delcommand Z
	if getcmdtype() == ":"
		let cmdline = getcmdline()
		    if cmdline =~ '\v\C^(dli|il)' | return "\<CR>:" . cmdline[0] . "jump   " . split(cmdline, " ")[1] . "\<S-Left>\<Left>\<Left>"
		elseif cmdline =~ '\v\C^(cli|lli)' | return "\<CR>:silent " . repeat(cmdline[0], 2) . "\<Space>"
		elseif cmdline =~ '\C^changes' | set nomore | return "\<CR>:Z|norm! g;\<S-Left>"
		elseif cmdline =~ '\C^ju' | set nomore | return "\<CR>:Z|norm! \<C-o>\<S-Left>"
		elseif cmdline =~ '\v\C(#|nu|num|numb|numbe|number)$' | return "\<CR>:"
		elseif cmdline =~ '\C^ol' | set nomore | return "\<CR>:Z|e #<"
		elseif cmdline =~ '\v\C^(ls|files|buffers)' | return "\<CR>:b"
		elseif cmdline =~ '\C^marks' | return "\<CR>:norm! `"
		elseif cmdline =~ '\C^undol' | return "\<CR>:u "
		else | return "\<CR>" | endif
	else | return "\<CR>" | endif
endfunction

" }}} End basic settings
" {{{ Lightline
" Lightline
let g:lightline = {
\ 'colorscheme': 'wombat',
\ 'active': {
\   'left': [['mode', 'paste'], ['filename', 'modified'], ['filetype']],
\   'right': [['lineinfo'], ['percent'], ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok'], ['gitbranch']]
\ },
\ 'component_function': {
\   'gitbranch': 'fugitive#head'
\ },
\ 'component_expand': {
\   'linter_warnings': 'LightlineLinterWarnings',
\   'linter_errors': 'LightlineLinterErrors',
\   'linter_ok': 'LightlineLinterOK'
\ },
\ 'component_type': {
\   'readonly': 'error',
\   'linter_warnings': 'warning',
\   'linter_errors': 'error'
\ },
\ 'mode_map': {
\ 'n': 'N',
\ 'i': 'I',
\ 'r': 'R',
\ 'V': 'V',
\ 'v': 'V-L',
\ "\<C-v>": 'V-B',
\ "c": 'C',
\ "s": 'S',
\ "S": 'S-L',
\ "\<C-s>": 'S-B',
\ "t": 'T',
\ }
\ }

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction

autocmd User ALELint call s:MaybeUpdateLightline()

" Update and show lightline but only if it's visible (e.g., not in Goyo)
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction
let g:lightline.subseparator = { 'left': '', 'right': '' }
" }}}
" {{{ Folding
augroup ft_vim
    au!
    au FileType vim setlocal foldmethod=marker keywordprg=:help
    au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END

augroup ft_ruby
    au!
    au Filetype ruby setlocal foldmethod=syntax
    au BufRead,BufNewFile Capfile setlocal filetype=ruby
augroup END

augroup ft_puppet
    au!
    au Filetype puppet setlocal foldmethod=marker
    au Filetype puppet setlocal foldmarker={,}
augroup END

augroup ft_muttrc
    au!
    au BufRead,BufNewFile *.muttrc set ft=muttrc
    au FileType muttrc setlocal foldmethod=marker foldmarker={{{,}}}
augroup END
" }}}
" {{{ Neovim
if has('nvim')
    nnoremap <BS> <C-w>h
"    tnoremap <C-h> <C-\><C-N><C-w>h
"    tnoremap <C-j> <C-\><C-N><C-w>j
"    tnoremap <C-k> <C-\><C-N><C-w>k
"    tnoremap <C-l> <C-\><C-N><C-w>l
    tnoremap <leader><esc> <C-\><C-n>
    au TermOpen * setlocal nonumber norelativenumber
    let g:terminal_scrollback_buffer_size = 10000
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
    set inccommand=nosplit
    command! -nargs=* T split | terminal <args>
    command! -nargs=* VT vsplit | terminal <args>
    nnoremap <leader>t :T<cr>
end
" }}}
" {{{ FZF
" Hide statusline
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

nnoremap <silent> <C-f> :Files <CR>
nnoremap <silent> <C-b> :Buffers <CR>
nnoremap <silent> <C-t> :call fzf#vim#tags(expand('<cword>'))<cr>

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }

let g:fzf_buffers_jump = 1
let g:fzf_tags_command = 'ctags -R'

" Workaround for https://github.com/junegunn/fzf/issues/809
let $FZF_DEFAULT_OPTS .= ' --no-height'

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

autocmd! User FzfStatusLine call <SID>fzf_statusline()

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" }}}
" {{{ Golang
au FileType go nnoremap <leader>r <Plug>(go-run)
au FileType go nnoremap <leader>b <Plug>(go-build)
au FileType go nnoremap <leader>t <Plug>(go-test)
au FileType go nnoremap <leader>c <Plug>(go-coverage)
au FileType go nnoremap <Leader>rv <Plug>(go-run-vertical)
au FileType go nnoremap <Leader>gd <Plug>(go-doc)
au FileType go nnoremap <Leader>gv <Plug>(go-doc-vertical)
au BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4
let g:go_term_enabled = 1
let g:go_term_mode = "split"
" }}}
" {{{ Ansible
" Fix annoying and often wrong reindentation
set indentkeys-=<:>
let g:ansible_yamlKeyName = 'yamlKey'
" }}}
" {{{ SBD (Smart Buffer Delete)
nnoremap <silent> <C-x> :Sbd<CR>
nnoremap <silent> <leader>bdm :Sbdm<CR>
" }}}
" {{{ Markdown
nnoremap <leader>m :silent !open -a Marked.app '%:p'<cr>
" }}}
" {{{ Silver Searcher (Ag)
function! AGSearch() abort
    call inputsave()
    let searchterm = input('Search string: ')
    call inputrestore()
    execute 'Ag' searchterm
endfunction
nnoremap <C-s> :call AGSearch()<cr>
" }}}
" {{{ Ctags
" Workaround explicitly top-scoped Puppet classes / identifiers, i.e those
" prefixed with '::' which don't match to a file directly when used in
" conjunction with ctags
au FileType puppet nnoremap <c-]> :exe "tag " . substitute(expand("<cword>"), "^::", "", "")<CR>
au FileType puppet nnoremap <c-w><c-]> :tab split<CR>:exe "tag " . substitute(expand("<cword>"), "^::", "", "")<CR>
" }}}
" {{{ Asyncrun
nnoremap <leader>ar :AsyncRun 
noremap <leader>arqf :call asyncrun#quickfix_toggle(8)<cr>
" }}}
" {{{ ALE
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_sign_warning='●'
hi ALEErrorSign ctermfg=red ctermbg=none
let g:ale_sign_error='●'
hi ALEWarningSign ctermfg=yellow ctermbg=none
" }}}
" {{{ GUI overrides
if has('gui_running')
    set linespace=2
    set fuoptions=maxvert,maxhorz
    set background=light
    set guifont=Triplicate\ T4c:h14
    colorscheme off
    hi Statusline cterm=bold ctermbg=237 ctermfg=231 gui=bold
    hi StatuslineTerm cterm=bold ctermbg=237 ctermfg=231 gui=bold
    hi StatuslineTermNC term=reverse ctermfg=243 ctermbg=236 guifg=#767676 guibg=#303030
    set guioptions=e " don't use gui tab apperance
    set guioptions=T " hide toolbar
    set guioptions=r " don't show scrollbars
    set guioptions=l " don't show scrollbars
    set guioptions=R " don't show scrollbars
    set guioptions-=L " don't show scrollbars
    set gtl=%t gtt=%F " tab headings
end
" }}}
" {{{ Statusline
let g:look_up = {
    \ '__' : '-', 'n'  : 'N',
    \ 'i'  : 'I', 'R'  : 'R',
    \ 'v'  : 'V', 'V'  : 'V',
    \ 'c'  : 'C', '' : 'V',
    \ 's'  : 'S', '' : 'S',
    \ '^S' : 'S', 't'  : 'T',
\}

" set statusline=
" set statusline+=%(\ %{g:look_up[mode()]}%)
" set statusline+=%(%{&paste?'\ p\ ':''}%)
" set statusline+=%(\ ⎇\ \ %{fugitive#head()}%)
" set statusline+=%(\ %<%F%)
" set statusline+=\ %h%m%r%w
" set statusline+=%=
" set statusline+=%(%<\☰\ \ %l/%L:%c\ %)

" }}}

" vim:ts=4:sw=4:ft=vimrc:et
