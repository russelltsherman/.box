#!/usr/bin/env bash

###############################################################################
action "Configuring General System UI/UX..."
###############################################################################

###############################################################################
# SSD-specific tweaks                                                         #
###############################################################################

running "Disable local Time Machine snapshots"
sudo tmutil disablelocal

running "Disable hibernation (speeds up entering sleep mode)"
sudo pmset -a hibernatemode 0

running "Remove the sleep image file to save disk space"
sudo rm -rf /Private/var/vm/sleepimage
running "Create a zero-byte file instead"
sudo touch /Private/var/vm/sleepimage
running "…and make sure it can't be rewritten"
sudo chflags uchg /Private/var/vm/sleepimage

running "Disable the sudden motion sensor as it's not useful for SSDs"
sudo pmset -a sms 0

############################################################################
# General UI/UX                                                            #
############################################################################

# running "Set computer name (as done via System Preferences → Sharing)"
# sudo scutil --set ComputerName "coderonin"
# sudo scutil --set HostName "coderonin"
# sudo scutil --set LocalHostName "coderonin"
# sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "coderonin"

running "Menu bar: show remaining battery time (on pre-10.8); hide percentage"
defaults write com.apple.menuextra.battery ShowPercent -string "NO"
defaults write com.apple.menuextra.battery ShowTime -string "YES"

running "General: double-click a window's title bar to minimize"
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool TRUE

################################################
action "Standard System Changes"
################################################
# running "always boot in verbose mode (not OSX GUI mode)"
# sudo nvram boot-args="-v"

running "allow 'locate' command"
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist > /dev/null 2>&1

running "Set standby delay to 24 hours (default is 1 hour)"
sudo pmset -a standbydelay 86400

running "Disable the sound effects on boot"
sudo nvram SystemAudioVolume=" "

running "Menu bar: disable transparency"
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

running "Menu bar: hide the Time Machine, Volume, User, and Bluetooth icons"
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
  defaults write "${domain}" dontAutoLoad -array \
    "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
    "/System/Library/CoreServices/Menu Extras/Volume.menu" \
    "/System/Library/CoreServices/Menu Extras/User.menu"
done;
defaults write com.apple.systemuiserver menuExtras -array \
  "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
  "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
  "/System/Library/CoreServices/Menu Extras/Battery.menu" \
  "/System/Library/CoreServices/Menu Extras/Clock.menu"


running "Set highlight color to green"
defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"

running "Set sidebar icon size to medium"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

running "Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

# running "Disable smooth scrolling"
# (Uncomment if you're on an older Mac that messes up the animation)
# defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false

running "Increase window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

running "Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool TRUE
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool TRUE

running "Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool TRUE
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool TRUE

running "Save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

running "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool TRUE

running "Disable the 'Are you sure you want to open this application?' dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

running "Remove duplicates in the 'Open With' menu (also see 'lscleanup' alias)"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

running "Display ASCII control characters using caret notation in standard text views"
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool TRUE

# running "Disable Resume system-wide"
# defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false
# TODO: might want to enable this again and set specific apps that this works great for
# e.g. defaults write com.microsoft.word NSQuitAlwaysKeepsWindows -bool TRUE

running "Disable automatic termination of inactive apps"
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool TRUE

# running "Fix for the ancient UTF-8 bug in QuickLook (http://mths.be/bbo)""
# # Commented out, as this is known to cause problems in various Adobe apps :(
# # See https://github.com/mathiasbynens/dotfiles/issues/237
# echo "0x08000100:0" > ~/.CFUserTextEncoding

running "Disable the crash reporter"
defaults write com.apple.CrashReporter DialogType -string "none"

running "Set Help Viewer windows to non-floating mode"
defaults write com.apple.helpviewer DevMode -bool TRUE

running "Reveal IP, hostname, OS, etc. when clicking clock in login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

running "Restart automatically if the computer freezes"
sudo systemsetup -setrestartfreeze on

running "Never go into computer sleep mode"
sudo systemsetup -setcomputersleep Off > /dev/null 2>&1

running "Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

running "Disable Notification Center and remove the menu bar icon"
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist > /dev/null 2>&1

running "Disable smart quotes as they're annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

running "Disable smart dashes as they're annoying when typing code"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# running "Set a custom wallpaper image"
# # `DefaultDesktop.jpg` is already a symlink, and
# # all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
# rm -rf ~/Library/Application Support/Dock/desktoppicture.db
# sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
# sudo ln -s ~/.dotfiles/assets/wallpaper.jpg /System/Library/CoreServices/DefaultDesktop.jpg

###############################################################################
action "Trackpad, mouse, keyboard, Bluetooth accessories, and input"
###############################################################################

running "Trackpad: enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool TRUE
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

running "Trackpad: map bottom right corner to right-click"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool TRUE
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool TRUE

running "Enable 'natural' (Lion-style) scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool TRUE

running "Increase sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

running "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

running "Use scroll gesture with the Ctrl (^) modifier key to zoom"
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool TRUE
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
running "Follow the keyboard focus while zoomed in"
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool TRUE

running "Disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

running "Set fast keyboard repeat rate"
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2

running "automatically illuminate built-in MacBook keyboard in low light"
defaults write com.apple.BezelServices kDim -bool TRUE

running "Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300

running "Set language and text formats (english/US)"
defaults write NSGlobalDomain AppleLanguages -array "en"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool TRUE

running "Set the timezone; see $(sudo systemsetup -listtimezones) for other values"
sudo systemsetup -settimezone "America/Chicago" > /dev/null 2>&1

running "Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# running "Stop iTunes from responding to the keyboard media keys"
# launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist > /dev/null 2>&1

###############################################################################
action "Configuring the Screen"
###############################################################################

running "Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

running "Save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

running "Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png"

running "Disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool TRUE

running "Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

running "Enable HiDPI display modes (requires restart)"
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool TRUE

###############################################################################
action "Finder Configs"
###############################################################################

running "Allow quitting via ⌘ + Q; doing so will also hide desktop icons"
defaults write com.apple.finder QuitMenuItem -bool TRUE

running "Disable window animations and Get Info animations"
defaults write com.apple.finder DisableAllAnimations -bool TRUE

running "Set Desktop as the default location for new Finder windows"
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

running "Enable icons for hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool TRUE
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool TRUE
defaults write com.apple.finder ShowMountedServersOnDesktop -bool TRUE
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool TRUE

running "Show hidden files by default"
defaults write com.apple.finder AppleShowAllFiles -bool TRUE

running "Show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool TRUE

running "Show status bar"
defaults write com.apple.finder ShowStatusBar -bool TRUE

running "Show path bar"
defaults write com.apple.finder ShowPathbar -bool TRUE

running "Allow text selection in Quick Look"
defaults write com.apple.finder QLEnableTextSelection -bool TRUE

running "Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool TRUE

running "When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

running "Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

running "Enable spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool TRUE

running "Remove the spring loading delay for directories"
defaults write NSGlobalDomain com.apple.springing.delay -float 0

running "Avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE

running "Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool TRUE
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool TRUE
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool TRUE

running "Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool TRUE
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool TRUE
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool TRUE

running "Show item info near icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo TRUE" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo TRUE" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo TRUE" ~/Library/Preferences/com.apple.finder.plist

running "Show item info to the right of the icons on the desktop"
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

running "Enable snap-to-grid for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

running "Increase grid spacing for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

running "Increase the size of icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist

running "Use list view in all Finder windows by default"
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

running "Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

running "Empty Trash securely by default"
defaults write com.apple.finder EmptyTrashSecurely -bool TRUE

running "Enable AirDrop over Ethernet and on unsupported Macs running Lion"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool TRUE

running "Enable the MacBook Air SuperDrive on any Mac"
sudo nvram boot-args="mbasd=1"

running "Show the ~/Library folder"
chflags nohidden ~/Library

running "Remove Dropbox's green checkmark icons in Finder"
file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
[ -e "${file}" ] && mv -f "${file}" "${file}.bak"

running "Expand the following File Info panes: 'General', 'Open with', and 'Sharing & Permissions'"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool TRUE \
  OpenWith -bool TRUE \
  Privileges -bool TRUE

###############################################################################
action "Dock & Dashboard"
###############################################################################

running "Enable highlight hover effect for the grid view of a stack (Dock)"
defaults write com.apple.dock mouse-over-hilite-stack -bool TRUE

running "Set the icon size of Dock items to 36 pixels"
defaults write com.apple.dock tilesize -int 36

running "Change minimize/maximize window effect to scale"
defaults write com.apple.dock mineffect -string "scale"

running "Minimize windows into their application's icon"
defaults write com.apple.dock minimize-to-application -bool TRUE

running "Enable spring loading for all Dock items"
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool TRUE

running "Show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool TRUE

running "Dock: enable magnification"
defaults write com.apple.dock magnification -bool TRUE

running "Set magnification icon size to 80 pixels"
defaults write com.apple.dock largesize -float 80

running "Wipe all (default) app icons from the Dock"
# This is only really useful when setting up a new Mac, or if you don't use the Dock to launch apps.
defaults write com.apple.dock persistent-apps -array ""

running "Don't animate opening applications from the Dock"
defaults write com.apple.dock launchanim -bool false

running "Speed up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.1

running "Don't group windows by application in Mission Control"
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false

running "Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool TRUE

running "Don't show Dashboard as a Space"
defaults write com.apple.dock dashboard-in-overlay -bool TRUE

running "Don't automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false

running "Remove the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0

running "Remove the animation when hiding/showing the Dock"
defaults write com.apple.dock autohide-time-modifier -float 0

# running "Enable the 2D Dock"
# defaults write com.apple.dock no-glass -bool TRUE

# running "Disable the Launchpad gesture (pinch with thumb and three fingers)"
# defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

running "Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool TRUE

running "Make Dock icons of hidden applications translucent"
defaults write com.apple.dock showhidden -bool TRUE

running "Make Dock more transparent"
defaults write com.apple.dock hide-mirror -bool TRUE

running "Reset Launchpad, but keep the desktop wallpaper intact"
find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

running "Add iOS Simulator to Launchpad"
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app" "/Applications/iOS Simulator.app"

# running "Add a spacer to the left side of the Dock (where the applications are)"
# defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'

# running "Add a spacer to the right side of the Dock (where the Trash is)"
# defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

action "Configuring Hot Corners"
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center

running "Top left screen corner → Mission Control"
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
running "Top right screen corner → Desktop"
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
running "Bottom left screen corner → Start screen saver"
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0
running  "Bottom right screen corner → empty"
defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock wvous-br-modifier -int 0; ok

###############################################################################
action "Configuring Safari & WebKit"
###############################################################################

running "Privacy: don't send search queries to Apple"
defaults write com.apple.Safari UniversalSearchEnabled -bool false; ok

running "Press Tab to highlight each item on a web page"
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool TRUE
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool TRUE; ok

running "Show the full URL in the address bar (note: this still hides the scheme)"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool TRUE; ok

running "Set Safari's home page to ‘about:blank' for faster loading"
defaults write com.apple.Safari HomePage -string "about:blank"

running "Prevent Safari from opening ‘safe' files automatically after downloading"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

running "Allow hitting the Backspace key to go to the previous page in history"
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool TRUE

running "Hide Safari's bookmarks bar by default"
defaults write com.apple.Safari ShowFavoritesBar -bool false

running "Hide Safari's sidebar in Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

running "Disable Safari's thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

running "Enable Safari's debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool TRUE

running "Make Safari's search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

running "Remove useless icons from Safari's bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

running "Enable the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool TRUE
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool TRUE
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool TRUE

running "Add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool TRUE

###############################################################################
action "Configuring Mail"
###############################################################################

running "Disable send and reply animations in Mail.app"
defaults write com.apple.mail DisableReplyAnimations -bool TRUE
defaults write com.apple.mail DisableSendAnimations -bool TRUE

running "Copy email addresses as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

running "Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app"
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" -string "@\\U21a9"

running "Display emails in threaded mode, sorted by date (oldest at the top)"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

running "Disable inline attachments (just show the icons)"
defaults write com.apple.mail DisableInlineAttachmentViewing -bool TRUE

running "Disable automatic spell checking"
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

###############################################################################
action "Spotlight"
###############################################################################

# running "Hide Spotlight tray-icon (and subsequent helper)"
# sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search

running "Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed"
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
running "Change indexing order and disable some file types from being indexed"
defaults write com.apple.spotlight orderedItems -array \
  '{"enabled" = 1;"name" = "APPLICATIONS";}' \
  '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
  '{"enabled" = 1;"name" = "DIRECTORIES";}' \
  '{"enabled" = 1;"name" = "PDF";}' \
  '{"enabled" = 1;"name" = "FONTS";}' \
  '{"enabled" = 0;"name" = "DOCUMENTS";}' \
  '{"enabled" = 0;"name" = "MESSAGES";}' \
  '{"enabled" = 0;"name" = "CONTACT";}' \
  '{"enabled" = 0;"name" = "EVENT_TODO";}' \
  '{"enabled" = 0;"name" = "IMAGES";}' \
  '{"enabled" = 0;"name" = "BOOKMARKS";}' \
  '{"enabled" = 0;"name" = "MUSIC";}' \
  '{"enabled" = 0;"name" = "MOVIES";}' \
  '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
  '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
  '{"enabled" = 0;"name" = "SOURCE";}'
running "Load new settings before rebuilding the index"
killall mds > /dev/null 2>&1
running "Make sure indexing is enabled for the main volume"
sudo mdutil -i on / > /dev/null 2>&1
#running "Rebuild the index from scratch"
#sudo mdutil -E / > /dev/null 2>&1

###############################################################################
action "Terminal & iTerm2"
###############################################################################

running "Only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4

running "Use a modified version of the Solarized Dark theme by default in Terminal.app"
TERM_PROFILE='Solarized Dark xterm-256color';
CURRENT_PROFILE="$(defaults read com.apple.terminal 'Default Window Settings')";
if [ "${CURRENT_PROFILE}" != "${TERM_PROFILE}" ]; then
  open "$BOXROOTDIR/lib/box-defaults/config/${TERM_PROFILE}.terminal";
  sleep 1; # Wait a bit to make sure the theme is loaded
  defaults write com.apple.terminal 'Default Window Settings' -string "${TERM_PROFILE}";
  defaults write com.apple.terminal 'Startup Window Settings' -string "${TERM_PROFILE}";
fi;
ok

#running "Enable 'focus follows mouse' for Terminal.app and all X11 apps"
# i.e. hover over a window and start typing in it without clicking first
#defaults write com.apple.terminal FocusFollowsMouse -bool TRUE
#defaults write org.x.X11 wm_ffm -bool TRUE

running "Installing the Solarized Dark theme for iTerm (opening file)"
open "$BOXROOTDIR/assets/Solarized Dark.itermcolors"

running "Don't display the annoying prompt when quitting iTerm"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false
running "hide tab title bars"
defaults write com.googlecode.iterm2 HideTab -bool TRUE
running "set system-wide hotkey to show/hide iterm with ^\`"
defaults write com.googlecode.iterm2 Hotkey -bool TRUE;
defaults write com.googlecode.iterm2 HotkeyChar -int 96;
defaults write com.googlecode.iterm2 HotkeyCode -int 50;
defaults write com.googlecode.iterm2 HotkeyModifiers -int 262401;
ok

# running "Make iTerm2 load new tabs in the same directory"
# defaults export com.googlecode.iterm2 /tmp/plist
# /usr/libexec/PlistBuddy -c "set \"New Bookmarks\":0:\"Custom Directory\" Recycle" /tmp/plist
# defaults import com.googlecode.iterm2 /tmp/plist

###############################################################################
action "Time Machine"
###############################################################################

running "Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool TRUE

running "Disable local Time Machine backups"
hash tmutil > /dev/null 2>&1 && sudo tmutil disablelocal

###############################################################################
action "Activity Monitor"
###############################################################################

running "Show the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool TRUE

running "Visualize CPU usage in the Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5

running "Show all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0

running "Sort Activity Monitor results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
action "Address Book, Dashboard, iCal, TextEdit, and Disk Utility"
###############################################################################

running "Enable the debug menu in Address Book"
defaults write com.apple.addressbook ABShowDebugMenu -bool TRUE

running "Enable Dashboard dev mode (allows keeping widgets on the desktop)"
defaults write com.apple.dashboard devmode -bool TRUE

running "Enable the debug menu in iCal (pre-10.8)"
defaults write com.apple.iCal IncludeDebugMenu -bool TRUE

running "Use plain text mode for new TextEdit documents"
defaults write com.apple.TextEdit RichText -int 0

running "Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

running "Enable the debug menu in Disk Utility"
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool TRUE
defaults write com.apple.DiskUtility advanced-image-options -bool TRUE

###############################################################################
action "Mac App Store"
###############################################################################

running "Enable the WebKit Developer Tools in the Mac App Store"
defaults write com.apple.appstore WebKitDeveloperExtras -bool TRUE

running "Enable Debug Menu in the Mac App Store"
defaults write com.apple.appstore ShowDebugMenu -bool TRUE

###############################################################################
action "Messages"
###############################################################################

running "Disable automatic emoji substitution (i.e. use plain text smileys)"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

running "Disable smart quotes as it's annoying for messages that contain code"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

running "Disable continuous spell checking"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

###############################################################################
# GPGMail 2                                                                   #
###############################################################################

# Disable signing emails by default
defaults write ~/Library/Preferences/org.gpgtools.gpgmail SignNewEmailsByDefault -bool false

###############################################################################
action "Google Chrome & Google Chrome Canary"
###############################################################################

running "Allow installing user scripts via GitHub Gist or Userscripts.org"
defaults write com.google.Chrome ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"
defaults write com.google.Chrome.canary ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"

running "Disable the all too sensitive backswipe"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false; ok

running "Use the system-native print preview dialog"
defaults write com.google.Chrome DisablePrintPreview -bool TRUE
defaults write com.google.Chrome.canary DisablePrintPreview -bool TRUE; ok

# keeping this in place might stop a multi pacage install.. find a better way
# ###############################################################################
# # Kill affected applications                                                  #
# ###############################################################################
# action "OK. Note that some of these changes require a logout/restart to take effect. Killing affected applications (so they can reboot)...."
# for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
#   "Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" \
#   "iCal" "Terminal"; do
#   killall "${app}" > /dev/null 2>&1
# done
