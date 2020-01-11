" File: Message
" Author: lymslive
" Description: Message class
" Create: 2019-10-31
" Modify: 2019-10-31

" represent a message from the command output, a line text
let s:class = {}
let s:class._ctype_ = 'Message'
let s:class.context = {}    " refer to the command context
let s:class.index = -1       " the index in all messages list
let s:class.text = ''       " the text line of this message
let s:class.hasfile = 0
let s:class.filepath = ''
let s:class.lpos = 0
let s:class.cpos = 0

let s:NO_FILE = 0
let s:IS_FILE = 1
let s:IS_DIR = 2

" Func: #class 
function! vnite#Message#class() abort
    return s:class
endfunction

" Method: new 
function! s:class.new(context, ...) dict abort
    if empty(a:context)
        return {}
    endif

    if a:0 == 0
        echoerr 'expect a text string or index to create Message object'
        return {}
    endif

    let l:object = copy(s:class)
    let l:object.context = a:context
    if type(a:1) == v:t_string
        let l:object.text = a:1
        if a:0 >= 2 && type(a:2) == v:t_number && a:2 >= 0
            let l:object.index = a:2
        endif
    elseif type(a:1) == v:t_number
        let l:object.index = a:index
        let l:object.text = self.findtext()
    else
        echoerr 'expect a text string or index to create Message object'
        return {}
    endif

    return l:object
endfunction

" Method: findtext 
function! s:class.findtext() dict abort
    return self.context.messages[self.index]
endfunction

" Method: action 
function! s:class.action(...) dict abort
    let l:name = 'CR'
    if a:0 > 0 && !empty(a:1)
        let l:name = a:1
    endif
    let l:Func = self.action_handle(l:name)
    try
        let l:cmd = l:Func(self)
    catch 
        let l:cmd = self.default_action()
    endtry
    return l:cmd
endfunction

" Method: action_handle 
function! s:class.action_handle(name) dict abort
    let l:func = 'vnite#command#' . self.context.transfer_command_name()
    let l:func = l:func . '#' . a:name
    return function(l:func)
endfunction

" Method: do_action 
function! s:class.do_action(cmd) dict abort
    " close message buffer
    :quit
    call self.context.winback()
    execute a:cmd
endfunction

" Method: default_action 
function! s:class.default_action() dict abort
    echo 'default action dummy'
    call self.parse()
    return ''
endfunction

" Method: parse 
function! s:class.parse() dict abort
    let l:text = self.text
endfunction

" Method: to_action 
" show a vsplit window to show all available actions and bind key
function! s:class.to_action() dict abort
    " code
endfunction
