
# dot box

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Installation](#installation)
  - [Restoring Dotfiles](#restoring-dotfiles)
- [Additional](#additional)
  - [VIM as IDE](#vim-as-ide)
  - [Crontab](#crontab)
  - [Remap Caps-Lock](#remap-caps-lock)
- [Settings](#settings)
  - [Configuring General System UI/UX](#configuring-general-system-uiux)
  - [Standard System Changes](#standard-system-changes)
  - [Trackpad, mouse, keyboard, Bluetooth accessories, and input](#trackpad-mouse-keyboard-bluetooth-accessories-and-input)
  - [Configuring the Screen](#configuring-the-screen)
  - [Finder Configs](#finder-configs)
  - [Dock & Dashboard](#dock-&-dashboard)
  - [Configuring Hot Corners](#configuring-hot-corners)
  - [Configuring Safari & WebKit](#configuring-safari-&-webkit)
  - [Configuring Mail](#configuring-mail)
  - [Spotlight](#spotlight)
  - [iTerm2](#iterm2)
  - [Time Machine](#time-machine)
  - [Activity Monitor](#activity-monitor)
  - [Address Book, Dashboard, iCal, TextEdit, and Disk Utility](#address-book-dashboard-ical-textedit-and-disk-utility)
  - [Mac App Store](#mac-app-store)
  - [Messages](#messages)
  - [SizeUp.app](#sizeupapp)
- [Software Installation](#software-installation)
  - [Utilities](#utilities)
  - [Apps](#apps)
  <!-- - [NPM Global Modules](#npm-global-modules) -->
  <!-- - [Ruby Gems](#ruby-gems) -->
- [License](#license)
- [Contributions](#contributions)
- [Loathing, Mehs and Praise](#loathing-mehs-and-praise)
- [¯\\_(ツ)_/¯ Warning / Liability](#%C2%AF%5C%5C_%E3%83%84_%C2%AF-warning--liability)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Installation

Note: I recommend forking this repo in case you don't like anything I do and want to set your own preferences (and pull request them!)

```bash
git clone --recurse-submodules https://github.com/russelltsherman/.box2 ~/.box
cd ~/.box;

# run this using terminal (not iTerm, lest iterm settings get discarded on exit)
./install.sh
```

* When it finishes, open Iterm and press `Command + ,` to open preferences. Under Profiles > Colors, select "Load Presets" and choose the `Solarized Dark Patch` scheme. If it isn't there for some reason, import it from `~/.dotfiles/configs`

> Note: running install.sh is idempotent. You can run it again and again as you add new features or software to the scripts! I'll regularly add new configurations so keep an eye on this repo as it grows and optimizes.

## Restoring Dotfiles

If you have existing dotfiles for configuring git, zsh, vim, etc, these will be backed-up into `~/.dotfiles_backup/$(date +"%Y.%m.%d.%H.%M.%S")` and replaced with the files from this project. You can restore your original dotfiles by using `./restore.sh $RESTOREDATE` where `$RESTOREDATE` is the date folder name you want to restore.

# Additional

## VIM as IDE

I am moving away from using `Atom` and instead using `vim` as my IDE. I use Vundle to manage vim plugins (instead of pathogen). Vundle is better in many ways and is compatible with pathogen plugins. Additionally, vundle will manage and install it's own plugins so we don't have to use git submodules for all of them.

## Crontab

You can `cron ~/.crontab` if you want to add my nightly cron software updates.

> \\[0_0]/ - Note that this may wake you in the morning to compatibility issues so use only if you like being on the edge

## Remap Caps-Lock

- I highly recommend remapping your Caps Lock key to Control per [Dr. Bunsen](http://www.drbunsen.org/remapping-caps-lock/):
![Remap Caps Lock](https://raw.githubusercontent.com/russelltsherman/.box2/master/assets/remap_capslock.png)

# Settings

This project changes a number of settings and configures software on MacOS.
Here is the current list:

## Configuring General System UI/UX

- Disable local Time Machine snapshots
- Disable hibernation (speeds up entering sleep mode)
- Remove the sleep image file to save disk space
- Set a custom wallpaper image

## Standard System Changes

- always boot in verbose mode (not MacOS GUI mode)
- allow 'locate' command
- Set standby delay to 24 hours (default is 1 hour)
- Disable the sound effects on boot
- Menu bar: disable transparency
- Menu bar: hide the Time Machine, Volume, User, and Bluetooth icons
- Set highlight color to green
- Set sidebar icon size to medium
- Always show scrollbars
- Increase window resize speed for Cocoa applications
- Expand save panel by default
- Expand print panel by default
- Save to disk (not to iCloud) by default
- Automatically quit printer app once the print jobs complete
- Disable the “Are you sure you want to open this application?” dialog
- Remove duplicates in the “Open With” menu (also see 'lscleanup' alias)
- Display ASCII control characters using caret notation in standard text views
- Disable automatic termination of inactive apps
- Disable the crash reporter
- Set Help Viewer windows to non-floating mode
- Reveal IP, hostname, OS, etc. when clicking clock in login window
- Restart automatically if the computer freezes
- Never go into computer sleep mode
- Check for software updates daily, not just once per week
- Disable Notification Center and remove the menu bar icon
- Disable smart quotes as they’re annoying when typing code
- Disable smart dashes as they’re annoying when typing code

## Security

- Enable firewall
- Enable firewall stealth mode (no response to ICMP / ping requests)
- Disable remote apple events
- Disable wake-on modem
- Disable wake-on LAN
- Disable file-sharing via AFP or SMB
- Disable guest account login

## Trackpad, mouse, keyboard, Bluetooth accessories, and input

- Trackpad: enable tap to click for this user and for the login screen
- Trackpad: map bottom right corner to right-click
- Disable “natural” (Lion-style) scrolling
- Increase sound quality for Bluetooth headphones/headsets
- Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
- Use scroll gesture with the Ctrl (^) modifier key to zoom
- Follow the keyboard focus while zoomed in
- Disable press-and-hold for keys in favor of key repeat
- Set a blazingly fast keyboard repeat rate:
- Set language and text formats (english/US)
- Disable auto-correct

## Configuring the Screen

- Require password immediately after sleep or screen saver begins
- Save screenshots to the desktop
- Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
- Disable shadow in screenshots
- Enable subpixel font rendering on non-Apple LCDs
- Enable HiDPI display modes (requires restart)

## Finder Configs

- Keep folders on top when sorting by name (Sierra only)
- Allow quitting via ⌘ + Q; doing so will also hide desktop icons
- Disable window animations and Get Info animations
- Set Desktop as the default location for new Finder windows
- Show hidden files by default
- Show all filename extensions
- Show status bar
- Show path bar
- Allow text selection in Quick Look
- Display full POSIX path as Finder window title
- When performing a search, search the current folder by default
- Disable the warning when changing a file extension
- Enable spring loading for directories
- Remove the spring loading delay for directories
- Avoid creating .DS_Store files on network volumes
- Disable disk image verification
- Automatically open a new Finder window when a volume is mounted
- Use list view in all Finder windows by default
- Disable the warning before emptying the Trash
- Empty Trash securely by default
- Enable AirDrop over Ethernet and on unsupported Macs running Lion
- Show the ~/Library folder
- Expand the following File Info panes: “General”, “Open with”, and “Sharing & Permissions”

## Dock & Dashboard

- Enable highlight hover effect for the grid view of a stack (Dock)
- Set the icon size of Dock items to 36 pixels
- Change minimize/maximize window effect to scale
- Minimize windows into their application’s icon
- Enable spring loading for all Dock items
- Show indicator lights for open applications in the Dock
- Don’t animate opening applications from the Dock
- Speed up Mission Control animations
- Don’t group windows by application in Mission Control
- Disable Dashboard
- Don’t show Dashboard as a Space
- Don’t automatically rearrange Spaces based on most recent use
- Remove the auto-hiding Dock delay
- Remove the animation when hiding/showing the Dock
- Automatically hide and show the Dock
- Make Dock icons of hidden applications translucent
- Make Dock more transparent
- Reset Launchpad, but keep the desktop wallpaper intact

## Configuring Hot Corners

- Top left screen corner → Mission Control
- Top right screen corner → Desktop
- Bottom right screen corner → Start screen saver

## Configuring Safari & WebKit

- Set Safari’s home page to ‘about:blank’ for faster loading
- Prevent Safari from opening ‘safe’ files automatically after downloading
- Allow hitting the Backspace key to go to the previous page in history
- Hide Safari’s bookmarks bar by default
- Hide Safari’s sidebar in Top Sites
- Disable Safari’s thumbnail cache for History and Top Sites
- Enable Safari’s debug menu
- Make Safari’s search banners default to Contains instead of Starts With
- Remove useless icons from Safari’s bookmarks bar
- Enable the Develop menu and the Web Inspector in Safari
- Add a context menu item for showing the Web Inspector in web views

## Configuring Mail

- Disable send and reply animations in Mail.app
- Copy email addresses as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app
- Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
- Display emails in threaded mode, sorted by date (oldest at the top)
- Disable inline attachments (just show the icons)
- Disable automatic spell checking

## Spotlight

- Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed
- Change indexing order and disable some file types from being indexed
- Load new settings before rebuilding the index
- Make sure indexing is enabled for the main volume

## iTerm2

- Installing the Solarized Dark theme for iTerm
- Don’t display the annoying prompt when quitting iTerm
- Hide tab title bars
- Set system-wide hotkey to show/hide iterm with ctrl+tick ( `^` + `)
- Set normal font to Hack 12pt
- Set non-ascii font to Roboto Mono for Powerline 12pt

## Time Machine

- Prevent Time Machine from prompting to use new hard drives as backup volume
- Disable local Time Machine backups

## Activity Monitor

- Show the main window when launching Activity Monitor
- Visualize CPU usage in the Activity Monitor Dock icon
- Show all processes in Activity Monitor
- Sort Activity Monitor results by CPU usage

## Address Book, Dashboard, iCal, TextEdit, and Disk Utility

- Enable the debug menu in Address Book
- Enable Dashboard dev mode (allows keeping widgets on the desktop)
- Use plain text mode for new TextEdit documents
- Open and save files as UTF-8 in TextEdit
- Enable the debug menu in Disk Utility

## Mac App Store

- Enable the WebKit Developer Tools in the Mac App Store
- Enable Debug Menu in the Mac App Store

## Messages

- Disable automatic emoji substitution (i.e. use plain text smileys)
- Disable smart quotes as it’s annoying for messages that contain code
- Disable continuous spell checking

## SizeUp.app

- Start SizeUp at login
- Don’t show the preferences window on next start

# Software Installation

the following are all installed inside the `install.sh` as foundational software for running this project.

## Utilities

* ack
* ag
* bash
* bash-completion
* coreutils
* dos2unix
* fdupes
* findutils
* fontconfig
* fortune
* gawk
* gifsicle
* gnupg
* gnu-sed
* gnu-which
* homebrew/dupes/grep
* homebrew
* htop
* hub
* imagemagick
* imagesnap
* jq
* most
* moreutils
* mycli
* nmap
* openconnect
* pv
* reattach-to-user-namespace
* homebrew/dupes/screen
* tig
* tmux
* tree
* ttyrec
* vim --override-system-vi
* watch
* wget --enable-iri
* zsh
* zsh-completions

## Apps

* 1password
* Adium
* Alfred
* Armory
* Atom and atom plugins
  -  atom-beautify
  -  editorconfig
  -  language-babel
  -  language-docker
  -  language-nginx
  -  language-ldif
  -  linter-eslint
  -  linter
  -  linter-docker
  -  nuclide
  -  vim-mode-plus
* Bitcoin Core
* Cheatsheet
* Daisy Disk
* DiffMerge
* Drobo Dashboard
* Docker
* Firefox
* Google Chrome
* Growl Notify
* GPG Suite
* iTerm2
* LastPass
* MacPilot
* SizeUp
* Slack
* Sophos Antivirus
* the Unarchiver
* Tower
* VLC
* xCode CLI tools
* xquartz
* yohimbo

<!--
## NPM Global Modules

* antic
* buzzphrase
* esformatter
* eslint
* generator-dockerize
* gulp
* instant-markdown-d
* npm-check
* trash
* vtop
* yo
-->

# License

This project is licensed under ISC. Please fork, contribute and share.

# Contributions

Contributions are always welcome in the form of pull requests with explanatory comments.

Please refer to the [Contributor Covenant](https://github.com/russelltsherman/.box2/blob/master/CODE_OF_CONDUCT.md)

# Loathing, Mehs and Praise

1. Loathing should be directed into pull requests that make it better. woot.
2. Bugs with the setup should be put as GitHub issues.
3. Mehs should be > /dev/null
4. Praise should be directed to ![@BurnerDev](https://img.shields.io/twitter/follow/BurnerDev.svg?style=social&label=@BurnerDev)

# ¯\\_(ツ)_/¯ Warning / Liability

> Warning:
The creator of this repo is not responsible if your machine ends up in a state you are not happy with.
If you are concerned, look at the code to review everything this will do to your machine :)
