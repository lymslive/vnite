" File: action
" Author: lymslive
" Description: handdle actions on one message text
" Create: 2019-11-01
" Modify: 2019-11-01

let s:Message = vnite#Message#class()

" Func: #run 
function! vnite#action#run(name) abort
    if !exists('b:VniteContext')
        echoerr 'not in vnite message buffer'
        return -1
    endif

    let l:message = s:get_message()
    let l:cmd = l:message.action(a:name)
    if empty(l:cmd)
        return 0
    endif

    let l:context = b:VniteContext
    if empty(g:vnite#config#keepopen)
        :quit
    endif
    call l:context.winback()
    execute l:cmd
endfunction

" Func: #mo 
function! vnite#action#more() abort
    let l:message = s:get_message()
    call l:message.to_action(a:name)
endfunction

" Func: s:get_message 
function! s:get_message() abort
    let l:line = line('.')
    let l:text = getline('.')
    let l:index = b:VniteContext.orindex(l:line)
    let l:message = s:Message.new(b:VniteContext, l:text, l:index)
    if empty(l:message)
        echoerr 'fail to create Message oject'
        return {}
    endif
    return l:message
endfunction
