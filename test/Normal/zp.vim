let s:suite = themis#suite('Normal mode: zp:')

function s:suite.before()
endfunction

function s:suite.before_each() abort
  call DeleteAllRegisters()
  % bwipeout!
endfunction

function s:suite.after()
  call s:suite.before_each()
endfunction


function s:suite.block()
  if !has('patch-8.2.2914')
    call g:assert.skip('skiped')
  endif

  call setline(1, [
        \   '',
        \   '',
        \   '',
        \ ])
  call setreg('', [
        \  '8',
        \  '22',
        \  'txt',
        \ ], 'b')
  normal 3zp
  call g:assert.equals(getline(1, '$'), [
        \   '888',
        \   '222222',
        \   'txttxttxt',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [1, 1, 3],
        \   [2, 1, 6],
        \   [3, 1, 9],
        \ ])
  % bwipeout!

  call setline(1, [
        \   '#',
        \   '#',
        \   '#',
        \ ])
  call setreg('', [
        \  '8',
        \  '22',
        \  'txt',
        \ ], 'b')
  normal 3zp
  call g:assert.equals(getline(1, '$'), [
        \   '#888',
        \   '#222222',
        \   '#txttxttxt',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [1, 2, 3],
        \   [2, 2, 6],
        \   [3, 2, 9],
        \ ])
  % bwipeout!

  call setline(1, [
        \   '##',
        \   '##',
        \   '##',
        \ ])
  call setreg('', [
        \  '8',
        \  '22',
        \  'txt',
        \ ], 'b')
  normal 3zp
  call g:assert.equals(getline(1, '$'), [
        \   '#888#',
        \   '#222222#',
        \   '#txttxttxt#',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [1, 2, 3],
        \   [2, 2, 6],
        \   [3, 2, 9],
        \ ])
  % bwipeout!

  call setline(1, [
        \   '',
        \   '',
        \   '',
        \ ])
  call setreg('', [
        \  '',
        \  '8',
        \  '22',
        \ ], 'b')
  normal zp
  call g:assert.equals(getline(1, '$'), [
        \   '',
        \   '8',
        \   '22',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [2, 1, 1],
        \   [3, 1, 2],
        \ ])
  % bwipeout!

  call setline(1, [
        \   '#',
        \   '#',
        \   '#',
        \ ])
  call setreg('', [
        \  '',
        \  '8',
        \  '22',
        \ ], 'b')
  normal zp
  call g:assert.equals(getline(1, '$'), [
        \   '#',
        \   '#8',
        \   '#22',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [2, 2, 1],
        \   [3, 2, 2],
        \ ])
  % bwipeout!

  call setline(1, [
        \   '##',
        \   '##',
        \   '##',
        \ ])
  call setreg('', [
        \  '',
        \  '8',
        \  '22',
        \ ], 'b')
  normal zp
  call g:assert.equals(getline(1, '$'), [
        \   '##',
        \   '#8#',
        \   '#22#',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [2, 2, 1],
        \   [3, 2, 2],
        \ ])
endfunction
