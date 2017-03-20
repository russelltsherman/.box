# add .box/bin to the path
if [ -d "$HOME/.box/" ]; then
  export PATH="$PATH:$HOME/.box/bin"
fi

# load iterm2 shell integration if present
if [ -f $HOME/.iterm2_shell_integration.$(basename $SHELL) ];then
  source $HOME/.iterm2_shell_integration.$(basename $SHELL)
fi

# initialize other shell agnostic customizations
export LIB_SH_DIR=$BOXROOTDIR/dotfiles/.lib_sh
[ -s "$LIB_SH_DIR/aliases.sh" ] && source $LIB_SH_DIR/aliases.sh
[ -s "$LIB_SH_DIR/dockeraliases.sh" ] && source $LIB_SH_DIR/dockeraliases.sh
[ -s "$LIB_SH_DIR/dockerfunctions.sh" ] && source $LIB_SH_DIR/dockerfunctions.sh
[ -s "$LIB_SH_DIR/paths.sh" ] && source $LIB_SH_DIR/paths.sh

# initialize GO
if [ -d $HOME/src/go ]; then
  export GOPATH=$HOME/src/go
  export PATH=$PATH:$GOPATH/bin
  alias gotour=$GOPATH/bin/gotour
  export GOROOT=$(go env GOROOT)
fi

# lazily initialize NVM
export NVM_DIR=$HOME/.nvm
[ -s $NVM_DIR/nvm.sh ] && source $NVM_DIR/nvm.sh

# initialize RVM
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[ -s $HOME/.rvm/scripts/rvm ] && source $HOME/.rvm/scripts/rvm
export PATH="$GEM_HOME/bin:$PATH" # RVM demands ruby bin is first in path

# all this for container based GUI apps
export DISPLAY=:0
export IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
export DOCKER_DISPLAY=$IP:0
/opt/X11/bin/xhost $IP
/opt/X11/bin/xhost -

# initialize thefuck
type thefuck &>/dev/null && eval "$(thefuck --alias)" # || echo "thefuck() not found."
