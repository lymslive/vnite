" File: helper
" Author: lymslive
" Description: some helper function/command
" Create: 2019-11-02
" Modify: 2019-11-02

" Func: #edit3 (file, [line, col])
function! vnite#helper#edit3(file, ...) abort
    execute 'edit ' . a:file
    if a:0 >= 1 && a:1 > 0
        execute a:1
    endif
    if a:0 >= 2 && a:2 > 0
        execute 'normal! ' . a:2 . '|'
    endif
endfunction


command! -nargs=0 TestKey call vnite#helper#testkey()
" Func: #testkey 
function! vnite#helper#testkey() abort
    let l:ch = getchar()
    let l:type = type(l:ch)
    let l:char = nr2char(l:ch)
    echo 'l:ch' l:ch 'l:type' l:type 'l:char' l:char
endfunction
