" File: main
" Author: lymslive
" Description: main functions entrance
" Create: 2019-11-01
" Modify: 2019-11-01

let g:vnite#main#space = s:
let s:Context = vnite#Context#class()

let s:jLastContext = {}
let s:sLastOut = ''
let s:sMsgBufName = '_CMDMSG_'

if !exists(':CM')
    command! -bang -count=0 -nargs=* -complete=command CM call vnite#main#run(<bang>0, <count>, <f-args>)
endif
let s:cmdopt = vnite#lib#Cmdopt#new('CM')
call s:cmdopt.addhead('Capture and filter message output of any command')
            \.addoption('smart', 's', 'only capture if the command can handled by vnite')
            \.endoption()
            \.addargument('cmd', 'the real command will execute')

" Func: #run 
function! vnite#main#run(bang, count, ...) abort
    let l:options = s:cmdopt.parse(a:000)
    if empty(l:options) || l:options.help
        return s:cmdopt.usage()
    endif

    let l:count = -1
    let l:cmd = join(l:options.arguments, ' ')
    if empty(l:cmd)
        if a:count > 0
            let l:history = vnite#command#hotlist(a:count)
            if !empty(l:history)
                let l:cmd = l:history
                let l:count = a:count
            endif
        else
            return s:show_message_window()
        endif
    else
        if l:cmd =~# '^\s*CM\s\+'
            " protect accidently repeat :CM CM prefix
            let l:cmd = substitute(l:cmd, '^\s*CM\s\+', '', '')
        endif
    endif

    let l:context = s:Context.new(l:cmd)
    let s:jLastContext = l:context
    if l:options.smart && !vnite#command#handled(s:jLastContext.command)
        execute l:cmd
        return
    endif

    if s:run_cmd(l:cmd, l:count) != 0
        return -1
    endif

    let l:bFilter = !empty(g:vnite#config#startfilter)
    if a:bang
        let l:bFilter = !l:bFilter
    endif
    if l:bFilter
        :StartFilter
    endif
endfunction

" Func: s:run_cmd 
function! s:run_cmd(cmd, history_number) abort
    let l:succ = v:true
    let l:output = ''
    try
        call vnite#command#precmd(a:cmd, a:history_number)
        let l:output = execute(a:cmd)
    catch 
        let l:succ = v:false
        echo "vnite caught " .. v:exception
    finally
        call vnite#command#postcmd()
    endtry

    if !l:succ
        return -1
    endif

    if !empty(g:vnite#command#space.output)
        call s:jLastContext.store(g:vnite#command#space.output)
    elseif !empty(l:output)
        call s:jLastContext.store(l:output)
    else
        return -1
    endif

    return s:show_message_window(s:jLastContext)
endfunction

" Func: #statusline 
function! vnite#main#statusline() abort
    if empty(s:jLastContext)
        return &g:statusline
    endif
    let l:stl = 'CM ' . s:jLastContext.cmdline
    if !empty(s:jLastContext.simcli)
        let l:filter = join(s:jLastContext.simcli.cmdline, '')
        if s:jLastContext.simcli.active
            let l:sep = ' || '
        else
            let l:sep = ' | '
        endif
        let l:stl = l:filter . l:sep . l:stl
    endif
    let l:stl = l:stl . '%=%l/%L'
    return l:stl
endfunction

" Func: s:show_message_window 
function! s:show_message_window(...) abort
    let l:iBufnr = s:get_message_buffer()
    if l:iBufnr < 0
        echoerr 'Error: cannot creat message buffer?'
        return -1;
    endif
    let l:iWinnr = bufwinnr(l:iBufnr)
    if l:iWinnr < 0
        execute s:split_cmd()
        execute 'buffer ' . l:iBufnr
    else
        execute l:iWinnr . 'wincmd w'
    endif
    call s:check_maps()
    if a:0 > 0 && !empty(a:1)
        execute '1,$ delete'
        let l:context = a:1
        let b:VniteContext = l:context
        call setbufline(l:iBufnr, 1, l:context.messages)
        if !empty(g:vnite#config#starttoend)
            normal! G
        endif
    endif
endfunction

" Func: s:get_message_buffer 
function! s:get_message_buffer() abort
    let l:iBufnr = bufnr(s:sMsgBufName)
    if l:iBufnr > 0
        return l:iBufnr
    endif
    execute s:split_cmd() . ' ' . s:sMsgBufName
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal nobuflisted
    setlocal filetype=cmdmsg
    setlocal statusline=%!vnite#main#statusline()
    call vnite#config#nmap_msgbuf()
    return bufnr(s:sMsgBufName)
endfunction

" Func: s:check_maps 
function! s:check_maps() abort
    let l:map = maparg('q', 'n', 0, 1)
    if !empty(l:map) && get(l:map, 'buffer', 0) == 1
        return
    else
        call vnite#config#nmap_msgbuf()
        setlocal statusline=%!vnite#main#statusline()
    endif
endfunction

" Func: s:split_cmd 
function! s:split_cmd() abort
    let l:height = 10
    if exists('g:vnite#config#winheight') && g:vnite#config#winheight > 0
        let l:height = g:vnite#config#winheight
    endif
    return printf('botright %d split', l:height)
endfunction

" Func: s:prev_cmd 
function! s:prev_cmd() abort
    " code
endfunction
