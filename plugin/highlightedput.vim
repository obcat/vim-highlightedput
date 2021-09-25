if exists('g:loaded_highlightedput')
  finish
endif
let g:loaded_highlightedput = 1


nnoremap <expr> <Plug>(highlightedput-p) highlightedput#setup(mode(1), 'p') . 'g@l'
xnoremap <expr> <Plug>(highlightedput-p) highlightedput#setup(mode(1), 'p') . 'g@'
nnoremap <expr> <Plug>(highlightedput-P) highlightedput#setup(mode(1), 'P') . 'g@l'
xnoremap <expr> <Plug>(highlightedput-P) highlightedput#setup(mode(1), 'P') . 'g@'
nnoremap <expr> <Plug>(highlightedput-gp) highlightedput#setup(mode(1), 'gp') . 'g@l'
xnoremap <expr> <Plug>(highlightedput-gp) highlightedput#setup(mode(1), 'gp') . 'g@'
nnoremap <expr> <Plug>(highlightedput-gP) highlightedput#setup(mode(1), 'gP') . 'g@l'
xnoremap <expr> <Plug>(highlightedput-gP) highlightedput#setup(mode(1), 'gP') . 'g@'
nnoremap <expr> <Plug>(highlightedput-]p) highlightedput#setup(mode(1), ']p') . 'g@l'
xnoremap <expr> <Plug>(highlightedput-]p) highlightedput#setup(mode(1), ']p') . 'g@'
nnoremap <expr> <Plug>(highlightedput-[P) highlightedput#setup(mode(1), '[P') . 'g@l'
xnoremap <expr> <Plug>(highlightedput-[P) highlightedput#setup(mode(1), '[P') . 'g@'
nnoremap <expr> <Plug>(highlightedput-]P) highlightedput#setup(mode(1), ']P') . 'g@l'
xnoremap <expr> <Plug>(highlightedput-]P) highlightedput#setup(mode(1), ']P') . 'g@'
nnoremap <expr> <Plug>(highlightedput-[p) highlightedput#setup(mode(1), '[p') . 'g@l'
xnoremap <expr> <Plug>(highlightedput-[p) highlightedput#setup(mode(1), '[p') . 'g@'
if has('patch-8.2.2914')
  nnoremap <expr> <Plug>(highlightedput-zp) highlightedput#setup(mode(1), 'zp') . 'g@l'
  xnoremap <expr> <Plug>(highlightedput-zp) highlightedput#setup(mode(1), 'zp') . 'g@'
  nnoremap <expr> <Plug>(highlightedput-zP) highlightedput#setup(mode(1), 'zP') . 'g@l'
  xnoremap <expr> <Plug>(highlightedput-zP) highlightedput#setup(mode(1), 'zP') . 'g@'
else
  nnoremap <Plug>(highlightedput-zp) :<C-u>echoerr 'highlightedput: Sorry, the key mapping is not available in this version'<CR>
  xnoremap <Plug>(highlightedput-zp) :<C-u>echoerr 'highlightedput: Sorry, the key mapping is not available in this version'<CR>
  nnoremap <Plug>(highlightedput-zP) :<C-u>echoerr 'highlightedput: Sorry, the key mapping is not available in this version'<CR>
  xnoremap <Plug>(highlightedput-zP) :<C-u>echoerr 'highlightedput: Sorry, the key mapping is not available in this version'<CR>
endif
