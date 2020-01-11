" File: File
" Author: lymslive
" Description: 
" Create: 2019-11-05
" Modify:y 2019-11-05

let vnite#command#File#space = s:

" :File [-r -a -g[expr]] [{path} | .]
command! -nargs=* -complete=file File call vnite#command#File#run(<f-args>)
let s:description = 'find files/sub-diretory under one path.'
let s:cmdopt = vnite#lib#Cmdopt#new('File')
call s:cmdopt.addhead(s:description)
            \.addoption('recursive', 'r', 'recursively scan sub-directory')
            \.addoption('all', 'a', 'show all file, not apply option &wildignore/suffixes')
            \.addoption('glob', 'g', 'search by glob expr', 's')
            \.addoption('file', 'f', 'only glob plain file')
            \.addoption('dir', 'd', 'only glob directory')
            \.addoption('tail', 't', 'add tail slash for directory')
            \.addoption('sort', 's', 'sort the output items')
            \.addoption('browser', 'b', 'browser mode, sort directory first then file')
            \.addoption('list', 'l', 'read file list from the file', 'filename')
            \.addoption('project', 'p', 'base on current project root', 'mark')
            \.endoption()
            \.addargument('path', 'base path, empty as cwd, dot as current buffer')
            \.addfoot('Implement by pure viml, see also glob() function.')

let s:project_marker = ['.git', '.svn', '.vim']

" Func: #load 
function! vnite#command#File#private() abort
    return s:
endfunction

" Func: #run 
function! vnite#command#File#run(...) abort
    let l:options = s:cmdopt.parse(a:000)
    if empty(l:options) || l:options.help
        return s:cmdopt.usage()
    endif

    if l:options.list
        return s:from_file(l:options.list)
    endif

    let l:path = get(l:options.arguments, 0, '')
    if empty(l:path)
        let l:path = getcwd()
    elseif l:path ==# '.'
        let l:path = expand('%:p:h')
    endif

    if !empty(l:options.project)
        let l:root = ''
        if type(l:options.project) == v:t_string
            let l:root = s:project_root(l:path, l:options.project)
        else
            let l:root =s:project_root(l:path) 
        endif
        if !empty(l:root)
            let l:path = l:root
        endif
    endif

    if isdirectory(l:path) && l:path !~ '[/\\]$'
        let l:expr = l:path
    else
        let l:expr = fnamemodify(l:path, ':h')
    endif

    if l:options.recursive
        let l:expr .= '/**'
    endif

    if !empty(l:options.glob)
        let l:expr = l:expr . '/' . l:options.glob
    else
        let l:expr = l:expr . '/' . '*'
    endif

    let l:ignore = !empty(l:options.all)

    let l:list = s:basic_glob(l:expr, l:ignore)
    if l:options.file || l:options.dir || l:options.tail || l:options.sort || l:options.browser
        let l:list = s:advance_glob(l:list, l:options)
    endif

    echo join(l:list, "\n")
endfunction

" Func: s:basic_glob 
function! s:basic_glob(expr, ignore) abort
    return glob(a:expr, a:ignore, 1)
endfunction

" Func: s:advance_glob 
function! s:advance_glob(list, options) abort
    let l:list = a:list
    let l:options = a:options
    if l:options.browser
        return s:browser_glob(l:list)
    endif

    if l:options.file
        call filter(l:list, '!isdirectory(v:val)')
    elseif l:options.dir
        call filter(l:list, 'isdirectory(v:val)')
    endif

    if !l:options.file && l:options.tail
        call map(l:list, 's:dir_tail(v:val)')
    endif

    if l:options.sort
        call sort(l:list)
    endif

    return l:list
endfunction

" Func: s:browser_glob 
function! s:browser_glob(list) abort
    let l:list = a:list
    let l:files = []
    let l:dirs = []
    for l:item in l:list
        if isdirectory(l:item)
            call add(l:dirs, l:item . '/')
        else
            call add(l:files, l:item)
        endif
    endfor
    call sort(l:files)
    call sort(l:dirs)
    return l:dirs + l:files
endfunction

" Func: s:from_file 
function! s:from_file(filename) abort
    if !filereadable(a:filename)
        return -1
    endif
    let l:list = readfile(a:filename)
    echo join(l:list, "\n")
endfunction

" Func: s:dir_tail 
function! s:dir_tail(dir) abort
    if isdirectory(a:dir)
        return a:dir . '/'
    else
        return a:dir
    endif
endfunction

" Func: s:project_root 
function! s:project_root(path, ...) abort
    if isdirectory(a:path) && a:path !~ '[/\\]$'
        let l:path = a:path
    else
        let l:path = fnamemodify(l:path, ':h')
    endif

    let l:root = ''
    let l:markers = s:get_project_marker()
    while 1
        if a:0 > 0 && !empty(a:1)
            let l:marker = a:1
            if !empty(glob(l:path . '/' . l:marker))
                return l:path
            endif
        else
            for l:marker in l:markers
                if !empty(glob(l:path . '/' . l:marker))
                    return l:path
                endif
            endfor
        endif
        if l:path ==# '/' || l:path =~? '^[a-z]:\\$'
            " break
            return ''
        else
            let l:path = fnamemodify(l:path, ':h')
        endif
    endwhile

    return l:path
endfunction

" Func: s:get_project_marker 
function! s:get_project_marker() abort
    return s:project_marker
endfunction

" Func: #CR 
function! vnite#command#File#CR(message) abort
    let l:text = a:message.text
    let l:file = l:text
    if isdirectory(l:file)
        return 'File ' . l:file
    elseif filereadable(l:file)
        return 'edit ' . l:file
    else
        echoerr 'file unreadable'
        return ''
    endif
endfunction
