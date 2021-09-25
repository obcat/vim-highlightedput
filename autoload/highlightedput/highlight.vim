let s:Schedule = vital#highlightedput#new().import('Schedule')
      \.augroup('highlightedput-highlight')
let s:ON = 1
let s:OFF = 0



function highlightedput#highlight#new(winid, group, poslist) abort
  let highlight = deepcopy(s:highlight)
  let highlight.winid = a:winid
  let highlight.bufnr = winbufnr(a:winid)
  let highlight.group = a:group
  let highlight.poslist = a:poslist
  let highlight.quench_task = s:Schedule.Task()
  let highlight.switch_task = s:Schedule.Task()
  return highlight
endfunction




let s:highlight = {
      \   'status': s:OFF,
      \   'winid': 0,
      \   'bufnr': 0,
      \   'group': '',
      \   'poslist': [],
      \   'matchIDs': [],
      \   'quench_task': {},
      \   'switch_task': {},
      \ }


function s:highlight.glow(options) abort
  let duration = get(a:options, 'duration', -1)
  let priority = get(a:options, 'priority', 10)
  if !s:winexists(self.winid) || empty(self.poslist) || duration == 0
    return
  endif

  call self.quench()
  let self.matchIDs += s:matchaddpos(self.group, self.poslist, {
        \   'priority': priority,
        \   'window': self.winid,
        \ })
  let self.status = s:ON

  call self.switch_task.call(self.switch, [], self)
        \.repeat(1)
        \.waitfor([['BufEnter', '*']])

  let triggers = [
        \   ['BufUnload', self.bufnr],
        \   ['BufHidden', self.bufnr],
        \   ['TextChanged', self.bufnr],
        \   ['InsertEnter', self.bufnr],
        \   ['TextChangedI', self.bufnr],
        \ ]
  if duration > 0
    let triggers += [duration]
  endif
  call self.quench_task.call(self.quench, [], self)
        \.repeat(1)
        \.waitfor(triggers)
endfunction




function s:highlight.quench() abort
  if self.status is s:OFF
    return
  endif

  call self.switch_task.cancel()
  call self.quench_task.cancel()
  if s:winexists(self.winid)
    call s:matchdelete_all(self.matchIDs, self.winid)
    call filter(self.matchIDs, 0)
  endif

  let self.status = s:OFF
endfunction




function s:highlight.switch() abort
  let winid = win_getid()
  let bufnr = bufnr('%')
  if winid == self.winid && bufnr != self.bufnr
    call self.quench()
  endif
endfunction




" TODO: Better way?
function s:winexists(winid) abort
  return !empty(filter(getwininfo(), { _, w -> w.winid == a:winid }))
endfunction


function s:matchaddpos(group, poslist, options) abort
  let priority = get(a:options, 'priority', 10)
  let winid = get(a:options, 'window', win_getid())
  let poslist = filter(copy(a:poslist), { _, pos ->
        \ !(type(pos) == v:t_list && len(pos) == 3 && pos[2] == 0) })
  let N = 8  " see :help matchaddpos()
  return map(
        \   range(0, len(poslist) - 1, N),
        \   { _, i -> matchaddpos(a:group, poslist[i : i + N - 1], priority, -1, {'window': winid}) },
        \ )
endfunction


function s:matchdelete_all(matchIDs, ...) abort
  let winid = get(a:000, 0, win_getid())
  return map(copy(a:matchIDs), { _, matchID -> matchdelete(matchID, winid) })
endfunction



function s:default_highlight() abort
  highlight default link HighlightedputRegion DiffAdd
endfunction
call s:default_highlight()


augroup highlightedput-event-ColorScheme
  autocmd!
  autocmd ColorScheme * call s:default_highlight()
augroup END
