# Setup terminal, and turn on colors
export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

# Enable color in grep
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='3;33'

# This resolves issues install the mysql, postgres, and other gems with native non universal binary extensions
export ARCHFLAGS='-arch x86_64'

export LESS='--ignore-case --raw-control-chars'
export PAGER='most'
export PYTHONPATH=/usr/local/lib/python2.6/site-packages
# CTAGS Sorting in VIM/Emacs is better behaved with this in place
export LC_COLLATE=C

export HOMEBREW_CASK_OPTS="--appdir=/Applications"
# GitHub token with no scope, used to get around API limits
export HOMEBREW_GITHUB_API_TOKEN=$(cat ~/.gh_api_token)

# Set vim as default editor (vi is the default otherwise)
export EDITOR="vim"

# #########################################################################
# # Temporary aliases useful for demos, other current projects
# #########################################################################
# export MYTEMP=~/Documents/Temp
# export MYCODE=~/Documents/Code
# export MYSCRATCH=~/Documents/Temp/Scratch
# export MYDOWNLOADS=~/Downloads
# export MYDOCUMENTS=~/Documents
# export MYDEVAPPS=/Applications/Dev

#########################################################################
# Tool paths
#########################################################################
#export CLOJURE_HOME=/Applications/Dev/clojure
#export EC2_HOME=/Applications/Dev/ec2-api-tools-1.3-46266
#export JAVA_HOME=/Library/Java/Home
#export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home
#export GOPATH=/usr/local/bin
#export GROOVY_HOME=/usr/local/opt/groovy/libexec

# #########################################################################
# # Tool settings
# #########################################################################
# export FONTCONFIG_PATH=/opt/X11/lib/X11/fontconfig
# export NVM_DIR=~/.nvm
