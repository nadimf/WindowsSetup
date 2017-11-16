set nocompatible  " don't need vi compatibility
set number        " enable line numbering
source $VIMRUNTIME/vimrc_example.vim
"source $VIMRUNTIME/mswin.vim
"behave mswin
"set nocp
"if has('win32')
"	set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
"endif

"Enable filetype plugin
filetype plugin on

"Execute Pathogen plugin manager
execute pathogen#infect()
filetype plugin indent on
syntax on

set noswapfile

"Set color scheme. Color schemes are located ~/.vim/colors
syntax enable
colorscheme solarized
set background=dark
set t_Co=256

"Enable Mouse
set mouse=a

"Map leader
:let mapleader = "-"

"Local leader
:let maplocalleader = "\\"

"Quickly edit .vimrc
:nnoremap <leader>ev :vsplit $MYVIMRC<cr>
:nnoremap <leader>so :so $MYVIMRC<CR>

"Have VIM create file as soon as you edit them
:autocmd BufNewFile * :write


"Shortcut to comment line in code
:autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
:autocmd FileType python nnoremap <buffer> <localleader>c I#<esc>
:autocmd FileType c++ nnoremap <buffer> <localleader>c I//<esc>


"If Statement
:autocmd FileType c++ :iabbrev <buffer> lll if ()<left>
:autocmd FileType python :iabbrev <buffer> lll if:<left>

set hidden " no hidden buffers
set shiftwidth=4
set tabstop=4
set expandtab
set textwidth=80

" Python PEP8 indentation
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix
	\ set encoding=utf-8
	
" Full Stack indentation
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2
	
	
let python_highlight_all=1
syntax on	
	

":au BufRead *.cpp,*.h,*.mak   let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)     " max of 80 chars per line in source
":au BufRead *.cpp,*.h,*.mak,*.cfg   let w:m1=matchadd('ErrorMsg', '\t', -1)         " highlight tabs in source
":au BufRead,BufWinEnter *           let w:m3=matchadd('SDRD', "SDRD_[0-9]*", -1)  " highlight SDRD tags EVERYWHERE
":au BufRead,BufWinEnter *           let w:m3=matchadd('SRD', "SRD_[0-9]*", -1)  " highlight SDRD tags EVERYWHERE
":au BufRead,BufWinEnter *           let w:m3=matchadd('TC', "TC_[0-9]*", -1)  " highlight SDRD tags EVERYWHERE


syn include @AWKScript syntax/awk.vim
syn region AWKScriptEmbedded matchgroup=AWKCommand
    \ start=+\<g\?awk\>+ skip=+\\$+ end=+[=\\]\@<!'+me=e-1
    \ contains=@shIdList,@shExprList2 nextgroup=AWKScriptCode
syn region AWKScriptEmbedded matchgroup=AWKCommand
    \ start=+\$AWK\>+ skip=+\\$+ end=+[=\\]\@<!'+me=e-1
    \ contains=@shIdList,@shExprList2 containedin=shDerefSimple nextgroup=AWKScriptCode
syn cluster shCommandSubList add=AWKScriptEmbedded
hi def link AWKCommand Type


"silent execute '!mkdir _swp'
"set backupdir=./_swp


map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
"Cut from prev line:--c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" Look for SDRD tags in file, open location list
function FindTracing()
  silent lvimgrep "SDRD_[0-9]*" %
  let numTraces = len(getloclist(0)) + 1
  silent execute "lwin ".numTraces
endfunction

" Map find SDRD tracing to F2
nnoremap <silent> <F2> :call FindTracing()<CR>
nnoremap <silent> <F3> :call FindTracing()<CR>ggVGy:15vnew<CR>pggdd:%s/.*\(SDRD_[0-9]*\).*/\1/g<CR>:sort u<CR>/asd<CR>:set buftype=nofile<CR>

function BuildAll()
   silent execute "ConqueTermTab __Build_Release_EVB_Changed.bat"
   silent execute "ConqueTermVSplit __Build_Release_Integ_Changed.bat"
   silent execute "ConqueTermVSplit __Build_Release_LRU_Changed.bat"
endfunction

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

" Vertical split open the .cpp for the .h file, or the .h for the .cpp 
map <F4> :vsplit %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
"map <F5> :call BuildAll()
map <F5> :TlistUpdate<CR> 
":TlistHighlightTag<CR>

"Update path for each project.
map <F9> :! "C:\\Documents and Settings\\E837673\\E837673_NEXTBLD\\Epic_EGPWF\\Software\\EGPWF\\EgpwfMakeRelease.bat"<CR>

"set statusline=%<%f\ [%{Tlist_Get_Tagname_By_Line()}]\ %h%m%r%=%-14.(%l,%c%V%)\ %P

"set statusline=%<%f [%{Tlist_Get_Tagname_By_Line()}] %h%m%r%=%-14.(%l,%c%V%) %P

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_ine
  if arg1 =~ ' ' | let arg1 = '\"' . arg1 . '\"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '\"' . arg2 . '\"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '\"' . arg3 . '\"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '\"' . $VIMRUNTIME . '\diff\"'
      let eq = '\"\"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '\" ', '') . '\diff\"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction


"CSCOPE
function LoadCscope()
	if (executable("cscope") && has("cscope"))
		let UpperPath = findfile("cscope.out", ".;")
		if (!empty(UpperPath))
			let path = strpart(UpperPath, 0, match(UpperPath, "cscope.out$") - 1)	
			if (!empty(path))
				let s:CurrentDir = getcwd()
				let direct = strpart(s:CurrentDir, 0, 2) 
				let s:FullPath = direct . path
				let s:AFullPath = globpath(s:FullPath, "cscope.out")
				let s:CscopeAddString = "cs add " . s:AFullPath . " " . s:FullPath 
				execute s:CscopeAddString 
			endif
		endif
	endif
endfunction
command LoadCscope call LoadCscope()
" cs add $CSCOPE_DB

"Launch NERDTree at startup.
autocmd VimEnter * NERDTree

"Start ctrlp file searcher
set runtimepath^=~/.vim/bundle/ctrlp.vim
set runtimepath^=~/.vim/bundle/ag

"Snippets
"Test Analysis
function! TestAnalysis()
   r C:/Cygwin64/home/.vim/snippets/TestAnalysis.txt
endfunction

nmap <leader>ta :call TestAnalysis()<CR>

" Set omniC++ to include
set tags+=~/.vim/tags/
set nocp
let OmniCpp_GlobalScopeSearch = 2
let OmniCpp_NamespaceSearch = 2
let OmniCpp_DisplayMode = 1

map <leader>p :CtrlPTag<cr>
