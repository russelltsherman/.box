#!/usr/bin/env bash

BOXROOTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# include my library helpers for colorized echo and require_brew, etc
source $BOXROOTDIR/dotfiles/.lib_sh/functions.sh

banner

get_platform

DEVUSER=$(whoami)

bot "Hi! $DEVUSER"

bot "I'm going to install tooling and tweak your system settings. Here I go..."

################################################################################
# passwordless sudo
################################################################################
if [[ ! -f "/etc/sudoers.d/coderonin" ]];then
  ################################################################################
  # Ask for the administrator password upfront
  ################################################################################
  bot "I need you to enter your sudo password so I can install some things:"
  sudo -v

  # Keep-alive: update existing sudo time stamp until the script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

  bot "Do you want me to setup this machine to allow you to run sudo without a password?\nPlease read here to see what I am doing:\nhttp://wiki.summercode.com/sudo_without_a_password_in_mac_os_x \n"

  read -r -p "Make sudo passwordless? [y|N] " response
  if [[ $response =~ (yes|y|Y) ]];then
    sudo "$BASH" -c "touch /etc/sudoers.d/$DEVUSER"
    sudo "$BASH" -c "chmod 640 /etc/sudoers.d/$DEVUSER"
    sudo "$BASH" -c "echo \"$DEVUSER ALL=(ALL) NOPASSWD: ALL\" > \"/etc/sudoers.d/$DEVUSER\""
    bot "You can now run sudo commands without password!"
  fi
else
  bot "It looks like you are already set up to sudo without a password."
fi


################################################################################
# Default wallpaper
################################################################################
IMGDIR=$BOXROOTDIR/assets
MD5_NEWWP=$(md5 $IMGDIR/wallpaper.jpg | awk '{print $4}')
MD5_OLDWP=$(md5 /System/Library/CoreServices/DefaultDesktop.jpg | awk '{print $4}')
if [[ "$MD5_NEWWP" != "$MD5_OLDWP" ]]; then
  read -r -p "Do you want to use the project's custom desktop wallpaper? [Y|n] " response
  if [[ $response =~ ^(no|n|N) ]];then
    echo "skipping...";
    ok
  else
    running "Set a custom wallpaper image"
    # `DefaultDesktop.jpg` is already a symlink, and
    # all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
    rm -rf ~/Library/Application Support/Dock/desktoppicture.db
    sudo rm -f /System/Library/CoreServices/DefaultDesktop.jpg > /dev/null 2>&1
    sudo rm -f /Library/Desktop\ Pictures/El\ Capitan.jpg > /dev/null 2>&1
    sudo rm -f /Library/Desktop\ Pictures/Sierra.jpg > /dev/null 2>&1
    sudo cp $IMGDIR/wallpaper.jpg /System/Library/CoreServices/DefaultDesktop.jpg;
    sudo cp $IMGDIR/wallpaper.jpg /Library/Desktop\ Pictures/Sierra.jpg;
    sudo cp $IMGDIR/wallpaper.jpg /Library/Desktop\ Pictures/El\ Capitan.jpg;ok
  fi
else
  bot "It looks like you are already using our project wallpaper image."
fi


################################################################################
# xCode
################################################################################
xcode_tools=$(xcode-select --install) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  bot "Looks like Xcode cli tools are already installed"
else
  die "Looks like you need to install Xcode cli tools"
fi


################################################################################
# homebrew
################################################################################
if [ "$NS_PLATFORM" == "darwin" ]; then
  brew_bin=$(which brew) 2>&1 > /dev/null
  if [[ $? != 0 ]]; then
    bot "Installing Homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    if [[ $? != 0 ]]; then
      error "unable to install homebrew, script $0 abort!"
      exit 2
    fi
  else
    bot "Looks like Homebrew is already installed"
  fi

  output=$(brew tap | grep cask)
  if [[ $? != 0 ]]; then
    bot "Installing Homebrew Cask"
    require_brew caskroom/cask/brew-cask
    brew tap caskroom/versions > /dev/null 2>&1
  else
    bot "Looks like Homebrew Cask is already installed"
  fi
fi


################################################################################
# zshell
################################################################################
if [[ "zsh" == $ZSH_NAME ]];then
  bot "Installing Zshell"

  if [ "$NS_PLATFORM" == "darwin" ]; then
    require_brew zsh
    require_brew zsh-completions
  fi
  if [ "$NS_PLATFORM" == "linux" ]; then
    running "Install ZSH"
    sudo apt-get install -y zsh
    ok
  fi

  running "ensure that zsh exists in /etc/shells"
    if ! grep -q "/usr/local/bin/zsh" "/etc/shells" ; then
      sudo echo "/usr/local/bin/zsh" >> "/etc/shells"
    fi
  ok

  # implementing antigen for easier management of zsh plugins
  # https://joshldavis.com/2014/07/26/oh-my-zsh-is-a-disease-antigen-is-the-vaccine/
  git_clone_or_update git://github.com/zsh-users/antigen.git "$BOXROOTDIR/.antigen"

  running "Set Zsh as your default shell:"
  if [ "$NS_PLATFORM" == "darwin" ]; then
    chsh -s /usr/local/bin/zsh
  fi
  if [ "$NS_PLATFORM" == "linux" ]; then
    chsh -s /usr/bin/zsh
  fi
  ok
else
  bot "Looks like you're already running in zShell"
fi


################################################################################
# dotfiles
################################################################################
bot "creating symlinks for project dotfiles..."

now=$(date +"%Y.%m.%d.%H.%M.%S")
pushd $BOXROOTDIR/dotfiles > /dev/null 2>&1
for file in .*; do
  if [[ $file == "." || $file == ".." || $file == ".DS_Store" ]]; then
    continue
  fi
  running "~/$file"

  # if the file exists:
  if [[ -e ~/$file ]]; then
    mkdir -p ~/.dotfiles_backup/$now
    mv ~/$file ~/.dotfiles_backup/$now/$file
    echo "backup saved as ~/.dotfiles_backup/$now/$file"
  fi

  # symlink might still exist
  unlink ~/$file > /dev/null 2>&1

  # create the link
  ln -s $BOXROOTDIR/dotfiles/$file ~/$file
done

popd > /dev/null 2>&1
