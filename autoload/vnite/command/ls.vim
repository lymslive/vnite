" File: ls
" Author: lymslive
" Description: action config for ls command
" Create: 2019-11-01
" Modify: 2019-11-01

let s:description = 'list all buffers, also :buffers, CR to open the buffer'

" Func: #CR 
function! vnite#command#ls#CR(message) abort
    let l:text = a:message.text
    let l:bufnr = matchstr(l:text, '^\s*\zs\d\+\ze')
    if empty(l:bufnr)
        echoerr 'cannot find bufnr, it seems not output from ls'
        return ''
    endif
    return l:bufnr . 'buffer'
endfunction

function! vnite#command#ls#private() abort
    return s:
endfunction
