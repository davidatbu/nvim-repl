""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OriginalAuthor: Samuel Roeca
" Maintainer:     Samuel Roeca samuel.roeca@gmail.com
" Description:    nvim-repl: configure and work with a repl
" License:        MIT License
" Website:        https://github.com/pappasam/nvim-repl
" License:        MIT
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Setup:

if exists("g:loaded_repl")
  finish
endif
let g:loaded_repl = v:true
let s:save_cpo = &cpo
set cpo&vim

let s:default_commands = {
      \ 'python': 'python',
      \ }

" User configuration

function! s:configure_constants()
  if !exists('g:repl_filetype_commands')
    let g:repl_filetype_commands = {}
  elseif type(g:repl_filetype_commands) != v:t_dict
    throw 'g:repl_filetype_commands must be Dict'
  endif
  let g:repl_filetype_commands = extend(
        \ s:default_commands,
        \ g:repl_filetype_commands,
        \ )

  if !exists('g:repl_default')
    let g:repl_default = &shell
  elseif type(g:repl_default) != v:t_string
    throw 'g:repl_default must be a String'
  endif
endfunction

" Commands

command! -nargs=? Repl call repl#open(<f-args>)
command! -nargs=? ReplOpen call repl#open(<f-args>)
command! ReplClose call repl#close()
command! ReplToggle call repl#toggle()
command! -range ReplSend <line1>,<line2>call repl#send()

" Pluggable mappings

nnoremap <script> <silent> <Plug>ReplSendLine
      \ :ReplSend<CR>
      \ :call repeat#set("\<Plug>ReplSendLine", v:count)<CR>hj

" visual selection sets up normal mode command for repetition
vnoremap <script> <silent> <Plug>ReplSendVisual
      \ :ReplSend<CR>
      \ :call repeat#set("\<Plug>ReplSendLine", v:count)<CR>gv<esc>j

" Finish

try
  call s:configure_constants()
catch /.*/
  throw printf('nvim-repl: %s', v:exception)
finally
  " Teardown:
  let &cpo = s:save_cpo
  unlet s:save_cpo
endtry
