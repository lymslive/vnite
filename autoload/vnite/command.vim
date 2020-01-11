" File: command
" Author: lymslive
" Description: manager vnite command executed by CM
" Create: 2019-11-10
" Modify: 2019-11-10

let g:vnite#command#space = s:
let s:hotcmds = vnite#lib#Circle#new(get(g:, 'g:vnite#config#hotcmds', 10))
let s:running = v:false
let s:output = []

" Func: #precmd 
function! vnite#command#precmd(cmd, history_number) abort
    if a:history_number >= 0
        call s:hotcmds.rotate(a:history_number)
    else
        call s:hotcmds.push(a:cmd)
    endif
    let s:running = v:true
    let s:output = []
endfunction

" Func: #postcmd 
function! vnite#command#postcmd() abort
    let s:running = v:false
endfunction

" Func: #output 
function! vnite#command#output(list) abort
    let s:output = a:list
endfunction

" Func: #history 
function! vnite#command#hotlist(...) abort
    if a:0 > 0 && type(a:1) == v:t_number
        return s:hotcmds.get(a:1)
    endif
    return s:hotcmds.list()
endfunction

" Func: #handled 
function! vnite#command#handled(command) abort
    if empty(a:command)
        return v:false
    endif
    if has_key(g:vnite#config#sharecmd, a:command)
        return v:true
    endif

    let l:file = printf('autoload/vnite/command/%s.vim', a:command)
    return !empty(findfile(l:file, &rtp))
endfunction
