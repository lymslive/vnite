" File: Vnite
" Author: lymslive
" Description: list Vnite command
" Create: 2019-11-02
" Modify: 2019-11-02

let s:description = 'list all supported Vnite command, can edit argument inplace and execute'
let s:nargs = 0
let s:argtips = ''

" Func: #define 
function! vnite#command#Vnite#define() abort
    let l:history = vnite#command#hotlist()
    for l:idx in range(len(l:history))
        echo l:idx . ': ' . l:history[l:idx]
    endfor

    let l:paths = globpath(&rtp, 'autoload/vnite/command/**/*.vim', 0, 1)
    for l:path in l:paths
        let l:cmd = fnamemodify(l:path, ":p:t:r")
        let l:private = s:getcmdinfo(l:cmd)
        let l:argtips = get(l:private, 'argtips', '')
        let l:description = get(l:private, 'description', '')
        let l:line = l:cmd
        if !empty(l:argtips)
            let l:line = l:line . ' | ' . l:argtips
        endif
        if !empty(l:description)
            let l:line = l:line . ' |" ' . l:description
        endif
        echo l:line
    endfor
    if exists('g:vnite#config#extracmdlist') && type(g:vnite#config#extracmdlist) == v:t_list
        for l:line in g:vnite#config#extracmdlist
            echo l:line
        endfor
    endif
endfunction

" Func: #CR 
function! vnite#command#Vnite#CR(message) abort
    let l:text = a:message.text
    let l:tokens = split(l:text, '\s\+')
    let l:cmd = l:tokens[0]
    if l:cmd ==# 'Vnite'
        " donot rerun :Vnite
        return ''
    elseif l:cmd =~# '^\d\+:'
        let l:cmd = substitute(l:cmd, ':\s*$', '', 'g')
        return 'CM ' . l:cmd
    endif

    if len(l:tokens) < 2
        return 'CM ' . l:cmd
    endif
    let l:pipe = l:tokens[1]
    if l:pipe == '|"'
        return 'CM ' . l:cmd
    elseif l:pipe == '|'
        echo printf(':%s require arguments, can use C on the first | to edit inplace')
        return ''
    else
        return 'CM ' . l:text
    endif
endfunction

" Func: #private 
function! vnite#command#Vnite#private() abort
    return s:
endfunction

" Func: s:getcmdinfo 
function! s:getcmdinfo(cmd) abort
    let l:cmd = substitute(a:cmd, '^!', '_', '')
    let l:Fprivate = function('vnite#command#' . l:cmd . '#private')
    try
        let l:private = l:Fprivate()
    catch 
        if exists('g:vnite#command#' . l:cmd . '#space')
            let l:private = g:vnite#command#{l:cmd}#space
        else
            let l:private = {}
        endif
    endtry
    return l:private
endfunction
