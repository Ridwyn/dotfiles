
" Function to output command to a specified tab by name
let g:tab_name = 'scratch------'
let g:tab_buffer = bufnr('%')
function! OutputToTab(cmd)
    " Get list of all tab names
    let tab_list = gettabinfo()
    let tab_nr = -1
    
    " Search for tab with matching name
    for tab in tab_list
        if has_key(tab.variables, 'tab_name') && tab.variables.tab_name == g:tab_name
            let tab_nr = tab.tabnr
            break
        endif
    endfor
    
    " If tab doesn't exist, create new one
    if tab_nr == -1
        execute 'tabnew'
        let tab_nr = tabpagenr()
        call settabvar(tab_nr, 'tab_name', g:tab_name)
        " Set buffer name for clarity
        execute 'file ' . g:tab_name
    else
        " Switch to existing tab
        execute tab_nr . 'tabnext'
    endif
    
    " Create or switch to buffer in the tab
    if bufname('%') != g:tab_name
        execute 'buffer ' . bufnr(g:tab_name, 1)
    endif
    
    " Get current timestamp
    let timestamp = strftime("%Y-%m-%d %H:%M:%S")
    
    
    " Determine if command is a shell command (starts with !)
    if a:cmd =~ '^\s*!'
        " Remove leading ! and execute as shell command
        let remove_bang = substitute(trim(a:cmd), '^!', '', '')
        let shell_cmd = substitute(remove_bang, '\r', '', '') 
		let final_shell_cmd  = shell_cmd . ' 2>&1'
		call  append(line('$'), final_shell_cmd)
        silent let output = system(final_shell_cmd)
	else
        " Execute as Vim command
        silent let output = execute(a:cmd)
    endif
    
    " Move to end of buffer and append timestamp, command, and output
    normal! G
    let lines = ['>>>>> ' . timestamp . ' >>>>> ' . a:cmd] + split(output, '\n') + [repeat('-', 150)]
    call append(line('$'), lines)
    
    " Move cursor to end of buffer
    normal! G
    
    " Set buffer options
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nomodified
endfunction

" Command to call the functiot
command! -nargs=+ RTab call OutputToTab(<q-args>)

"
" Example usage:
" :Rtab MyTab ls
" :Rtab MyTab !ls -l
" :Rtab DebugTab echo &path
