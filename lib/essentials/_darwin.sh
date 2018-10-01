#!/usr/bin/env bash

# load packages defined in Brewfile
# https://github.com/Homebrew/homebrew-bundle
brew bundle

action "cleaning up homebrew cache..."
# Remove outdated versions from the cellar
brew cleanup
ok
