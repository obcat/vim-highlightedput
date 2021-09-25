# 🌟 vim-highlightedput

[![CI](https://github.com/obcat/vim-highlightedput/workflows/CI/badge.svg)](https://github.com/obcat/vim-highlightedput/actions?query=workflow%3Aci)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE.txt)

Highlight the put text!

![vim-highlightedput-demo](https://user-images.githubusercontent.com/64692680/134232452-04e6546f-8421-462e-a5b4-c578bfd8cbb0.gif)

## Requirements

Vim 8.1.1084 or later.


## Usage

Define these key mappings in your vimrc.

```vim
nmap p <Plug>(highlightedput-p)
xmap p <Plug>(highlightedput-p)
nmap P <Plug>(highlightedput-P)
xmap P <Plug>(highlightedput-P)
nmap gp <Plug>(highlightedput-gp)
xmap gp <Plug>(highlightedput-gp)
nmap gP <Plug>(highlightedput-gP)
xmap gP <Plug>(highlightedput-gP)
nmap ]p <Plug>(highlightedput-]p)
xmap ]p <Plug>(highlightedput-]p)
nmap [P <Plug>(highlightedput-[P)
xmap [P <Plug>(highlightedput-[P)
nmap ]P <Plug>(highlightedput-]P)
xmap ]P <Plug>(highlightedput-]P)
nmap [p <Plug>(highlightedput-[p)
xmap [p <Plug>(highlightedput-[p)
nmap zp <Plug>(highlightedput-zp)
xmap zp <Plug>(highlightedput-zp)
```


## Concept

Just add highlight. Anything else should be exactly the same as buitin put commands.

 - [x] Works fine with a count and/or a register specification.
 - [x] Dot-repeatable (with highlight).


## Customizing

### Highlight duration

```vim
let g:highlightedput_highlight_duration = 1000  " default
```

### Highlight group

```vim
highlight link HighlightedputRegion DiffAdd  " default
```


## Acknowledgments

Thanks to @tm9d for creating [atom-vim-mode-plus](https://github.com/t9md/atom-vim-mode-plus). The project told me that the put operation with highlight is so exciting and inspired me to write this plugin.

Also thanks to @machakann for creating [vim-highlightedyank](https://github.com/machakann/vim-highlightedyank) and [vim-highlightedundo](https://github.com/machakann/vim-highlightedundo) plugin. The name "vim-highlightgedput" is inspired by the plugins, and the author kindly agreed to let me use this name. Also a lot of code is based on the plugins, thank you.


## License

[MIT License](LICENSE.txt)
