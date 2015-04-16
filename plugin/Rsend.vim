nnoremap <silent> <leader>R :<c-u>call RR()<cr>
vnoremap <silent> <leader>R :<c-u>call RR()<cr>

function! RR()

  " check if a tmux R session has been opened before
  if !exists("g:rsend_tmux_open")
    let g:rsend_tmux_open="check"

    " open new urxvt terminal, start new tmux session called RSES,
    " and execute R --no-save in background
    silent execute "!urxvt -e tmux new-session -s RSES 'R --no-save' &"

    execute "redraw!"
  endif

  " loop from first line ("'<") to last line ("'>") of selection
  let l = line("'<")
  while l <=# line("'>")

    " get current line, wrap in quotes, and attach $'\n'
    " e.g. 1+1 becomes "1+1"$'\n'
    let curline = "\"" . getline(l) . "\"$'\\n'"

    " send to R session via tmux and redraw
    silent execute "!tmux send-keys -t RSES " . curline

    " increment line number 
    let l = l+1

  endwhile

  execute "redraw!"

endfunction

