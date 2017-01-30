source $BOXROOTDIR/dotfiles/.lib_sh/aliases.sh
source $BOXROOTDIR/dotfiles/.lib_sh/dockeraliases.sh
source $BOXROOTDIR/dotfiles/.lib_sh/dockerfunctions.sh
source $BOXROOTDIR/dotfiles/.lib_sh/paths.sh

# add .box/bin to the path
if [ -d "$HOME/.box/" ]; then
  export PATH="$PATH:$HOME/.box/bin"
fi

# initialize NVM
export NVM_DIR=$HOME/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

# initialize RVM
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
export PATH="$GEM_HOME/bin:$PATH" # RVM demands ruby bin is first in path

# initialize thefuck
type thefuck &>/dev/null && eval "$(thefuck --alias)" || # echo "thefuck() not found."

# load iterm2 shell integration if present
if [ -f $HOME/.iterm2_shell_integration.$(basename $SHELL) ];then
  source $HOME/.iterm2_shell_integration.$(basename $SHELL)
fi

# initialize GO
if [ -d $HOME/go ]; then
  export GOPATH=$HOME/go
  export PATH=$PATH:$GOPATH/bin
  alias gotour=$GOPATH/bin/gotour
  export GOROOT=$(go env GOROOT)
fi
