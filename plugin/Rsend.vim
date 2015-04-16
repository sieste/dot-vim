" TODO: check for existence of R session with tmux list-sessions:
" let test = system("tmux list-sessions") and go from there


nnoremap <silent> <leader>R :<c-u>call RR("n")<cr>
vnoremap <silent> <leader>R :<c-u>call RR("v")<cr>

function! RR(mode)

  " check if a tmux R session has been opened before
  if !exists("g:rsend_tmux_open")
    let g:rsend_tmux_open="check"

    " open new urxvt terminal, start new tmux session called RSES,
    " and execute R --no-save in background
    silent execute "!urxvt -e tmux new-session -s RSES 'R --no-save' &"

    execute "redraw!"
  endif

  " in normalmode send current line to R
  if a:mode ==# "n"
    let firstline = line(".")
    let lastline = firstline
  endif
  " in visual mode send all selected lines to R
  if a:mode ==# "v"
    let firstline = line("'<")
    let lastline = line("'>'")
  endif

  " loop from first line ("'<") to last line ("'>") of selection
  let l = firstline
  while l <=# lastline

    " get R command from current line
    let Rcmd = getline(l)

    " wrap in quotes, and attach $'\n'
    " e.g. 1+1 becomes "1+1"$'\n'
    " send to R session via tmux 
    silent execute "!tmux send-keys -t RSES " . shellescape(Rcmd, 1) . "$'\\n'"

    " increment line number 
    let l = l+1

  endwhile

  " redraw the screen
  execute "redraw!"

endfunction

