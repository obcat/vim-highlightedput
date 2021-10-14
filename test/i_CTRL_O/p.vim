let s:suite = themis#suite('i_CTRL-O mode: p:')

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
  call setreg('', ['txt'], 'c')
  execute "normal i\<C-o>3p"
  call g:assert.equals(getline(1, '$'), ['#txttxttxt#'])
  sleep 1m
  call g:assert.equals(GetHighlightedPositionList(), [[1, 2, 9]])
  % bwipeout!

  " Check cursor position.
  call setline(1, ['##'])
  call setreg('', ['txt'], 'c')
  execute "normal i\<C-o>3p@"
  call g:assert.equals(getline(1, '$'), ['#txttxttxt@#'])
endfunction
