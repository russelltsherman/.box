# VIM TMUX refs

- vimtutor

- [Thoughtbot]
  - [Vim Navigation Commands](https://www.youtube.com/watch?v=Qem8cpbJeYc)
  - [Let VIM do the typing](https://www.youtube.com/watch?v=3TX3kV3TICU)
  - [Improving Vim Speed](https://www.youtube.com/watch?v=OnUiHLYZgaA)
  - [Do 90% of What Plugins Do (With Just Vim)](https://www.youtube.com/watch?v=XA2WjJbmmoM)
  - [Learn Vim in a Week](https://www.youtube.com/watch?v=_NUO4JEtkDw)
  - [tpopes config and plugins](https://www.youtube.com/watch?v=MGmIJyTf8pg)

- [Nick Nisi]
  - `https://github.com/nicknisi/dotfiles`
  - `https://github.com/nicknisi/vim-workshop`
  - `https://www.youtube.com/watch?v=5r6yzFEXajQ`

- [ColbyCheeZe]
  - `http://www.colbycheeze.com/blog/2015/02/level-up-your-workflow-with-vim-and-tmux.html`
  - `https://github.com/colbycheeze/dotfiles`
  - `https://www.youtube.com/watch?v=YD9aFIvlQYs`

- [SteveLosh]
  - `http://learnvimscriptthehardway.stevelosh.com/`

- [Hermann Vocke]
  - `http://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/`

## vim high-value plugins

Full path fuzzy file, buffer, mru, tag, ... finder for Vim.

- `https://github.com/ctrlpvim/ctrlp.vim`

A tree explorer plugin for vim.

- `https://github.com/scrooloose/nerdtree`

Vim plugin for the_silver_searcher, 'ag', a replacement for the Perl module / CLI script 'ack'

- `https://github.com/rking/ag.vim`

rails.vim: Ruby on Rails power tools

- `https://github.com/tpope/vim-rails`

Run Rspec specs from Vim

- `https://github.com/thoughtbot/vim-rspec`

i: insert before current character
I: insert before all current line characters (sans whitespace)
a: insert after current character
A: insert after all current line characters
r: replace current character (or each visually selected char)
R: enter replace mode
s: strike current character with following inserted text
S: strike entire line with following inserted text
h: move cursor left
H: "high" == top of screen == all the way "left" on the screen
l: move cursor right
L: "low" == bottom of screen == all the way "right" on the screen

    (okay, these two were a stretch/coincidence ;)

v: visual stream mode
V: visual line mode (expands per-char concept to per-line)
w: next beginning of word
W: next beginning of word, delimited only by whitespace
e: next end of a word
E: next end of a word, delimited only by whitespace
n: previous beginning of a word
N: previous beginning of a word, delimited only by whitespace
ge: previous end of a word
gE: previous end of a word, delimited only by whitespace

same with text objects: iw/iW/aw/aW/ip/iP/ap/aP

There's another subset of commands wherein the shifted versions reverse direction:
fn: forward onto n
Fn: backward onto n
tn: to/till n
Tn: backward to/till n
n: next search match
N: previous search match
o: "open" a new line below the current one
O: open a new line above the current one
p: put after the cursor
P: put before the cursor
x: delete char after left edge of cursor (current char)
X: delete char before left edge of cursor
    (note here that Vim is really always working from cursor's left edge)
/: search forward
?: (shifted /) search backward

There's a third subset of commands wherein the shifted versions are synonymous with n$, where n is the command, and $ means "to the end of the line", but it's still the same command (it just skips adding the $ motion after the command):

d: delete from current position to/through next motion/text object/etc
D: delete from current position to end of line
c: change from current position to/through next motion/text object/etc
C: change from current position to end of line
y: yank from current position to/through next motion/text object/etc
Y: WTF!? :)
