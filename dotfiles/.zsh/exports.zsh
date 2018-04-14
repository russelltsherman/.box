# Setup terminal, and turn on colors
export TERM='xterm-256color'
export CLICOLOR='1'
export LSCOLORS='Gxfxcxdxbxegedabagacad'

# Enable color in grep
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='3;33'

# This resolves issues install the mysql, postgres, and other gems with native non universal binary extensions
export ARCHFLAGS='-arch x86_64'

export LESS='--ignore-case --raw-control-chars'
export PAGER='most'
# CTAGS Sorting in VIM/Emacs is better behaved with this in place
export LC_COLLATE='C'

export GH_API_TOKEN=$(cat ~/.gh_api_token)

export HOMEBREW_CASK_OPTS='--appdir=/Applications'
# GitHub token with no scope, used to get around API limits
export HOMEBREW_GITHUB_API_TOKEN="${GITHUB_API_TOKEN}"

# Set vim as default editor (vi is the default otherwise)
export EDITOR='vim'
