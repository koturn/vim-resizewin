vim-resizewin
=============

Plugin for resizing application window of Vim.


## Usage

- Start fullscreen mode.

```vim
:ResizewinStartFullScreen
```

- Exit fullscreen mode.

```vim
:ResizewinRevertFullScreen
```

- Start resizeing mode. after starting this mode, you can change application
  window size with h, j, k and l keys.

```vim
:ResizewinRevertFullScreen
```


## Sample configuration

```vim
map  <F11>      <Plug>(resizewin-toggle-fullscreen)
map! <F11>      <Plug>(resizewin-toggle-fullscreen)
map  <M-F11>    <Plug>(resizewin-toggle-fullscreen)
map! <M-F11>    <Plug>(resizewin-toggle-fullscreen)
map  <S-Left>   <Plug>(resizewin-contract-columns)
map! <S-Left>   <Plug>(resizewin-contract-columns)
map  <S-Down>   <Plug>(resizewin-expand-lines)
map! <S-Down>   <Plug>(resizewin-expand-lines)
map  <S-Up>     <Plug>(resizewin-contract-lines)
map! <S-Up>     <Plug>(resizewin-contract-lines)
map  <S-Right>  <Plug>(resizewin-expand-columns)
map! <S-Right>  <Plug>(resizewin-expand-columns)
```


## Installation

With [NeoBundle](https://github.com/Shougo/neobundle.vim).

```vim
NeoBundle 'koturn/vim-resizewin'
```

If you want to use ```:NeoBundleLazy```, write following code in your .vimrc.

```vim
NeoBundleLazy 'koturn/vim-resizewin'
if neobundle#tap('vim-resizewin')
  call neobundle#config({
        \ 'on_cmd': [
        \   'Resizewin',
        \   'ResizewinByOffset',
        \   'ResizewinStartFullScreen',
        \   'ResizewinRevertFullScreen',
        \   'ResizewinToggleFullScreen',
        \ ],
        \ 'on_map': '<Plug>(resizewin-',
        \})
  call neobundle#untap()
endif
```

With [Vundle](https://github.com/VundleVim/Vundle.vim).

```vim
Plugin 'koturn/vim-resizewin'
```

With [vim-plug](https://github.com/junegunn/vim-plug).

```vim
Plug 'koturn/vim-resizewin'
```

If you don't want to use plugin manager, put files and directories on
```~/.vim/```, or ```%HOME%/vimfiles/``` on Windows.


## LICENSE

This software is released under the MIT License, see [LICENSE](LICENSE).
