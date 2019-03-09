" send current line or selected text to a tmux pane that is running R

nnoremap <silent> <leader>R :<c-u>call R_send('n')<cr>
vnoremap <silent> <leader>R :<c-u>call R_send('v')<cr>

function! R_send(mode)

  let panes = split(system('tmux list-panes -F "#{pane_index} #{pane_current_command}"'), '\n')
  let r_pane = matchstr(panes, 'R$')
  if empty(r_pane)
    echo "No R pane found in current window ..."
  else

    let r_pane = split(r_pane, ' ')[0]

    if a:mode ==# "n"
      let r_cmd = [getline(".")] " in normal mode use the current line
    endif
    
    if a:mode ==# "v" " in visual mode use the selected text
      let [firstline, firstcol] = getpos("'<")[1:2]
      let [lastline, lastcol] = getpos("'>")[1:2]
      let r_cmd = getline(firstline, lastline)
      let r_cmd[-1] = r_cmd[-1][ : lastcol-(&selection == 'inclusive' ? 1 : 2)]
      let r_cmd[0] = r_cmd[0][firstcol-1 : ]                
      call cursor(getpos("'>")[1], 0) " set cursor position to last line of selection
    endif

    " apply any special rules here
    let ii = 0
    while (ii < len(r_cmd))
      let r_cmd[ii] = substitute(r_cmd[ii], '^```', '# ```', '')
      let ii += 1
    endwhile
    
    " send commands to R pane
    let tmux_cmd_prefix = 'tmux send-keys -t ' . r_pane . ' -l -- '
    let tmux_enter = 'tmux send-keys -t ' . r_pane . ' Enter'
    call system('tmux send-keys -t ' . r_pane . ' C-u') " delete current line
    for r_cmd_i in r_cmd
      call system(tmux_cmd_prefix . shellescape(r_cmd_i))
      call system(tmux_enter)
    endfor

  endif

endfunction



