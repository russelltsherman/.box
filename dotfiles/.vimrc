""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic Setup
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" turn off compatibility mode and enter the new millennium
set nocompatible

syntax enable         " enable syntax highlighting
syntax on             " turn on syntax highlighting
" colorscheme solarized
colorscheme SolarizedDark

filetype plugin on    " If filetype detection was not switched on yet, it will be.
                      " This actually loads the file "ftplugin.vim" in 'runtimepath'.
                      " The result is that when a file is edited its plugin file is
                      " loaded (if there is one for the detected filetypefiletype).
filetype indent on    " If filetype detection was not switched on yet, it will be.
                      " This actually loads the file "indent.vim" in 'runtimepath'.
                      " The result is that when a file is edited its indent file is
                      " loaded (if there is one for the detected filetype).


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lightline config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !has('gui_running')
  set t_Co=256
endif
set laststatus=2
" let g:lightline = { 'colorscheme': 'wombat' }
set noshowmode

autocmd vimenter * NERDTree

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim UI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ruler     " Always show current positions along the bottom
set number    " turn on line numbers

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FINDING FILES:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Provides tab-completion for all file-related tasks
set path+=**     " include all subdirs recursively in file operations

" Display all matching files when we tab complete
set wildmenu

" NOW WE CAN:
" - Hit tab to :find by partial match
" - Use * to make it fuzzy

" THINGS TO CONSIDER:
" - :b lets you autocomplete any open buffer





""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TAG JUMPING:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Create the `tags` file (may need to install ctags first)
command! MakeTags !ctags -R .

" NOW WE CAN:
" - Use ^] to jump to tag under cursor
" - Use g^] for ambiguous tags
" - Use ^t to jump back up the tag stack

" THINGS TO CONSIDER:
" - This doesn't help if you want a visual list of tags





""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AUTOCOMPLETE:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The good stuff is documented in |ins-completion|

" HIGHLIGHTS:
" - ^x^n for JUST this file
" - ^x^f for filenames (works with our path trick!)
" - ^x^] for tags only
" - ^n for anything specified by the 'complete' option

" NOW WE CAN:
" - Use ^n and ^p to go back and forth in the suggestion list





""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FILE BROWSING:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" NOW WE CAN:
" - :edit a folder to open a file browser
" - <CR>/v/t to open in an h-split/v-split/tab
" - check |netrw-browse-maps| for more mappings



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SNIPPETS:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Read an empty HTML template and move cursor to title
noremap ,html :-1read $HOME/.vim/.skeleton.html<CR>3jwf>a

" NOW WE CAN:
" - Take over the world!
"   (with much fewer keystrokes)
