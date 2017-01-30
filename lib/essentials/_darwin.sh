#!/usr/bin/env bash

# Install GNU core utilities (those that come with OS X are outdated)
# Don't forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
require_brew coreutils
#sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`
require_brew moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
require_brew findutils

# Install GNU `sed`, overwriting the built-in `sed`
require_brew gnu-sed --default-names
require_brew gnu-which

# Install Bash 4
# Note: don't forget to add `/usr/local/bin/bash` to `/etc/shells` before running `chsh`.
require_brew bash
require_brew bash-completion

# Install other useful binaries
require_brew ack
# dos2unix converts windows newlines to unix newlines
require_brew dos2unix
require_brew gawk
# why is everyone still not using GPG?
require_brew gnupg
# Install GNU `sed`, overwriting the built-in `sed`
# so we can do "sed -i 's/foo/bar/' file" instead of "sed -i '' 's/foo/bar/' file"
require_brew gnu-sed --default-names
# better, more recent grep
require_brew homebrew/dupes/grep
require_brew hub
require_brew htop
require_brew imagemagick
require_brew imagesnap
# jq is a JSON grep
require_brew jq
# http://maven.apache.org/
require_brew maven
require_brew most
require_brew pv
# better/more recent version of screen
require_brew homebrew/dupes/screen
require_brew tig
require_brew tree
require_brew ttyrec
# better, more recent vim
require_brew vim --override-system-vi
require_brew watch
# Install wget with IRI support
require_brew wget --with-iri

if [[ -f "$BOXROOTDIR/.laptop.local" ]]; then
  source "$BOXROOTDIR/.laptop.local"
fi

action "cleaning up homebrew cache..."
# Remove outdated versions from the cellar
brew cleanup
ok
