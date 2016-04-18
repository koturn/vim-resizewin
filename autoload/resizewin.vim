" ============================================================================
" FILE: resizewin.vim
" AUTHOR: koturn <jeak.koutan.apple@gmail.com>
" DESCRIPTION: {{{
" Plugin for resizing application window of Vim.
" }}}
" ============================================================================
let s:save_cpo = &cpo
set cpo&vim


let s:is_windows = has('win95') || has('win16') || has('win32') || has('win64')
if exists($TMUX) || $TERM ==# 'screen' || !s:is_windows && !has('win32unix') && !has('gui_running')
  let s:errmsg = '[resizewin.vim]: This environment is not supported'
  function! resizewin#resize() abort
    echoerr s:errmsg
  endfunction

  function! resizewin#resize_by_offset(offset_lines, offset_columns) abort
    echoerr s:errmsg
  endfunction

  function! resizewin#start_fullscreen() abort
    echoerr s:errmsg
  endfunction

  function! resizewin#revert_fullscreen() abort
    echoerr s:errmsg
  endfunction

  function! resizewin#toggle_fullscreen() abort
    echoerr s:errmsg
  endfunction

  let &cpo = s:save_cpo
  unlet s:save_cpo
  finish
endif


if !exists('g:resizewin#offset_table')
  let g:resizewin#offset_table = {}
endif
call extend(g:resizewin#offset_table,
      \ {'h': 1,  'j': 1,  'k': 1,  'l': 1,  'H': 3,  'J': 3,  'K': 3,  'L': 3},
      \ 'keep'
      \)
if !exists('g:resizewin#max')
  let g:resizewin#max = {}
endif
call extend(g:resizewin#max, {'columns': 999, 'lines': 999}, 'keep')
if !exists('g:resizewin#min')
  let g:resizewin#min = {}
endif
call extend(g:resizewin#min, {'columns': 20, 'lines': 5}, 'keep')
let g:resizewin#wmctrl = get(g:, 'kotemplate#wmctrl', 'wmctrl')

let s:TYPE_INT = type(0)
let s:cursorkey_table = {
      \ "\<Left>": 'h', "\<Down>": 'j', "\<Up>": 'k', "\<Right>": 'l',
      \ "\<S-Left>": 'H', "\<S-Down>": 'J', "\<S-Up>": 'K', "\<S-Right>": 'L'
      \}
let s:resize_action = {}
let s:is_fullscreen = 0

function! resizewin#resize() abort
  let save_titlestring = &titlestring
  let key = s:getkey()
  let lkey = tolower(key)
  while has_key(s:resize_action, lkey)
    call s:resize_action[lkey](g:resizewin#offset_table[key])
    let &titlestring = 'Window size: (' . &columns . ', ' . &lines . ')'
    redraw
    let key = s:getkey()
    let lkey = tolower(key)
  endwhile
  let &titlestring = save_titlestring
endfunction

function! resizewin#resize_by_offset(offset_columns, offset_lines) abort
  let lines = &lines + a:offset_lines
  let &lines = lines < g:resizewin#min.lines ? g:resizewin#min.lines
        \ : lines > g:resizewin#max.lines ? g:resizewin#max.lines
        \ : lines
  let columns = &columns + a:offset_columns
  let &columns = columns < g:resizewin#min.columns ? g:resizewin#min.columns
        \ : columns > g:resizewin#max.columns ? g:resizewin#max.columns
        \ : columns
endfunction


function! resizewin#start_fullscreen() abort
  let s:is_fullscreen = 1
  call s:start_fullscreen()
endfunction

function! resizewin#revert_fullscreen() abort
  let s:is_fullscreen = 0
  call s:revert_fullscreen()
endfunction

function! resizewin#toggle_fullscreen() abort
  if s:is_fullscreen
    call resizewin#revert_fullscreen()
  else
    call resizewin#start_fullscreen()
  endif
endfunction


function! s:getkey() abort
  let key = getchar()
  return type(key) == s:TYPE_INT ? nr2char(key)
        \ : has_key(s:cursorkey_table, key) ? s:cursorkey_table[key]
        \ : 'q'
endfunction

function! s:resize_action.h(offset) abort
  let columns = &columns - a:offset
  let &columns = columns >= g:resizewin#min.columns ? columns : g:resizewin#min.columns
endfunction

function! s:resize_action.j(offset) abort
  let lines = &lines + a:offset
  let &lines = lines <= g:resizewin#max.lines ? lines : g:resizewin#max.lines
endfunction

function! s:resize_action.k(offset) abort
  let lines = &lines - a:offset
  let &lines = lines >= g:resizewin#min.lines ? lines : g:resizewin#min.lines
endfunction

function! s:resize_action.l(offset) abort
  let columns = &columns + a:offset
  let &columns = columns <= g:resizewin#max.columns ? columns : g:resizewin#max.columns
endfunction

if executable(g:resizewin#wmctrl)
  function! s:start_fullscreen() abort
    call s:execute_wmctrl('add')
  endfunction
  function! s:revert_fullscreen() abort
    call s:execute_wmctrl('remove')
  endfunction
  function! s:execute_wmctrl(mod) abort
    call system(g:resizewin#wmctrl . ' -ir ' . v:windowid . ' -b ' . a:mod . ',fullscreen')
  endfunction
elseif has('gui_macvim')
  let s:save_fuoptions = &fuoptions
  function! s:start_fullscreen() abort
    let s:save_fuoptions = &fuoptions
    set fuoptions=maxvert,maxhorz
    set fullscreen
  endfunction
  function! s:revert_fullscreen() abort
    set nofullscreen
    let &fuoptions = s:save_fuoptions
  endfunction
elseif s:is_windows && has('gui_running') && !has('nvim')
  let s:save_guioptions = &guioptions
  if !exists('g:resizewin#gui_config')
    let g:resizewin#gui_config = {}
  endif
  call extend(g:resizewin#gui_config,
        \ {'hide_menubar': 1, 'hide_toolbar': 1, 'hide_caption': 1},
        \ 'keep'
        \)
  function! s:start_fullscreen() abort
    let s:save_guioptions = &guioptions
    if g:resizewin#gui_config.hide_menubar && &guioptions =~# 'm'
      set guioptions-=m
    endif
    if g:resizewin#gui_config.hide_toolbar && &guioptions =~# 'T'
      set guioptions-=T
    endif
    if g:resizewin#gui_config.hide_caption && &guioptions !~# 'C'
      set guioptions+=C
    endif
    simalt ~x
  endfunction
  function! s:revert_fullscreen() abort
    simalt ~r
    let &guioptions = s:save_guioptions
  endfunction
else
  let s:winpos_cmd = ''
  let [s:save_lines, s:save_columns] = [&lines, &columns]
  function! s:start_fullscreen() abort
    let s:winpos_cmd = s:make_winpos_cmd()
    let [s:save_lines, s:save_columns] = [&lines, &columns]
    winpos -8 -8
    winsize 999 999
  endfunction
  function! s:revert_fullscreen() abort
    execute s:winpos_cmd
    let [&lines, &columns] = [s:save_lines, s:save_columns]
  endfunction
  function! s:make_winpos_cmd()
    let winpos_cmd = ''
    try
      let [save_verbose, save_verbosefile] = [&verbose, &verbosefile]
      set verbose=0 verbosefile=
      redir => str
      silent winpos
      redir END
      let poslist = split(str, ' ')
      let winpos_cmd = 'winpos ' . poslist[3][: -2] . ' ' . poslist[5]
    catch
      redir END
    finally
      let [&verbose, &verbosefile] = [save_verbose, save_verbosefile]
    endtry
    return winpos_cmd
  endfunction
  function! s:restore_terminal() abort
    if s:is_fullscreen
      let [&lines, &columns] = [s:save_lines, s:save_columns]
      execute s:winpos_cmd
    endif
  endfunction
  augroup Resizewin
    autocmd!
    autocmd VimLeave * call s:restore_terminal()
  augroup END
endif


let &cpo = s:save_cpo
unlet s:save_cpo
