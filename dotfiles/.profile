#!/usr/bin/env bash
# shellcheck disable=SC1090

# add dot_box/bin to the path
if [ -d "${BOXROOTDIR}" ]; then
  export PATH="${PATH}:${BOXROOTDIR}/bin"
fi

# add core utils to path https://www.gnu.org/software/coreutils
if [ -d "$(brew --prefix coreutils)" ]; then
  newpath="$(brew --prefix coreutils)/libexec/gnubin:${PATH}"
  export PATH=$newpath
fi

# add findutils to path https://www.gnu.org/software/findutils
if [ -d "$(brew --prefix findutils)" ]; then
  newpath="$(brew --prefix findutils)/libexec/gnubin:${PATH}"
  export PATH=$newpath
  newmanpath="$(brew --prefix findutils)/libexec/gnuman:${MANPATH}"
  export MANPATH=$newmanpath
fi

# iTerm2 may be integrated with the unix shell so that it can keep track of your command history,
# current working directory, host name, and more--even over ssh.
# load iterm2 shell integration if present
if [ -f "${HOME}/.iterm2_shell_integration.$(basename "${SHELL}")" ];then
  source "$HOME/.iterm2_shell_integration.$(basename "$SHELL")"
fi

# initialize other shell agnostic customizations
export LIB_SH_DIR="${BOXROOTDIR}/dotfiles/.lib_sh"
[ -s "${LIB_SH_DIR}/aliases.sh" ] && source "${LIB_SH_DIR}/aliases.sh"
[ -s "${LIB_SH_DIR}/dockeraliases.sh" ] && source "${LIB_SH_DIR}/dockeraliases.sh"
[ -s "${LIB_SH_DIR}/dockerfunctions.sh" ] && source "${LIB_SH_DIR}/dockerfunctions.sh"
[ -s "${LIB_SH_DIR}/paths.sh" ] && source "${LIB_SH_DIR}/paths.sh"

# lazily initialize NVM
export NVM_DIR="${HOME}/.nvm"
[ -s "${NVM_DIR}/nvm.sh" ] && source "${NVM_DIR}/nvm.sh"

# initialize RVM
export PATH="${PATH}:${HOME}/.rvm/bin" # Add RVM to PATH for scripting
[ -s "${HOME}/.rvm/scripts/rvm" ] && source "${HOME}/.rvm/scripts/rvm"
export PATH="${GEM_HOME}/bin:${PATH}" # RVM demands ruby bin is first in path

# attempt to detect which is the active network interface
ifconfig en0 &>/dev/null && nterface="en0"  # running on my macbook
ifconfig enp0s3 &>/dev/null && nterface="enp0s3" # running in virtualbox virtualmachine

# all this for container based GUI apps
export DISPLAY=":0"
# shellcheck disable=SC2020
IP=$(ifconfig ${nterface} | grep inet | awk '$1=="inet" {print $2}' | tr -d 'addr:' )
export IP
export DOCKER_DISPLAY="${IP}:0"
xhost_path="$(command -v xhost)"
"${xhost_path}" "${IP}"
"${xhost_path}" -

# add yarn to path
PATH="${PATH}:$(yarn global bin)"
export PATH

# initialize pyenv
type pyenv &>/dev/null && eval "$(pyenv init -)"
type pyenv &>/dev/null && eval "$(pyenv virtualenv-init -)"

# initialize GO
if [ -d "$HOME/src" ]; then
  GOPATH="$HOME"
  PATH="${PATH}:${GOPATH}/bin"
  GOROOT="$(go env GOROOT)"
  alias gotour="\${GOPATH}/bin/gotour"
  export GOPATH
  export PATH
  export GOROOT
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

#
gpgtty=$(tty)
export GPG_TTY=$gpgtty
