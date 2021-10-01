let s:mode = ''
let s:put_cmd = ''
let s:counter = 0  " for dot repeat
let s:highlight_timer = -1
let s:last_put_info = {
      \  'regtype': '',
      \  'regcontents': '',
      \  'count': 0,
      \  'put_cmd': '',
      \ }


function highlightedput#setup(mode, put_cmd) abort
  let s:mode = a:mode
  let s:put_cmd = a:put_cmd
  let s:counter = 0
  set operatorfunc=highlightedput#put_and_highlight
  return ''
endfunction


function highlightedput#put_and_highlight(motion_wise) abort
  let s:counter += 1

  let mode = s:mode
  let put_cmd = s:put_cmd
  let invoked_by_dot = s:counter >= 2
  let l:count = v:count1
  let regname = v:register
  let regtype = getregtype(v:register)
  let regcontents = s:getregcontents(v:register)
  let motion_wise = a:motion_wise
  let motion_range = [getpos("'[")[1 : 2], getpos("']")[1 : 2]]


  " Put the text.
  let lazyredraw = &lazyredraw
  set nolazyredraw
  try
    if s:is_Normal(mode)
      let error = s:put(regname, l:count, put_cmd)
    elseif s:is_Visual(mode)
      if invoked_by_dot
        let error = s:delete_range(motion_wise, motion_range)
      else
        normal! gv
        let error = s:put(regname, l:count, put_cmd)
      endif
    else
      throw 'highlightedput: Unexpected mode:' mode
    endif
  finally
    let &lazyredraw = lazyredraw
  endtry

  " Fix cursor position.
  " FIXME: Maybe wrong way.  FIXME: Consider dot repeat.
  if s:is_i_CTRL_O_Normal(mode) && !invoked_by_dot && getpos('.') == getpos("']")
    let virtualedit = &virtualedit
    let whichwrap = &whichwrap
    set virtualedit=onemore
    set whichwrap=
    try
      normal! l
    finally
      let &virtualedit = virtualedit
      let &whichwrap = whichwrap
    endtry
  endif


  if error || s:is_Visual(mode) && invoked_by_dot
    " Should not add highlight.
    return
  endif


  " Add highlight later. {{{
  "
  "     After adding highlight, we will subscribe TextChanged event and delete
  "     highlight when it is fired.  But TextChanged by the put command we
  "     have executed above is fired when this operator function is finished.
  "     So adding highlight now means it will deleted imediately.
  "
  " }}}
  if s:highlight_timer != -1
    call timer_stop(s:highlight_timer)
  endif

  let s:last_put_info = {
        \  'regtype': regtype,
        \  'regcontents': regcontents,
        \  'count': l:count,
        \  'put_cmd': put_cmd,
        \ }
  let snapshot = s:get_snapshot()

  let s:highlight_timer = timer_start(1, { ->
        \   s:get_snapshot() == snapshot ? s:highlight() : 'Nop'
        \ })
endfunction




function s:highlight() abort
  let s:highlight_timer = -1

  let hi_duration = s:getvar('highlight_duration', 500)
  if hi_duration == 0
    return
  endif

  let hi_maxheight = s:getvar('highlight_maxheight', 10000)
  " TODO: '] mark is misplaced sometimes so actually we should not use here.
  "        Ref: https://github.com/vim/vim/issues/8899
  let region_height = line("']") - line("'[") + 1
  if !(hi_maxheight < 0 || region_height <= hi_maxheight)
    return
  endif

  let type = s:last_put_info.regtype
  let mod_start = getpos("'[")[1 : 2]
  let mod_end = getpos("']")[1 : 2]
  let unit = s:last_put_info.regcontents
  let number_of_units = s:last_put_info.count
  let was_put_by = s:last_put_info.put_cmd

  let poslist = s:get_poslist(type, mod_start, mod_end, unit, number_of_units, was_put_by)
  if empty(poslist)
    return
  endif

  call s:current_highlight.quench()
  let new_highlight = highlightedput#highlight#new(
        \   win_getid(), 'HighlightedputRegion', poslist,
        \ )
  call new_highlight.glow({
        \   'duration': hi_duration,
        \   'priority': s:getvar('highlight_priority', 10),
        \ })
  let s:current_highlight = new_highlight
endfunction




let s:current_highlight = highlightedput#highlight#new(0, '', [])




" Execute a put command.
" If the expression register is given, use the previous expression.
function s:put(regname, count, put_cmd) abort
  if a:regname ==# '='
    try
      execute printf("normal! \"=\<CR>%s%s", a:count, a:put_cmd)
      echo ''
    catch /.*/
      call s:error(substitute(v:exception, '^Vim\%((\a\+)\)\=:', 'highlightedput: ', ''))
      return 1
    endtry
    return 0
  else
    try
      execute printf('normal! "%s%s%s', a:regname, a:count, a:put_cmd)
    catch /^Vim\%((\a\+)\)\=:\%(E21\|E353\)/
      call s:error(substitute(v:exception, '^Vim\%((\a\+)\)\=:', 'highlightedput: ', ''))
      return 1
    endtry
    return 0
  endif
endfunction




" Delete a range.
" Does not overwrite current informations on Visual mode.
" The deleted text will be stored in the unnamed register.
function s:delete_range(motion_wise, motion_range)
  let visual_mode = visualmode()
  let visual_start = getpos("'<")
  let visual_end = getpos("'>")
  let v = s:motion_wise_2_visual_command(a:motion_wise)
  call cursor(a:motion_range[0])
  execute 'normal!' v
  call cursor(a:motion_range[1])
  try
    normal! d
  catch /^Vim\%((\a\+)\)\=:E21/
    call s:error(substitute(v:exception, '^Vim\%((\a\+)\)\=:', 'highlightedput: ', ''))
    return 1
  finally
    " restore visual mode
    if visual_mode ==# ''
      call visualmode(1)
    else
      execute 'normal!' visual_mode
      execute 'normal!' "\<Esc>"
    endif
    " restore visual marks
    call setpos("'<", visual_start)
    call setpos("'>", visual_end)
  endtry
  return 0
endfunction



function s:getregcontents(regname) abort
  if a:regname ==# '='
    try
      return split(getreg('=', 0), '\n')
    catch /.*/
      return []
    endtry
  else
    return getreg(a:regname, 1, 1)
  endif
endfunction


function s:motion_wise_2_visual_command(motion_wise) abort
  if a:motion_wise ==# 'line'
    return 'V'
  elseif a:motion_wise ==# 'char'
    return 'v'
  elseif a:motion_wise ==# 'block'
    return "\<C-v>"
  else
    throw 'highlightedput: Unknown motion wise:' a:motion_wise
  endif
endfunction


function s:is_Normal(mode) abort
  return a:mode[0] ==# 'n'
endfunction


function s:is_Visual(mode) abort
  return index(['v', 'V', "\<C-v>"], a:mode[0]) >= 0
endfunction


function s:is_i_CTRL_O_Normal(mode) abort
  return a:mode[0 : 1] ==# 'ni'
endfunction


function s:get_snapshot()
  return [win_getid(), bufnr('%'), b:changedtick]
endfunction


function s:getvar(name, default) abort
  let fullname = 'highlightedput_' . a:name
  return get(b:, fullname, get(g:, fullname, a:default))
endfunction


function s:error(msg) abort
  echohl ErrorMsg
  try
    for line in split(a:msg, "\n")
      echomsg line
    endfor
  finally
    echohl None
  endtry
endfunction






function s:get_poslist(type, mod_start, mod_end, unit, number_of_units, was_put_by)
  if a:type ==# 'v'
    return s:get_poslist_char(a:mod_start, a:mod_end, a:unit, a:number_of_units, a:was_put_by)
  elseif a:type ==# 'V'
    return s:get_poslist_line(a:mod_start, a:mod_end, a:unit, a:number_of_units, a:was_put_by)
  elseif a:type[0] ==# "\<C-v>"
    return s:get_poslist_block(a:mod_start, a:mod_end, a:unit, a:number_of_units, a:was_put_by)
  else
    throw 'highlightedput: Invalid region type:' a:type
  endif
endfunction




" NOTE: '] mark (mod_end) is not reliable. {{{
"
"       If the put characters contain line break(s), '] mark is always set
"       to the end of the first unit regardless of the count.  Try this:
"
"             1. Yank foo^Jbar (^J is a line break).
"             2. Type 3p to put it.
"             3. Type `] to try to jump to the end.
"             4. Oh My God.
"
"       TODO: Report this issue to vim_dev.
"
" }}}
" NOTE: Highlight may be broken if we use different forms for postions. {{{
"
"       For example, this position list should be valid but causes broken
"       highlight sometimes (why?):
"
"         let poslist = [
"               \   [2, 10, 30],
"               \   3, 4, 5,
"               \   [8, 1, 15],
"               \ ]
"
"       So we need use the same form for all positions:
"
"         let poslist = [
"               \   [2, 10, 30],
"               \   [3, 1, 22],
"               \   [4, 1, 30],
"               \   [5, 1, 10],
"               \   [8, 1, 15],
"               \ ]
"
"       TODO: Report this issue to vim_dev once coming up with a minimal
"             reproduce steps.
" }}}
function! s:get_poslist_char(mod_start, mod_end, unit, number_of_units, was_put_by) abort
  let poslist = []
  let unit_height = len(a:unit)
  if unit_height == 0  " for safe
    return poslist
  endif
  let [start_lnum, start_col] = a:mod_start
  let end_lnum = start_lnum + unit_height * a:number_of_units - a:number_of_units
  if start_lnum == end_lnum  " iff unit_height == 1
    if a:unit[0] !=# ''
      let poslist += [[start_lnum, start_col, strlen(a:unit[0]) * a:number_of_units]]
    endif
    return poslist
  else
    let poslist += a:unit[0] ==# ''
          \ ? [[start_lnum, col([start_lnum, '$']), 1]]
          \ : [[start_lnum, start_col, strlen(a:unit[0]) + 1]]
  endif
  let length_candidates = map(range(1, unit_height - 2), { _, v -> strlen(a:unit[v]) + 1 })
        \  + [strlen(a:unit[-1] . a:unit[0]) + 1]
  let poslist += map(
        \   range(start_lnum + 1, end_lnum - 1),
        \   { i, l -> [l, 1, length_candidates[i % (unit_height - 1)]] },
        \ )
  if a:unit[-1] != ''
    let poslist += [[end_lnum, 1, strlen(a:unit[-1])]]
  endif
  return poslist
endfunction




function s:get_poslist_line(mod_start, mod_end, unit, number_of_units, was_put_by) abort
  let start_lnum = a:mod_start[0]
  let end_lnum = a:mod_end[0]
  let poslist = range(start_lnum, end_lnum)
  return poslist
endfunction




function! s:get_poslist_block(mod_start, mod_end, unit, number_of_units, was_put_by) abort
  let poslist = []
  let [start_lnum, start_col] = a:mod_start
  let [end_lnum, end_col] = a:mod_end
  let view = winsaveview()
  let virtualedit = &virtualedit
  set virtualedit=all
  try
    call cursor([start_lnum, start_col])
    if col('.') == 1
      let leftside_vcol = 1
    else
      normal! h
      let leftside_vcol = virtcol('.') + 1
    endif
    if a:was_put_by ==# 'zp' || a:was_put_by ==# 'zP'
      for lnum in range(start_lnum, end_lnum)
        execute lnum
        execute printf('normal! %s|', leftside_vcol)
        let position = [lnum, 0, 0]
        let position[1] = col('.')
        let position[2] = strlen(a:unit[lnum - start_lnum]) * a:number_of_units
        let poslist += [position]
      endfor
    else  " a:was_put_by ==# 'p' || a:was_put_by ==# 'P' || ...
      let blockwidth = max(map(copy(a:unit), { _, line ->
            \ strdisplaywidth(line, leftside_vcol - 1) })) * a:number_of_units
      let rightside_vcol = leftside_vcol + blockwidth - 1
      for lnum in range(start_lnum, end_lnum)
        execute lnum
        execute printf('normal! %s|', leftside_vcol)
        let position = [lnum, 0, 0]
        let position[1] = col('.')
        execute printf('normal! %s|', rightside_vcol)
        let char = s:get_char_under_cursor()
        let position[2] = col('.') + strlen(char) - position[1]
        let poslist += [position]
      endfor
    endif
  finally
    let &virtualedit = virtualedit
    call winrestview(view)
  endtry
  return poslist
endfunction



" Ref: https://eagletmt.hatenadiary.org/entry/20100623/1277289728
function! s:get_char_under_cursor() abort
  return matchstr(getline('.'), '.', col('.') - 1)
endfunction
