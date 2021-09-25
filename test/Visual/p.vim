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
  call setline('.', ['foo'])
  call setreg('', ['bar'], 'c')
  normal viw3p
  call g:assert.equals(getline(1, '$'), ['barbarbar'])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [[1, 1, 9]])
  call g:assert.equals(getreg('', 1, 1), ['foo'])
  call g:assert.equals(getregtype(''), 'v')
endfunction


function s:suite.line()
  call setline('.', ['foo'])
  call setreg('', ['bar'], 'l')
  normal V3p
  call g:assert.equals(getline(1, '$'), [
        \   'bar',
        \   'bar',
        \   'bar',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [[1], [2], [3]])
  call g:assert.equals(getreg('', 1, 1), ['foo'])
  call g:assert.equals(getregtype(''), 'V')
endfunction


function s:suite.block()
  call setline('.', [
        \   'foo',
        \   'foo',
        \   'foo',
        \ ])
  call setreg('', ['bar', 'bar', 'bar'], 'b')
  execute "normal \<C-v>Ge3p"
  call g:assert.equals(getline(1, '$'), [
        \   'barbarbar',
        \   'barbarbar',
        \   'barbarbar',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [1, 1, 9],
        \   [2, 1, 9],
        \   [3, 1, 9],
        \ ])
  call g:assert.equals(getreg('', 1, 1), ['foo', 'foo', 'foo'])
  call g:assert.equals(getregtype(''), "\<C-v>3")
endfunction


function s:suite.dot_repeat_char()
  call setline('.', ['foo'])
  call setreg('', ['bar'], 'c')
  normal viw3p
  call g:assert.equals(getline(1, '$'), ['barbarbar'])
  % bwipeout!
  call setline('.', 'bazqux')
  normal! .
  call g:assert.equals(getline(1, '$'), ['qux'])
endfunction



function s:suite.dot_repeat_line()
  call setline('.', ['foo', 'foo'])
  call setreg('', ['bar'], 'l')
  normal Vj3p
  call g:assert.equals(getline(1, '$'), [
        \   'bar',
        \   'bar',
        \   'bar',
        \ ])
  % bwipeout!
  call setline('.', ['baz', 'qux', 'quux'])
  normal! .
  call g:assert.equals(getline(1, '$'), ['quux'])
endfunction



function s:suite.dot_repeat_block()
  call setline('.', [
        \   'foo',
        \   'foo',
        \   'foo',
        \ ])
  call setreg('', ['bar', 'bar', 'bar'], 'b')
  execute "normal \<C-v>Ge3p"
  call g:assert.equals(getline(1, '$'), [
        \   'barbarbar',
        \   'barbarbar',
        \   'barbarbar',
        \ ])
  % bwipeout!
  call setline('.', [
        \   'buzqux',
        \   'buzqux',
        \   'buzqux',
        \ ])
  normal! .
  call g:assert.equals(getline(1, '$'), [
        \   'qux',
        \   'qux',
        \   'qux',
        \ ])
endfunction
