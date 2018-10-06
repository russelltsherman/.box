#!/usr/bin/env bash

# add my local bin to start of path
export PATH=$HOME/bin:$PATH
# export PATH=$PATH:.
#export PATH=$PATH:~/.dotfiles/scripts

#Brew
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH

# GO
#export PATH=$PATH:/usr/local/opt/go/libexec/bin

# The next line updates PATH for the Google Cloud SDK.
#source "/Users/$(whoami)/Downloads/google-cloud-sdk/path.zsh.inc"

# The next line enables shell command completion for gcloud.
#source "/Users/$(whoami)/Downloads/google-cloud-sdk/completion.zsh.inc"

# Currently this path is appendend to dynamically when picking a ruby version
# export PATH=node_modules/.bin:/usr/local/sbin:/usr/local/bin:/usr/local/share/npm/bin:~/.cabal/bin:~/.local/bin:$PATH
# export PATH=$PATH:/opt/boxen/homebrew/opt/go/libexec/bin
