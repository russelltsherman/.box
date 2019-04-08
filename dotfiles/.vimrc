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
" colorscheme SolarizedDark " Change color scheme.
colorscheme gruvbox

filetype plugin on    " If filetype detection was not switched on yet, it will be.
                      " This actually loads the file "ftplugin.vim" in 'runtimepath'.
                      " The result is that when a file is edited its plugin file is
                      " loaded (if there is one for the detected filetypefiletype).
filetype indent on    " If filetype detection was not switched on yet, it will be.
                      " This actually loads the file "indent.vim" in 'runtimepath'.
                      " The result is that when a file is edited its indent file is
                      " loaded (if there is one for the detected filetype).

set ai                " auto indent
set si                " smart indent
set history=1000      " keep 1000 items in history

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lightline config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !has('gui_running')
  set t_Co=256
endif
" let g:lightline = { 'colorscheme': 'wombat' }
set noshowmode

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gruvbox config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark    " Setting dark mode
" set background=light   " Setting light mode

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" search
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hlsearch      " Enable search highlighting.
set ignorecase    " Ignore case when searching.
set incsearch     " Incremental search that shows partial matches.
set smartcase     " Automatically switch search to case-sensitive when search query contains an uppercase letter.

" autocmd vimenter * NERDTree

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim UI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set cursorline        " Highlight the line currently under cursor.
" set foldmethod=indent " Fold based on indention levels.
" set foldnestmax=3     " Only fold up to three nested levels.
set laststatus=2      " Always display the status bar.
set mouse=a           " Enable mouse for scrolling and resizing.
set number            " turn on line numbers
" set noerrorbells      " Disable beep on errors.
" set relativenumber    " Show line number on the current line and relative numbers on all other lines.
set ruler             " Always show current positions along the bottom
" set tabpagemax=50     " Maximum number of tab pages that can be opened from the command line.
set title             " Set the window’s title, reflecting the file currently being edited.
" set visualbell        " Flash the screen instead of beeping on errors.
" set wildmenu          " Display command line’s tab complete options as a menu.

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
