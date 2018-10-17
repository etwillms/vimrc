call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'joshdick/onedark.vim'
Plug 'benmills/vimux'
Plug 'mattn/emmet-vim'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'burntsushi/ripgrep'
Plug 'tpope/vim-commentary'
call plug#end()

" Swap files
set directory^=$HOME/.vim/tmp//

" Leaders
let mapleader = "\<Space>"
map <Leader>s :w<CR>
map <Leader>b :Buffers<CR>
map <Leader>f :Files<CR>
map <Leader>c :bd<CR>

" tags
command! MakeTags !ctags -R
au BufWritePost *.c,*.cpp,*.h silent! !ctags -R &

" bind \ to grep shortcut
"command -nargs=+ -complete=file -bar Ag silent! grep <args>|cwindow|redraw!
"nnoremap \ :Ag<SPACE>

" let g:vimux_ruby_clear_console_on_run = 1
map <Leader>rt :call VimuxRunCommand("clear; docker-compose run web rspec")<CR>

" Vimux 
let g:VimuxOrientation = "h"
let g:VimuxHeight = "40"
map <Leader>rb :call VimuxRunCommand("clear; docker-compose run web rspec " . bufname("%"))<CR>
map <Leader>vq :VimuxCloseRunner<CR>

" --column: Show column number
"  " --line-number: Show line number
"  " --no-heading: Do not show file headings in results
"  " --fixed-strings: Search term as a literal string
"  " --ignore-case: Case insensitive search
"  " --no-ignore: Do not respect .gitignore, etc...
"  " --hidden: Search hidden files and folders
"  " --follow: Follow symlinks
"  " --glob: Additional conditions for search (in this case ignore everything
"  in the .git/ folder)
"  " --color: Search color options

command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
nmap \ :Find<Space>
"command! -nargs=* Docker execute 'docker-compose run web '.shellescape(<q-args>)


" NERDTree
map <Leader>t :NERDTreeToggle<CR>

set path+=**
set wildmenu
set nu
set hidden
set nowrap
set noet ci pi sts=0 sw=2 ts=2
inoremap jj <Esc>
nmap oo o<Esc>k
nmap OO O<Esc>j
nmap <Leader>i i<CR><Esc>O
nmap <Leader>a a<CR><Esc>O
set timeoutlen=1000 ttimeoutlen=0

syntax on
colorscheme onedark

"Docker shortcuts
if (exists('g:loaded_docker') && g:loaded_docker) || v:version < 700 || &cp
	finish
endif
let g:loaded_docker = 1

function! s:Docker(bang, args)
	let cmd = 'docker ' . a:args
	execute ':!' . cmd
endfunction
command! -bar -bang -nargs=* Docker call s:Docker(<bang>0,<q-args>)

function! s:Denv(bang, env)
	let cmd = 'eval $(docker-machine env ' . a:env . ')'
	execute ':!' . cmd
endfunction
command! -bar -bang -nargs=1 Denv call s:Denv(<bang>0,<q-args>)

function! s:Dmachine(bang, args)
	let cmd = 'docker-machine ' . a:args
	execute ':!' . cmd
endfunction
command! -bar -bang -nargs=* Dmachine call s:Dmachine(<bang>0,<q-args>)

function! s:Dcompose(bang, args)
	let cmd = 'docker-compose ' . a:args
	execute ':!' . cmd
endfunction
command! -bar -bang -nargs=* Dcompose call s:Dcompose(<bang>0,<q-args>)
nmap <Leader>d :Dcompose 

" :source %
":PlugInstall
