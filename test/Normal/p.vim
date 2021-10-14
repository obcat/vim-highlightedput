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
  call setline(1, ['##'])
  setlocal nomodified
  call setreg('', [''], 'c')
  normal 3p
  call g:assert.equals(getline(1, '$'), ['##'])
  call g:assert.true(&l:modified)
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [])
  % bwipeout!

  call setline(1, ['##'])
  call setreg('', ['txt'], 'c')
  normal 3p
  call g:assert.equals(getline(1, '$'), ['#txttxttxt#'])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [[1, 2, 9]])
  % bwipeout!

  call setline(1, ['##'])
  call setreg('', [
        \   'txt',
        \   '',
        \ ], 'c')
  normal 3p
  call g:assert.equals(getline(1, '$'), [
        \   '#txt',
        \   'txt',
        \   'txt',
        \   '#',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [1, 2, 4],
        \   [2, 1, 4],
        \   [3, 1, 4],
        \ ])
  % bwipeout!

  call setline(1, ['##'])
  call setreg('', [
        \   '',
        \   'txt',
        \ ], 'c')
  normal 3p
  call g:assert.equals(getline(1, '$'), [
        \   '#',
        \   'txt',
        \   'txt',
        \   'txt#',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [1, 2, 1],
        \   [2, 1, 4],
        \   [3, 1, 4],
        \   [4, 1, 3],
        \ ])
  % bwipeout!

  call setline(1, ['##'])
  call setreg('', [
        \   'txt',
        \   'Nadim',
        \ ], 'c')
  normal 3p
  call g:assert.equals(getline(1, '$'), [
        \   '#txt',
        \   'Nadimtxt',
        \   'Nadimtxt',
        \   'Nadim#',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [1, 2, 4],
        \   [2, 1, 9],
        \   [3, 1, 9],
        \   [4, 1, 5],
        \ ])
  % bwipeout!

  call setline(1, ['##'])
  call setreg('', [
        \   'version',
        \   'Bidirectional',
        \   'Nadim',
        \   'txt',
        \   'arabicshape',
        \ ], 'c')
  normal 7p
  call g:assert.equals(getline(1, '$'), [
        \   '#version',
        \   'Bidirectional',
        \   'Nadim',
        \   'txt',
        \   'arabicshapeversion',
        \   'Bidirectional',
        \   'Nadim',
        \   'txt',
        \   'arabicshapeversion',
        \   'Bidirectional',
        \   'Nadim',
        \   'txt',
        \   'arabicshapeversion',
        \   'Bidirectional',
        \   'Nadim',
        \   'txt',
        \   'arabicshapeversion',
        \   'Bidirectional',
        \   'Nadim',
        \   'txt',
        \   'arabicshapeversion',
        \   'Bidirectional',
        \   'Nadim',
        \   'txt',
        \   'arabicshapeversion',
        \   'Bidirectional',
        \   'Nadim',
        \   'txt',
        \   'arabicshape#',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [1, 2, 8],
        \   [2, 1, 14],
        \   [3, 1, 6],
        \   [4, 1, 4],
        \   [5, 1, 19],
        \   [6, 1, 14],
        \   [7, 1, 6],
        \   [8, 1, 4],
        \   [9, 1, 19],
        \   [10, 1, 14],
        \   [11, 1, 6],
        \   [12, 1, 4],
        \   [13, 1, 19],
        \   [14, 1, 14],
        \   [15, 1, 6],
        \   [16, 1, 4],
        \   [17, 1, 19],
        \   [18, 1, 14],
        \   [19, 1, 6],
        \   [20, 1, 4],
        \   [21, 1, 19],
        \   [22, 1, 14],
        \   [23, 1, 6],
        \   [24, 1, 4],
        \   [25, 1, 19],
        \   [26, 1, 14],
        \   [27, 1, 6],
        \   [28, 1, 4],
        \   [29, 1, 11],
        \ ])
  % bwipeout!
endfunction



function s:suite.line()
  call setline(1, [
        \   '#',
        \   '#',
        \ ])
  call setreg('', ['txt'], 'l')
  normal 3p
  call g:assert.equals(getline(1, '$'), [
        \   '#',
        \   'txt',
        \   'txt',
        \   'txt',
        \   '#',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [2],
        \   [3],
        \   [4],
        \ ])
endfunction



function s:suite.block()
  call setline(1, [
        \   '',
        \   '',
        \   '',
        \ ])
  call setreg('', [
        \   '8',
        \   '22',
        \   'txt',
        \ ], 'b')
  normal 3p
  call g:assert.equals(getline(1, '$'), [
        \   '8  8  8',
        \   '22 22 22',
        \   'txttxttxt',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
       \   [1, 1, 7],
       \   [2, 1, 8],
       \   [3, 1, 9],
       \ ])
  % bwipeout!

  call setline(1, [
        \   '#',
        \   '#',
        \   '#',
        \ ])
  call setreg('', [
        \   '8',
        \   '22',
        \   'txt',
        \ ], 'b')
  normal 3p
  call g:assert.equals(getline(1, '$'), [
        \   '#8  8  8',
        \   '#22 22 22',
        \   '#txttxttxt',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
       \   [1, 2, 7],
       \   [2, 2, 8],
       \   [3, 2, 9],
       \ ])
  % bwipeout!

  call setline(1, [
        \   '##',
        \   '##',
        \   '##',
        \ ])
  call setreg('', [
        \   '8',
        \   '22',
        \   'txt',
        \ ], 'b')
  normal 3p
  call g:assert.equals(getline(1, '$'), [
        \   '#8  8  8  #',
        \   '#22 22 22 #',
        \   '#txttxttxt#',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
       \   [1, 2, 9],
       \   [2, 2, 9],
       \   [3, 2, 9],
       \ ])
  % bwipeout!

  call setline(1, [
        \   '',
        \   '',
        \   '',
        \ ])
  call setreg('', [
        \   '',
        \   '8',
        \   '22',
        \ ], 'b')
  normal p
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
        \   '',
        \   '8',
        \   '22',
        \ ], 'b')
  normal p
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
        \   '',
        \   '8',
        \   '22',
        \ ], 'b')
  normal p
  call g:assert.equals(getline(1, '$'), [
        \   '#  #',
        \   '#8 #',
        \   '#22#',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
       \   [1, 2, 2],
       \   [2, 2, 2],
       \   [3, 2, 2],
       \ ])
endfunction



function s:suite.dot_repeat_line()
  call setline(1, [
        \   '#',
        \   '#',
        \ ])
  call setreg('', ['txt'], 'l')
  normal 2p
  call g:assert.equals(getline(1, '$'), [
        \   '#',
        \   'txt',
        \   'txt',
        \   '#',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [2],
        \   [3],
        \ ])
  normal! .
  call g:assert.equals(getline(1, '$'), [
        \   '#',
        \   'txt',
        \   'txt',
        \   'txt',
        \   'txt',
        \   '#',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [3],
        \   [4],
        \ ])
  normal! 3.
  call g:assert.equals(getline(1, '$'), [
        \   '#',
        \   'txt',
        \   'txt',
        \   'txt',
        \   'txt',
        \   'txt',
        \   'txt',
        \   'txt',
        \   '#',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [4],
        \   [5],
        \   [6],
        \ ])
  normal! .
  call g:assert.equals(getline(1, '$'), [
        \   '#',
        \   'txt',
        \   'txt',
        \   'txt',
        \   'txt',
        \   'txt',
        \   'txt',
        \   'txt',
        \   'txt',
        \   'txt',
        \   'txt',
        \   '#',
        \ ])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [
        \   [5],
        \   [6],
        \   [7],
        \ ])
endfunction



function s:suite.register()
  call setline(1, ['##'])
  call setreg('a', ['txt'], 'c')
  normal "ap
  call g:assert.equals(getline(1, '$'), ['#txt#'])
  % bwipeout!

  call setline(1, ['##'])
  execute "normal \"='Nadim'\<CR>p"
  call g:assert.equals(getline(1, '$'), ['#Nadim#'])
endfunction
