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
# gitconfig
################################################################################
grep 'user = GITHUBUSER' $BOXROOTDIR/dotfiles/.gitconfig > /dev/null 2>&1
if [[ $? = 0 ]]; then
  read -r -p "What is your github.com username? " githubuser

  fullname=`osascript -e "long user name of (system info)"`

  if [[ -n "$fullname" ]];then
    lastname=$(echo $fullname | awk '{print $2}');
    firstname=$(echo $fullname | awk '{print $1}');
  fi

  if [[ -z $lastname ]]; then
    lastname=`dscl . -read /Users/$(whoami) | grep LastName | sed "s/LastName: //"`
  fi
  if [[ -z $firstname ]]; then
    firstname=`dscl . -read /Users/$(whoami) | grep FirstName | sed "s/FirstName: //"`
  fi
  email=`dscl . -read /Users/$(whoami)  | grep EMailAddress | sed "s/EMailAddress: //"`

  if [[ ! "$firstname" ]];then
    response='n'
  else
    echo -e "I see that your full name is $COL_YELLOW$firstname $lastname$COL_RESET"
    read -r -p "Is this correct? [Y|n] " response
  fi

  if [[ $response =~ ^(no|n|N) ]];then
    read -r -p "What is your first name? " firstname
    read -r -p "What is your last name? " lastname
  fi
  fullname="$firstname $lastname"

  bot "Great $fullname, "

  if [[ ! $email ]];then
    response='n'
  else
    echo -e "The best I can make out, your email address is $COL_YELLOW$email$COL_RESET"
    read -r -p "Is this correct? [Y|n] " response
  fi

  if [[ $response =~ ^(no|n|N) ]];then
    read -r -p "What is your email? " email
    if [[ ! $email ]];then
      error "you must provide an email to configure .gitconfig"
      exit 1
    fi
  fi

  running "replacing items in .gitconfig with your info ($COL_YELLOW$fullname, $email, $githubuser$COL_RESET)"

  # test if gnu-sed or MacOS sed

  sed -i "s/GITHUBFULLNAME/$firstname $lastname/" $BOXROOTDIR/dotfiles/.gitconfig > /dev/null 2>&1 | true
  if [[ ${PIPESTATUS[0]} != 0 ]]; then
    echo
    running "looks like you are using MacOS sed rather than gnu-sed, accommodating"
    sed -i '' "s/GITHUBFULLNAME/$firstname $lastname/" $BOXROOTDIR/dotfiles/.gitconfig;
    sed -i '' 's/GITHUBEMAIL/'$email'/' $BOXROOTDIR/dotfiles/.gitconfig;
    sed -i '' 's/GITHUBUSER/'$githubuser'/' $BOXROOTDIR/dotfiles/.gitconfig;
  else
    echo
    bot "looks like you are already using gnu-sed. woot!"
    sed -i 's/GITHUBEMAIL/'$email'/' $BOXROOTDIR/dotfiles/.gitconfig;
    sed -i 's/GITHUBUSER/'$githubuser'/' $BOXROOTDIR/dotfiles/.gitconfig;
  fi
fi


################################################################################
# passwordless sudo
################################################################################
if [ -f "/etc/sudoers.d/coderonin" ];then
  bot "It looks like you are already set up to sudo without a password."
else
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
fi


################################################################################
# ssh key
################################################################################
source "$BOXROOTDIR/functions/setup/ssh"
(cmd_ssh)


################################################################################
# Default wallpaper
################################################################################
IMGDIR=$BOXROOTDIR/assets
MD5_NEWWP=$(md5 $IMGDIR/wallpaper.jpg | awk '{print $4}')
MD5_OLDWP=$(md5 /System/Library/CoreServices/DefaultDesktop.jpg | awk '{print $4}')
if [[ "$MD5_NEWWP" == "$MD5_OLDWP" ]]; then
  bot "It looks like you are already using our project wallpaper image."
else
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
fi


################################################################################
# xCode
################################################################################
xcode_tools=$(xcode-select --install 2>&1 > /dev/null)
if [[ $? == 0 ]]; then
  die "Looks like you need to install Xcode cli tools"
else
  bot "Looks like Xcode cli tools are already installed"
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
# essential software
################################################################################
bot "Installing essential software"
source "$BOXROOTDIR/lib/essentials/_$NS_PLATFORM.sh"


################################################################################
# system defaults
################################################################################
bot "Setting System Defaults"
source "$BOXROOTDIR/lib/defaults/_$NS_PLATFORM.sh"


################################################################################
# NodeJS Version Manager
################################################################################
if [ -d $HOME/.nvm ]; then
  bot "NodeJS Version Manager found... updating"
  (cd ~/.nvm && ./install.sh)
else
  bot "Installing NodeJS Version Manager"

  git clone https://github.com/creationix/nvm.git ~/.nvm && cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`

  # nvm load in coderonin file
  profile_write "# initialize NVM" $HOME/.profile
  profile_write "export NVM_DIR=\$HOME/.nvm" $HOME/.profile
  profile_write '[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"' $HOME/.profile

  # immediately load nvm so we can install node and npm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

  require_nvm 4.4.7
fi


################################################################################
# install appications
################################################################################
bot "Install Applications"
source "$BOXROOTDIR/lib/applications/_$NS_PLATFORM.sh"


################################################################################
# docker
################################################################################
bot "Install Docker"
if [ "$NS_PLATFORM" == "darwin" ]; then
  require_cask docker
fi
if [ "$NS_PLATFORM" == "linux" ]; then
  running "purge old repos if they exist"
    # Purge the old repo if it exists.
    sudo apt-get purge "lxc-docker*"
    sudo apt-get purge "docker.io*"
  ok

  running "add docker apt repo to sources"
    sudo rm /etc/apt/sources.list.d/backports.list
    sudo_write 'deb http://http.debian.net/debian wheezy-backports main' /etc/apt/sources.list.d/backports.list
    sudo_write 'deb https://apt.dockerproject.org/repo debian-jessie main' /etc/apt/sources.list.d/docker.list
  ok

  running "ensure dependencies"
    sudo apt-get install -y libapparmor1 aufs-tools apt-transport-https ca-certificates
  ok

  running "add public key for repo"
    sudo apt-key adv \
      --keyserver hkp://ha.pool.sks-keyservers.net:80 \
      --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  ok

  running "update apt cache"
    # Update the APT package index.
    sudo apt-get update
    # Verify that APT is pulling from the right repository.
    sudo apt-cache policy docker-engine
  ok

  running "install linux-image-extra kernel package"
    # For Ubuntu Trusty, Vivid, and Wily, it’s recommended to install the linux-image-extra kernel package.
    # The linux-image-extra package allows you use the aufs storage driver.
    sudo apt-get -y install linux-image-extra-$(uname -r)
  ok

  running "install docker engine"
    # Install Docker.
    sudo apt-get -y install docker-engine
  ok

  running "start docker"
    # Start the docker daemon.
    sudo service docker start
  ok

  running "hello world docker"
    # Verify docker is installed correctly.
    sudo docker run hello-world
  ok

  running "make docker accessible without sudo"
    # Add the docker group if it doesn't already exist.
    sudo groupadd docker
    # Add the connected user "${USER}" to the docker group.
    # Change the user name to match your preferred user.
    # You may have to logout and log back in again for
    # this to take effect.
    DEV=`whoami`
    sudo gpasswd -aG $DEV docker
    # Restart the Docker daemon.
    sudo service docker restart
  ok

  running "installing docker compose"
    sudo curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  ok
fi


################################################################################
# vim plugins
################################################################################
bot "Installing plugins for vim"
if [ "$NS_PLATFORM" == "darwin" ]; then
  # add vundle to manage vim plugins
  git_clone_or_update https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  # use vundle to install other plugins
  vim +PluginInstall +qall > /dev/null 2>&1
fi
if [ "$NS_PLATFORM" == "linux" ]; then
  die 'not implemented'
fi

################################################################################
# antigen
################################################################################
bot "cloning antigen..."
git_clone_or_update https://github.com/zsh-users/antigen.git $BOXROOTDIR/.antigen

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
  fi

  # symlink might still exist
  unlink ~/$file > /dev/null 2>&1

  # create the link
  ln -s $BOXROOTDIR/dotfiles/$file ~/$file
  ok
done

popd > /dev/null 2>&1


################################################################################
# zshell
################################################################################
if [ "$ZSH_NAME" == "zsh" ];then
  bot "Zshell"

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
