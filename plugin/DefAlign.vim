nnoremap <leader>g :<c-u>call DefAlign("n")<cr>
vnoremap <leader>g :<c-u>call DefAlign("v")<cr>

" align variable definitions in current paragraph or current selection using
" first `<-` as delimiter
function! DefAlign(mode)
  " save initial cursor position
  let pos_orig = getcurpos()

  " get delimiter from command line
  let delim = input("Enter delimiter: ", "<-")

  " if in normal mode select current paragraph
  if a:mode ==# "n"
    execute "normal! mavip\<esc>`a"
  endif
  let rowone = line("'<")
  let rowtwo = line("'>")
  
  " save position of delim for each line that contains delim
  let pos = {}
  for row in range(rowone, rowtwo)
    " position cursor at beginning of row
    call cursor(row, 1)
    " check if current line contains pattern, if it does append 
    " position of delim
    if search(delim, "n", row) !=# 0
      call search(delim)
      let pos[row] = getcurpos()[2]
    endif  
  endfor
  let maxpos = max(pos)
  
  " shift every occurrence of delim to match maxpos
  for row in keys(pos)
    call cursor(row, 1)
    call search(delim)
    while (getcurpos()[2] <# maxpos)
      execute "normal! i\<space>\<esc>l"
    endwhile
  endfor

  " restore cursor position
  call cursor(pos_orig[1:2])

endfunction

