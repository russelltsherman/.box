#!/usr/bin/env bash

# Install GNU core utilities (some that come with OS X are outdated)

# Code-search similar to ack https://github.com/ggreer/the_silver_searcher
require_brew ag

# Search tool like grep, but optimized for programmers http://beyondgrep.com/
require_brew ack

# Install Bash 4
# Note: don't forget to add `/usr/local/bin/bash` to `/etc/shells` before running `chsh`.
require_brew bash

# Programmable completion for Bash 3.2 https://bash-completion.alioth.debian.org/
require_brew bash-completion

# GNU File, Shell, and Text utilities https://www.gnu.org/software/coreutils
require_brew coreutils
# Don't forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
# sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Convert text between DOS, UNIX, and Mac formats https://waterlan.home.xs4all.nl/dos2unix.html
require_brew dos2unix

# XML-based font configuration API for X Windows https://wiki.freedesktop.org/www/Software/fontconfig/
require_brew fontconfig
# need fontconfig to install/build fonts

# Identify or delete duplicate files https://github.com/adrianlopezroche/fdupes
require_brew fdupes

# Collection of GNU find, xargs, and locate https://www.gnu.org/software/findutils/
require_brew findutils
# PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
# MANPATH="/usr/local/opt/findutils/libexec/gnuman:$MANPATH"

# Infamous electronic fortune-cookie generator https://www.ibiblio.org/pub/linux/games/amusements/fortune/!INDEX.html
require_brew fortune

# GNU awk utility https://www.gnu.org/software/gawk/
require_brew gawk

# GIF image/animation creator/editor https://www.lcdf.org/gifsicle/
require_brew gifsicle

# GNU Pretty Good Privacy (PGP) package https://www.gnupg.org/
require_brew gnupg

# GNU implementation of the famous stream editor https://www.gnu.org/software/sed/
require_brew gnu-sed --default-names
# Install GNU `sed`, overwriting the built-in `sed`
# so we can do "sed -i 's/foo/bar/' file" instead of "sed -i '' 's/foo/bar/' file"

# GNU implementation of which utility https://savannah.gnu.org/projects/which/
require_brew gnu-which

# GNU grep, egrep and fgrep https://www.gnu.org/software/grep/
require_brew homebrew/dupes/grep

# Improved top (interactive process viewer) https://hisham.hm/htop/
require_brew htop

# Add GitHub support to git on the command-line https://hub.github.com/
require_brew hub

# Tools and libraries to manipulate images in many formats https://www.imagemagick.org/
require_brew imagemagick

# Tool to capture still images from an iSight or other video source http://iharder.sourceforge.net/current/macosx/imagesnap/
require_brew imagesnap

# Lightweight and flexible command-line JSON processor https://stedolan.github.io/jq/
require_brew jq

# Java-based project management https://maven.apache.org/
require_brew maven

# Powerful paging program http://www.jedsoft.org/most/
require_brew most

# Collection of tools that nobody wrote when UNIX was young https://joeyh.name/code/moreutils/
require_brew moreutils

# CLI for MySQL with auto-completion and syntax highlighting http://mycli.net/
require_brew mycli

# Port scanning utility for large networks https://nmap.org/
require_brew nmap

# Open client for Cisco AnyConnect VPN http://www.infradead.org/openconnect.html
require_brew openconnect

# Monitor data's progress through a pipe https://www.ivarch.com/programs/pv.shtml
require_brew pv

# Reattach process (e.g., tmux) to background https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard
require_brew reattach-to-user-namespace

# Terminal multiplexer with VT100/ANSI terminal emulation https://www.gnu.org/software/screen
require_brew homebrew/dupes/screen

# Text interface for Git repositories http://jonas.nitro.dk/tig/
require_brew tig

# Terminal multiplexer https://tmux.github.io/
require_brew tmux

# Display directories as trees (with optional color/HTML output) http://mama.indstate.edu/users/ice/tree/
require_brew tree

# Terminal interaction recorder and player http://0xcc.net/ttyrec/
require_brew ttyrec

# Vi "workalike" with many additional features http://www.vim.org/
require_brew vim --override-system-vi

# Executes a program periodically, showing output fullscreen https://gitlab.com/procps-ng/procps
require_brew watch

# Internet file retriever https://www.gnu.org/software/wget/
require_brew wget --with-iri

# UNIX shell (command interpreter) https://www.zsh.org/
require_brew zsh

# Additional completion definitions for zsh https://github.com/zsh-users/zsh-completions
require_brew zsh-completions

action "cleaning up homebrew cache..."
# Remove outdated versions from the cellar
brew cleanup
ok
