" TODO: 
" - character-wise visual mode
" - R markdown mode


nnoremap <silent> <leader>R :<c-u>call RR("n")<cr>
vnoremap <silent> <leader>R :<c-u>call RR("v")<cr>

function! RR(mode)

  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
  " check if a tmux R session has been opened before by testing
  " if the variable exists; otherwise set it using a random number
  if !exists("g:r_session_name")
    let rnd = split(system("echo $RANDOM"), '\v\n')[0]
    let g:r_session_name = "R_" . rnd
  endif

  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
  " check if the corresponding named tmux session is currently opened
  " by testing if the tmux/grep string is non-empty; if empty, start new 
  " tmux session with R
  let tmux_open = system("tmux list-sessions | grep " . g:r_session_name)
  if empty(tmux_open)
    " open new urxvt terminal, start new tmux session called RSES,
    " and execute R --no-save in background
    silent execute "!urxvt -e tmux new-session -s " . g:r_session_name . " 'R --no-save' &"
    execute "redraw!"
  endif

  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
  " check for mode ...
  " in normalmode: 
  if a:mode ==# "n"
    " send the current line to R
    let firstline = line(".")
    let lastline = firstline
  endif
  " in (any) visual mode:
  if a:mode ==# "v"
    " send all selected *lines* to R
    let firstline = line("'<")
    let lastline = line("'>'")
  endif

  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
  " loop from firstline to lastline 
  let l = firstline
  while l <=# lastline

    " get current line
    let Rcmd = getline(l)

    " shell-escape the command;
    " wrap in quotes; 
    " attach $'\n';
    " e.g. 1+1 becomes "1+1"$'\n'
    " send this to R session via tmux 
    silent execute "!tmux send-keys -t " . g:r_session_name . " " . shellescape(Rcmd, 1) . "$'\\n'"

    " increment line number 
    let l = l+1

  endwhile

  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
  " redraw the screen
  execute "redraw!"

endfunction

