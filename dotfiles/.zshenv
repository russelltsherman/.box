
export ZDOTDIR=$HOME
export BOXROOTDIR=$HOME/.box
export BOXFUNCDIR=$BOXROOTDIR/functions

# fpath=($fpath $HOME/.zsh/functions.zsh)
fpath=($fpath $BOXROOTDIR/completions)
typeset -U fpath

if [ -d "$HOME/.box/" ]; then
  export PATH="$PATH:$HOME/.box/bin"
fi
