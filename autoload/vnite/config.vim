" File: config
" Author: lymslive
" Description: vnite config for vnite
" Create: 2019-10-31
" Modify: 2019-10-31

" short cute to prefix current cmdline
cnoremap <C-CR> <Home>CM -- <CR>
" from normal mode, map to show the current message buffer window
nnoremap <S-CR> :CM<CR>
nnoremap <C-CR>b :CM ls<CR>
nnoremap <C-CR>o :CM oldfiles<CR>
nnoremap <C-CR>s :CM scriptnames<CR>
nnoremap <C-CR>r :CM registers<CR>
nnoremap <C-CR>m :CM marks<CR>
nnoremap <C-CR>j :CM jumps<CR>
nnoremap <C-CR><Space> :CM Vnite<CR>

" Func: #nmap_msgbuf 
" maps in message buffer that command output
function! vnite#config#nmap_msgbuf() abort
    nnoremap <buffer> q :q<CR>
    nnoremap <buffer> / :StartFilter<CR>
    nnoremap <buffer> <CR> :call vnite#action#run('CR')<CR>
    nnoremap <buffer> <Tab> :call vnite#action#more()<CR>
endfunction

" global filter mode maps
" Func: #fmap_global 
function! vnite#config#fmap_global() abort
    Fnoremap <CR>  <Esc>:call vnite#filter#lineCR()<CR>
    Fnoremap <C-P> <Esc>:call vnite#filter#lineup()<CR>
    Fnoremap <C-N> <Esc>:call vnite#filter#linedown()<CR>
    Fnoremap <C-J> <Esc>:call vnite#filter#line2end()<CR>
    Fnoremap <C-L> <C-U><Esc>
endfunction

" some command behave or act on output similarly 
let g:vnite#config#sharecmd = {
            \ 'scriptnames' : 'oldfiles',
            \ 'buffers' : 'ls',
            \ 'files' : 'ls'
            \ }

" to add list by :Vnite command
let g:vnite#config#extracmdlist = [
            \ 'scriptnames |" list all sourced script, CR to open one'
            \ ]

" the height of message window
let g:vnite#config#winheight = 15
" when open CM message buffer, start filter mode automaticlly
let g:vnite#config#startfilter = 0
" when first to new message, scroll to the end bottom
let g:vnite#config#starttoend = 0
" after press <CR> to fire action, keep CM buffer open
let g:vnite#config#keepopen = 0
" the history amount to keep the recent used CM command
let g:vnite#config#hotcmds = 10

function! vnite#config#load() abort "{{{
    return 1
endfunction "}}}
