" TODO: 
" - R markdown mode
" - write documentation


nnoremap <silent> <leader>R :<c-u>call RR("n")<cr>
vnoremap <silent> <leader>R :<c-u>call RR("v")<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
" FUNCTION: SEND_TMUX
" send the string 'Rcmd' (followed by return) to tmux session named 'session'
function! s:send_tmux(Rcmd, session)
  " shell-escape the command;
  " wrap in quotes; 
  " attach $'\n';
  " e.g. 1+1 becomes "1+1"$'\n'
  " send this to R session via tmux 
  silent execute "!tmux send-keys -t " . a:session . " " . shellescape(a:Rcmd, 1) . "$'\\n'"
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
" FUNCTION: RR
" function to send the current selection or current line to an
" R session in a separate urxvt window
function! RR(mode)

  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
  " check if a tmux R session has been opened before by testing " if the global
  " variable r_session_name exists; otherwise set it using a random number
  if !exists("g:r_session_name")
    let rnd = split(system("echo $RANDOM"), '\v\n')[0]
    let g:r_session_name = "R_" . rnd
  endif

  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
  " check if the corresponding named tmux session is currently opened " by
  " testing if the return value of tmux... | grep... is non-empty; 
  " if empty, start new tmux session with R
  let tmux_open = system("tmux list-sessions 2>/dev/null | grep " . g:r_session_name)
  if empty(tmux_open)
    " open new urxvt terminal, start new tmux session with a unique name,
    " and execute R --no-save in background
    silent execute "!urxvt -e tmux new-session -s " . g:r_session_name . " 'R --no-save' &"
    sleep 1
    execute "redraw!"
  endif

  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
  " check for mode ...
  " in normalmode: 
  if a:mode ==# "n"
    " send just the current line to R
    let Rcmd = getline(".")
    call s:send_tmux(Rcmd, g:r_session_name)
  endif

  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
  " in visual mode:
  if a:mode ==# "v"
    " get line and column of start and end of selection
    let [firstline, firstcol] = getpos("'<")[1:2]
    let [lastline, lastcol] = getpos("'>")[1:2]
  
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
    " only one line selected?
    if firstline ==# lastline
      let Rcmd = getline(firstline)[firstcol-1 : lastcol-1]
      call s:send_tmux(Rcmd, g:r_session_name)

    " or multiple lines selected?
    else
      " loop from firstline to lastline 
      let l = firstline
      while l <=# lastline
    
        " read entire current line
        let Rcmd = getline(l)
        " cut off beginning of first line
        if l ==# firstline 
          let Rcmd = Rcmd[firstcol - 1 :]
        endif
        " cut off end of last line
        if l ==# lastline
          let Rcmd = Rcmd[: lastcol - 1]
        endif

        " execute 
        call s:send_tmux(Rcmd, g:r_session_name)
    
        " increment line number 
        let l = l+1
      endwhile
    endif
  endif

  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
  " redraw the screen
  execute "redraw!"

endfunction

