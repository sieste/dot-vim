"indenting
set sts=2
set shiftwidth=2
set noautoindent
set nocindent

" spaces
set nojoinspaces

" longer history
set history=1000

" display partial search match while typing
set incsearch

" regenerate syntax highlighting by control-l (which normally just redraws the screen
nnoremap <silent> <c-l> <c-l>:syn sync fromstart<cr>
inoremap <silent> <c-l> <esc><c-l>:syn sync fromstart<cr>i

"break lines without inserting newline character
set nolinebreak
set wrap

"splitting scheme, horz. split, maximized
set winminheight=0
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
autocmd BufEnter * resize

"colors
if has('gui_running')
  colorscheme default
  set background=light
else
  colorscheme ron 
endif

" gui options (no menu bar, no toolbar, no right scrollbar)
set guioptions-=m
set guioptions-=T
set guioptions-=r

"enable syntax highlighting
if !(exists('syntax_on'))
    syntax on
endif

"tab completion
set wildmode=list:full

" allow backspace to delete everything
set backspace=indent,eol,start

" status line
highlight StatusLine ctermbg=black ctermfg=red 

"enable mouse usage
set mouse=a

"search settings
set ignorecase
set smartcase
" map control l from "redraw" to "clear search pattern and redraw" 
noremap <silent> <C-l> :nohlsearch<enter><C-l>

"use space bar to :
noremap <Space> :

"map jk to escape in insert mode
inoremap jk <esc>
inoremap <esc> <nop>

"spell
set spelllang=en,de

"make command line 1 line high
set cmdheight=1

"keep cursor 5 lines above/below margins
set scrolloff=5

" put selection into braces
" opening bracket for abc -> (abc)
" closing bracket for abc ->
" (
" abc
" )
vnoremap <leader>{ <esc>`>a}<esc>`<i{<esc>
vnoremap <leader>} <esc>`>o}<esc>`<O{<esc>
vnoremap <leader>( <esc>`>a)<esc>`<i(<esc>
vnoremap <leader>) <esc>`>o)<esc>`<O(<esc>
vnoremap <leader>[ <esc>`>a]<esc>`<i[<esc>
vnoremap <leader>] <esc>`>o]<esc>`<O[<esc>
vnoremap <leader>$ <esc>`>a$<esc>`<i$<esc>
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>

" operator: inside $ ... $
onoremap i$ :<c-u>normal! F$lvt$<cr>

" copy and paste using system clipboard
nnoremap <leader>y "*yy
vnoremap <leader>y "*y
nnoremap <leader>p "*p
vnoremap <leader>p "*p


"pdflatex shortcuts
autocmd BufEnter *.tex noremap + :w<enter>:!pdflatex %<.tex<enter><enter>

"latex shortcuts
autocmd BufEnter *.tex noremap - :w<enter>:!latex %<.tex & dvipdf %<.dvi<enter><enter>
autocmd BufEnter *.tex nnoremap <leader>end <esc>yyp0lcwend<esc>O

" map \PDF to open "current filname".pdf in evince
nnoremap <silent> <leader>PDF :!evince %<.pdf & <cr><cr>
" map \o to open file under cursor in evince
:nnoremap \o "ayiW:!evince <C-r>a &<cr><cr>

" R markdown specific
" use custom Rmd syntax highlighting (see ~/.vim/syntax/rmd.vim)
autocmd BufNewFile,BufRead,BufEnter *.Rmd,*.rmd set syntax=rmd
" map + key to knit file and convert markdown to pdf with pandoc
autocmd BufNewFile,BufRead,BufEnter *.Rmd,*.rmd nnoremap + :w<cr>:!Rscript -e 'knitr::knit("%")'<cr>:!pandoc %<.md -o %<.pdf --highlight-style=tango -V geometry:margin=2cm -V fontsize=12pt<cr><cr>
autocmd BufNewFile,BufRead,BufEnter *.Rmd,*.rmd nnoremap <silent> <leader>+ :w<cr>:!Rscript -e 'knitr::purl("%")'<cr>:sp %<.R<cr>:setlocal autoread<cr>:set readonly<cr>


" R specific
" map + key to save and Rscript current file
autocmd BufNewFile,BufRead,BufEnter *.R,*.r nnoremap + :w<cr>:!Rscript %<cr>
" map = key to turn "a=b" into "a = b"
autocmd BufNewFile,BufRead,BufEnter *.R,*.r,*.Rmd,*.rmd nnoremap = s<space><space><esc>P


"markdown to pdf by pandoc
autocmd BufNewFile,BufRead,BufEnter *.md set filetype=markdown
autocmd BufNewFile,BufRead,BufEnter *.md nnoremap + :w<enter>:!pandoc % -o %<.pdf --toc-depth=1 -V geometry:margin=2cm --number-sections
autocmd BufNewFile,BufRead,BufEnter *.md :syntax match markdownIgnore "\S_\S"

" python specific 
" use correct tabs
autocmd BufNewFile,BufRead,BufEnter *.py set noexpandtab
autocmd BufNewFile,BufRead,BufEnter *.py set sw=0
autocmd BufNewFile,BufRead,BufEnter *.py set ts=4

" makefile specific
" use correct tabs
autocmd BufNewFile,BufRead,BufEnter Makefile set noexpandtab
autocmd BufNewFile,BufRead,BufEnter Makefile set sw=0
autocmd BufNewFile,BufRead,BufEnter Makefile set ts=4

"change to directory of current file automatically
"autocmd BufEnter * lcd %:p:h

" edit vimrc 
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" source vimrc 
nnoremap <leader>sv :source $MYVIMRC<cr>


" gvim settings
set guifont=Source\ Code\ Pro\ Light\ 16

