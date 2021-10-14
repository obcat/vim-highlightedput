let s:suite = themis#suite('Visual mode: p:')

function s:suite.before()
endfunction

function s:suite.before_each() abort
  call DeleteAllRegisters()
  % bwipeout!
endfunction

function s:suite.after()
  call s:suite.before_each()
endfunction



function s:suite.char()
  call setline(1, ['txt'])
  call setreg('', ['Nadim'], 'c')
  normal! viw
  normal 3p
  call g:assert.equals(getline(1, '$'), ['NadimNadimNadim'])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [[1, 1, 15]])
  call g:assert.equals(getreg('', 1, 1), ['txt'])
  call g:assert.equals(getregtype(''), 'v')
endfunction


function s:suite.line()
  call setline(1, ['txt'])
  call setreg('', ['Nadim'], 'l')
  normal! V
  normal 3p
  call g:assert.equals(getline(1, '$'), [
        \   'Nadim',
        \   'Nadim',
        \   'Nadim',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [1],
        \   [2],
        \   [3],
        \ ])
  call g:assert.equals(getreg('', 1, 1), ['txt'])
  call g:assert.equals(getregtype(''), 'V')
endfunction


function s:suite.block()
  call setline(1, [
        \   'txt',
        \   'txt',
        \   'txt',
        \ ])
  call setreg('', [
        \   'Nadim',
        \   'Nadim',
        \   'Nadim',
        \ ], 'b')
  execute "normal! \<C-v>Ge"
  normal 3p
  call g:assert.equals(getline(1, '$'), [
        \   'NadimNadimNadim',
        \   'NadimNadimNadim',
        \   'NadimNadimNadim',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [1, 1, 15],
        \   [2, 1, 15],
        \   [3, 1, 15],
        \ ])
  call g:assert.equals(getreg('', 1, 1), [
        \   'txt',
        \   'txt',
        \   'txt',
        \ ])
  call g:assert.equals(getregtype(''), "\<C-v>3")
endfunction


function s:suite.dot_repeat_char()
  call setline(1, ['txt'])
  call setreg('', ['Nadim'], 'c')
  normal! viw
  normal p
  call g:assert.equals(getline(1, '$'), ['Nadim'])
  % bwipeout!
  call setline(1, 'version')
  normal! .
  call g:assert.equals(getline(1, '$'), ['sion'])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [])
  call g:assert.equals(getreg('', 1, 1), ['ver'])
  call g:assert.equals(getregtype(''), 'v')
endfunction



function s:suite.dot_repeat_line()
  call setline(1, [
        \   'txt',
        \   'txt',
        \   'txt',
        \ ])
  call setreg('', ['Nadim'], 'l')
  normal! VG
  normal p
  call g:assert.equals(getline(1, '$'), [
        \   'Nadim',
        \ ])
  % bwipeout!
  call setline(1, [
        \   'version',
        \   'version',
        \   'version',
        \   'version',
        \   'version',
        \ ])
  normal! .
  call g:assert.equals(getline(1, '$'), [
        \   'version',
        \   'version',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [])
  call g:assert.equals(getreg('', 1, 1), [
        \   'version',
        \   'version',
        \   'version',
        \ ])
  call g:assert.equals(getregtype(''), 'V')
endfunction



function s:suite.dot_repeat_block()
  call setline(1, [
        \   'txt',
        \   'txt',
        \   'txt',
        \ ])
  call setreg('', [
        \   'Nadim',
        \   'Nadim',
        \   'Nadim',
        \ ], 'b')
  execute "normal! \<C-v>Ge"
  normal p
  call g:assert.equals(getline(1, '$'), [
        \   'Nadim',
        \   'Nadim',
        \   'Nadim',
        \ ])
  % bwipeout!
  call setline(1, [
        \   'version',
        \   'version',
        \   'version',
        \ ])
  normal! .
  call g:assert.equals(getline(1, '$'), [
        \   'sion',
        \   'sion',
        \   'sion',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [])
  call g:assert.equals(getreg('', 1, 1), [
        \   'ver',
        \   'ver',
        \   'ver',
        \ ])
  call g:assert.equals(getregtype(''), "\<C-v>3")
endfunction
