" tex specific macros
"


" compile current file with pdflatex
noremap + :w<enter>:!pdflatex %<.tex<enter><enter>

nnoremap <leader>END <esc>yyp0lcwend<esc>O

" environments
noremap <c-a> <esc>o\begin{align}<cr>\end{align}<esc>O
noremap <c-e> <esc>o\begin{equation}<cr>\end{equation}<esc>O
noremap <c-i> <esc>o\begin{itemize}<cr>\end{itemize}<esc>O\item<space>

