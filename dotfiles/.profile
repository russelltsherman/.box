
# add .box/bin to the path
if [ -d "$HOME/.box/" ]; then
  export PATH="$PATH:$HOME/.box/bin"
fi

# initialize NVM
export NVM_DIR=$HOME/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
