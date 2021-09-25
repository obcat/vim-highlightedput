let s:suite = themis#suite('Normal mode: p:')

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
  call setline('.', ['#'])
  call setreg('', ['foo'], 'c')
  normal 3p
  call g:assert.equals(getline(1, '$'), ['#foofoofoo'])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [[1, 2, 9]])
  % bwipeout!

  call setline('.', ['#'])
  call setreg('', ['foo', 'bar'], 'c')
  normal 3p
  call g:assert.equals(getline(1, '$'), [
        \   '#foo',
        \   'barfoo',
        \   'barfoo',
        \   'bar',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [1, 2, 4],
        \   [2, 1, 7],
        \   [3, 1, 7],
        \   [4, 1, 3],
        \ ])
  % bwipeout!

  call setline('.', ['#'])
  call setreg('', ['', 'foo'], 'c')
  normal 3p
  call g:assert.equals(getline(1, '$'), [
        \   '#',
        \   'foo',
        \   'foo',
        \   'foo',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [1, 2, 1],
        \   [2, 1, 4],
        \   [3, 1, 4],
        \   [4, 1, 3],
        \ ])
  % bwipeout!

  call setline('.', ['#'])
  call setreg('', ['foo', ''], 'c')
  normal 3p
  call g:assert.equals(getline(1, '$'), [
        \   '#foo',
        \   'foo',
        \   'foo',
        \   '',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [1, 2, 4],
        \   [2, 1, 4],
        \   [3, 1, 4],
        \ ])
  % bwipeout!
endfunction



function s:suite.line()
  call setline('.', [''])
  call setreg('', ['foo'], 'l')
  normal 3p
  call g:assert.equals(getline(1, '$'), [
        \   '',
        \   'foo',
        \   'foo',
        \   'foo',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [[2], [3], [4]])
endfunction



function s:suite.block()
  call setline('.', [
        \   '',
        \   '',
        \   '',
        \ ])
  call setreg('', ['a', 'ab', 'abc'], 'b')
  normal 3p
  call g:assert.equals(getline(1, '$'), [
        \   'a  a  a',
        \   'ab ab ab',
        \   'abcabcabc',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
       \   [1, 1, 7],
       \   [2, 1, 8],
       \   [3, 1, 9],
       \ ])
  % bwipeout!

  call setline('.', [
        \   '#',
        \   '#',
        \   '#',
        \ ])
  call setreg('', ['a', 'ab', 'abc'], 'b')
  normal 3p
  call g:assert.equals(getline(1, '$'), [
        \   '#a  a  a',
        \   '#ab ab ab',
        \   '#abcabcabc',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
       \   [1, 2, 7],
       \   [2, 2, 8],
       \   [3, 2, 9],
       \ ])
  % bwipeout!

  call setline('.', [
        \   '##',
        \   '##',
        \   '##',
        \ ])
  call setreg('', ['a', 'ab', 'abc'], 'b')
  normal 3p
  call g:assert.equals(getline(1, '$'), [
        \   '#a  a  a  #',
        \   '#ab ab ab #',
        \   '#abcabcabc#',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
       \   [1, 2, 9],
       \   [2, 2, 9],
       \   [3, 2, 9],
       \ ])
  % bwipeout!

  call setline('.', [
        \   '',
        \   '',
        \   '',
        \ ])
  call setreg('', ['', 'a', 'ab'], 'b')
  normal p
  call g:assert.equals(getline(1, '$'), [
        \   '',
        \   'a',
        \   'ab',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
       \   [2, 1, 1],
       \   [3, 1, 2],
       \ ])
  % bwipeout!

  call setline('.', [
        \   '#',
        \   '#',
        \   '#',
        \ ])
  call setreg('', ['', 'a', 'ab'], 'b')
  normal p
  call g:assert.equals(getline(1, '$'), [
        \   '#',
        \   '#a',
        \   '#ab',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
       \   [2, 2, 1],
       \   [3, 2, 2],
       \ ])
  % bwipeout!

  call setline('.', [
        \   '##',
        \   '##',
        \   '##',
        \ ])
  call setreg('', ['', 'a', 'ab'], 'b')
  normal p
  call g:assert.equals(getline(1, '$'), [
        \   '#  #',
        \   '#a #',
        \   '#ab#',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
       \   [1, 2, 2],
       \   [2, 2, 2],
       \   [3, 2, 2],
       \ ])
endfunction



function s:suite.dot_repeat_line()
  call setline('.', '')
  call setreg('', ['foo'], 'l')
  normal 2p
  call g:assert.equals(getline(1, '$'), [
        \   '',
        \   'foo',
        \   'foo',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [[2], [3]])
  normal! G
  normal! .
  call g:assert.equals(getline(1, '$'), [
        \   '',
        \   'foo',
        \   'foo',
        \   'foo',
        \   'foo',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [[4], [5]])
  normal! G
  normal! 3.
  call g:assert.equals(getline(1, '$'), [
        \   '',
        \   'foo',
        \   'foo',
        \   'foo',
        \   'foo',
        \   'foo',
        \   'foo',
        \   'foo',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [[6], [7], [8]])
  normal! G
  normal! .
  call g:assert.equals(getline(1, '$'), [
        \   '',
        \   'foo',
        \   'foo',
        \   'foo',
        \   'foo',
        \   'foo',
        \   'foo',
        \   'foo',
        \   'foo',
        \   'foo',
        \   'foo',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [[9], [10], [11]])
endfunction



function s:suite.register()
  call setline('.', '#')
  call setreg('a', ['foo'], 'c')
  normal "a3p
  call g:assert.equals(getline(1, '$'), ['#foofoofoo'])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [[1, 2, 9]])
  % bwipeout!

  call setline('.', '#')
  execute "normal \"='bar'\<CR>3p"
  call g:assert.equals(getline(1, '$'), ['#barbarbar'])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [[1, 2, 9]])
endfunction
