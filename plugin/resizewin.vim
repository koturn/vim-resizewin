" ============================================================================
" FILE: resizewin.vim
" AUTHOR: koturn <jeak.koutan.apple@gmail.com>
" DESCRIPTION: {{{
" Plugin for resizing application window of Vim.
" }}}
" ============================================================================
if exists('g:loaded_resizewin')
  finish
endif
let g:loaded_resizewin = 1
let s:save_cpo = &cpo
set cpo&vim


command! -bar Resizewin  call resizewin#resize()
command! -bar -nargs=+ ResizewinByOffset  call resizewin#resize_by_offset(<f-args>)
command! -bar ResizewinStartFullScreen  call resizewin#start_fullscreen()
command! -bar ResizewinRevertFullScreen  call resizewin#revert_fullscreen()
command! -bar ResizewinToggleFullScreen  call resizewin#toggle_fullscreen()

noremap  <silent> <Plug>(resizewin-start-fullscreen)  :<C-u>call resizewin#start_fullscreen()<CR>
noremap! <silent> <Plug>(resizewin-start-fullscreen)  <Esc>:call resizewin#start_fullscreen()<CR>
noremap  <silent> <Plug>(resizewin-revert-fullscreen)  :<C-u>call resizewin#revert_fullscreen()<CR>
noremap! <silent> <Plug>(resizewin-revert-fullscreen)  <Esc>:call resizewin#revert_fullscreen()<CR>
noremap  <silent> <Plug>(resizewin-toggle-fullscreen)  :<C-u>call resizewin#toggle_fullscreen()<CR>
noremap! <silent> <Plug>(resizewin-toggle-fullscreen)  <Esc>:call resizewin#toggle_fullscreen()<CR>
noremap  <silent> <Plug>(resizewin-expand-columns)  :<C-u>call resizewin#resize_by_offset(1, 0)<CR>
noremap! <silent> <Plug>(resizewin-expand-columns)  :<C-u>call resizewin#resize_by_offset(1, 0)<CR>
noremap  <silent> <Plug>(resizewin-contract-columns)  :<C-u>call resizewin#resize_by_offset(-1, 0)<CR>
noremap! <silent> <Plug>(resizewin-contract-columns)  :<C-u>call resizewin#resize_by_offset(-1, 0)<CR>
noremap  <silent> <Plug>(resizewin-expand-lines)  :<C-u>call resizewin#resize_by_offset(0, 1)<CR>
noremap! <silent> <Plug>(resizewin-expand-lines)  :<C-u>call resizewin#resize_by_offset(0, 1)<CR>
noremap  <silent> <Plug>(resizewin-contract-lines)  :<C-u>call resizewin#resize_by_offset(0, -1)<CR>
noremap! <silent> <Plug>(resizewin-contract-lines)  :<C-u>call resizewin#resize_by_offset(0, -1)<CR>


let &cpo = s:save_cpo
unlet s:save_cpo
