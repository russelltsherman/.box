
#set this value so that antigen realizes it's in a nonstandard location
export ADOTDIR=$BOXROOTDIR/.antigen

source $BOXROOTDIR/.antigen/antigen.zsh

# Antigen - zsh plugin manager
# https://github.com/zsh-users/antigen
# https://joshldavis.com/2014/07/26/oh-my-zsh-is-a-disease-antigen-is-the-vaccine/

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
# antigen bundle aws
# antigen bundle brew
# antigen bundle bundler
# antigen bundle colored-man-pages
# antigen bundle colorize
# antigen bundle command-not-found
# antigen bundle common-aliases
# antigen bundle docker
# antigen bundle gem
# antigen bundle git
# antigen bundle github
# antigen bundle heroku
# antigen bundle jira
# antigen bundle node
# antigen bundle npm
# antigen bundle osx
# antigen bundle pip
# antigen bundle pylint
# antigen bundle python
# antigen bundle redis-cli
# antigen bundle ruby
# antigen bundle rvm
# antigen bundle screen
# antigen bundle vagrant

# Syntax bundles from external sources
# antigen bundle horosgrisa/autoenv
# antigen bundle rupa/z
# antigen bundle zsh-users/zaw
# antigen bundle zsh-users/zsh-autosuggestions
# antigen bundle zsh-users/zsh-completions
# antigen bundle zsh-users/zsh-syntax-highlighting
# antigen bundle zsh-users/zsh-history-substring-search ./zsh-history-substring-search.zsh

# Load the theme.
antigen theme pygmalion

# Tell antigen that you're done.
antigen apply
