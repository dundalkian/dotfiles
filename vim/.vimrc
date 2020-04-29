" No audio bells, enables visual bell 
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

" Enabling this will make the tab key (in insert mode) insert spaces instead of tab characters. This also affects the behavior of the retab command.
set expandtab

" The width of a hard tabstop measured in "spaces" -- effectively the (maximum) width of an actual tab character.
set tabstop=4

" Setting this to a non-zero value other than tabstop will make the tab key (in insert mode) insert a combination of spaces (and possibly tabs) to simulate tab stops at this width.
set softtabstop=4

" The size of an "indent". It's also measured in spaces, so if your code base indents with tab characters then you want shiftwidth to equal the number of tab characters times tabstop. This is also used by things like the =, > and < commands.
set shiftwidth=4

" Enabling this will make the tab key (in insert mode) insert spaces or tabs to go to the next indent of the next tabstop when the cursor is at the beginning of a line (i.e. the only preceding characters are whitespace).
set smarttab

set number
set relativenumber
set incsearch

" Pasting from X11 clipboard is much better in this mode
set paste
" Basic stuff above

" This snippet will automatically install vim-plug if not aleady available
"if empty(glob('~/.vim/autoload/plug.vim'))
"  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
"endif

" Plugins below, using vim-plug, a minimalistic vim plugin manager
"call plug#begin('~/.vim/pllugged')
"Plug 'dylanaraps/wal.vim'
"call plug#end()

" make sure specific filetypes are recognized correctly
"autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff

" Call the 'groff_compile' command, redraws the screen after external cmd
"function! SaveGroff()
"    silent !groff_compile %
"    redraw!
"endfunction

" Paired with SaveGroff function, this waits for writes to files with groff
" macro-set extensions
"augroup groff
"    autocmd!
"    au BufWritePost *.ms,*.me,*.mom,*.man call SaveGroff()
"augroup END

"colorscheme wal
