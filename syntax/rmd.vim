runtime! syntax/markdown.vim

" do not highlight a_1 as markdown error
syntax match markdownIgnore "\S_\S"

" highlight document caption 
syntax match RmdCaption "^%.*$" 
highlight default link RmdCaption Todo

" blue math
syntax region RmdMath start=/\$\+/ end=/\$\+/
syntax region RmdMath start=/^\\begin{equation.*$/ end=/^\\end{equation.*$/
syntax region RmdMath start=/^\\begin{align.*$/ end=/^\\end{align.*$/
highlight default link RmdMath Comment

" R syntax code blocks
unlet b:current_syntax
syntax include @R syntax/r.vim
syntax region Rsnippet matchgroup=Comment start=/^```{r.*$/ end=/^```$/ contains=@R keepend 
" highlight Rsnippet guibg=gray ..... this does not set all backround to gray, only non-keywords

" set new syntax type
let b:current_syntax='rmd'
