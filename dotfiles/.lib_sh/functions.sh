source $BOXROOTDIR/dotfiles/.lib_sh/echos.sh
source $BOXROOTDIR/dotfiles/.lib_sh/requirers.sh
source $BOXROOTDIR/dotfiles/.lib_sh/dockerfunctions.sh

################################################################################
# TUI Functions
################################################################################

function banner() {
  clear
  echo -e "$COL_GREEN"'
               _                      _
  ___ ___   __| | ___ _ __ ___  _ __ (_)_ __
 / __/ _ \ / _  |/ _ \  __/ _ \|  _ \| |  _ \
| (_| (_) | (_| |  __/ | | (_) | | | | | | | |
 \___\___/ \__,_|\___|_|  \___/|_| |_|_|_| |_|
'"$COL_RESET"
}

function info() {
  echo -e "$COL_GREEN[info]$COL_RESET "$1
}

function line() {
  echo -e "------------------------------------------------------------------------------------"
}

function die() {
  echo "$@" 1>&2 ; exit 1;
}

function require_vagrant_plugin() {
  running "vagrant plugin $1"
  local vagrant_plugin="$1"
  local vagrant_plugin_version="$2"
  local grepExpect=$vagrant_plugin
  local grepStatus=$(vagrant plugin list | grep "$vagrant_plugin")

  if [[ ! -z "$vagrant_plugin_version" ]]; then
    grepExpect=$grepExpect' ('$vagrant_plugin_version')'
  else
    # we are only looking for the name
    grepStatus=${grepStatus%% *}
  fi

  #echo 'checking if '$grepExpect' is installed via grepStatus: '$grepStatus

  if [[ "$grepStatus" != "$grepExpect" ]]; then
    action "installing vagrant plugin $1 $2"
    if [[ ! -z "$vagrant_plugin_version" ]]; then
      vagrant plugin install "$vagrant_plugin" --plugin-version "$vagrant_plugin_version"
    else
      vagrant plugin install "$vagrant_plugin"
    fi
  fi
  ok
}

function git_clone_or_update() {
  if [ -d "$2/.git" ]; then
    action "update $1"
    (cd "$2"; git pull > /dev/null 2>&1)
    ok
  else
    action "clone $1"
    git clone "$1" "$2" > /dev/null 2>&1
    ok
  fi
}

function get_platform() {
  if [ "$(uname -s)" == "Darwin" ]; then
    # Do something for OSX
    export NS_PLATFORM="darwin"
    running "darwin platform detected"
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  	# Do something for Linux platform
  	# assume ubuntu - but surely this can be extended to include other distros
  	export NS_PLATFORM="linux"
    running "linux platform detected"
  elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Do something for Windows NT platform
  	export NS_PLATFORM="windows"
    running "windoze platform detected"
    die "Windows not supported"
  fi
  ok
}

function get_osx_version() {
  if [ "$NS_PLATFORM" == "darwin" ]; then
    IFS='.' read -r -a vers <<< $(sw_vers -productVersion)
    case ${vers[1]} in
      1)
        export OSX_VERSION="Cheeta/Puma"
        ;;
      2)
        export OSX_VERSION="Jaguar"
        ;;
      3)
        export OSX_VERSION="Panther"
        ;;
      4)
        export OSX_VERSION="Tiger"
        ;;
      5)
        export OSX_VERSION="Snow Leopard"
        ;;
      6)
        export OSX_VERSION="Lion"
        ;;
      7)
        export OSX_VERSION="Mountain Lion"
        ;;
      8)
        export OSX_VERSION="Mavericks"
        ;;
      9)
        export OSX_VERSION="Yosemite"
        ;;
      10)
        export OSX_VERSION="Mavericks"
        ;;
      11)
        export OSX_VERSION="El Capitan"
        ;;
      12)
        export OSX_VERSION="Sierra"
        ;;
      13)
        export OSX_VERSION="High Sierra"
        ;;
      *)
        export OSX_VERSION="Unknown"
        ;;
    esac
    running "OSX $OSX_VERSION detected"
  fi
}


function profile_write {
  # try to ensure we don't create duplicate entries in the file
  action "ensure that $1 exists in $2"
  touch $2
  if ! grep -q "$1" "$2" ; then
    echo "$1" >> "$2"
  fi
  ok
}

function sudo_write {
  # try to ensure we don't create duplicate entries in the file
  action "ensure that $1 exists in $2"
  sudo "$BASH" -c "touch $2"
  if ! grep -q "$1" "$2" ; then
    sudo "$BASH" -c "echo \"$1\" >> \"$2\""
  fi
  ok
}

function file_writeln {
  # try to ensure we don't create duplicate entries in the .coderonin file
  touch $1
  action "ensure that $2 exists in $1"
  if ! grep -q "$2" "$1"; then
    echo writing
    echo "$2" >> "$1"
  fi
  ok
}

# I help write config vars on raspberry pi
function set_config_var() {
  lua - "$1" "$2" "$3" <<EOF > "$3.bak"
local key=assert(arg[1])
local value=assert(arg[2])
local fn=assert(arg[3])
local file=assert(io.open(fn))
local made_change=false
for line in file:lines() do
  if line:match("^#?%s*"..key.."=.*$") then
    line=key.."="..value
    made_change=true
  end
  print(line)
end

if not made_change then
  print(key.."="..value)
end
EOF
mv "$3.bak" "$3"
}

function select_droid {
  bot "Which Device"
    echo "1. Nexus 7 2012 WiFi only (grouper)"
    echo "2. Nexus 7 2013 Wifi only (flo)"
    echo "3. Nexus 7 2013 LTE only (deb)"
    echo "Select then press enter"
    read device

    if [ $device = 1 ] ; then
      product='grouper'
      suzip='UPDATE-SuperSU-v1.45.zip'
      clockwork='recovery-clockwork-touch-6.0.4.3-grouper.img'
      teamwin='twrp-3.1.1-0-grouper.img'

    fi
    if [ $device = 2 ] ; then
      product='flo'
      suzip='SuperSU-v2.82-201705271822'
      clockwork='recovery-clockwork-touch-6.0.4.7-flo.img'
      teamwin='twrp-3.1.1-0-flo.img'
    fi
    if [ $device = 3 ] ; then
      product='deb'
      suzip='SuperSU-v2.82-201705271822'
      clockwork='recovery-clockwork-touch-6.0.4.8-deb.img'
      teamwin='twrp-3.1.1-0-deb.img'
    fi
}

function symlinkifne {
  running "$1"

  if [[ -e $1 ]]; then
    # file exists
    if [[ -L $1 ]]; then
      # it's already a simlink (could have come from this project)
      echo -en '\tsimlink exists, skipped\t';ok
      return
    fi
    # backup file does not exist yet
    if [[ ! -e ~/.dotfiles_backup/$1 ]];then
      mv $1 ~/.dotfiles_backup/
      echo -en 'backed up saved...';
    fi
  fi
  # create the link
  ln -s ~/.dotfiles/$1 $1
  echo -en '\tlinked';ok
}


################################################################################
# Utility Functions
################################################################################

# Create a new git repo with one README commit and CD into it
function gitnr() { mkdir $1; cd $1; git init; touch README; git add README; git commit -mFirst-commit;}

# Do a Matrix movie effect of falling characters
function matrix1() {
  echo -e "\e[1;40m" ; clear ; while :; do echo $LINES $COLUMNS $(( $RANDOM % $COLUMNS)) $(( $RANDOM % 72 )) ;sleep 0.05; done|gawk '{ letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"; c=$4; letter=substr(letters,c,1);a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}'
}

function matrix2() {
  echo -e "\e[1;40m" ; clear ; characters=$( jot -c 94 33 | tr -d '\n' ) ; while :; do echo $LINES $COLUMNS $(( $RANDOM % $COLUMNS)) $(( $RANDOM % 72 )) $characters ;sleep 0.05; done|gawk '{ letters=$5; c=$4; letter=substr(letters,c,1);a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}'
}

# Use Mac OS Preview to open a man page in a more handsome format
function manp() {
  man -t $1 | open -f -a /Applications/Preview.app
}

# Show normally hidden system and dotfile types of files
# in Mac OS Finder
function showhiddenfiles() {
  defaults write com.apple.Finder AppleShowAllFiles YES
  osascript -e 'tell application "Finder" to quit'
  sleep 0.25
  osascript -e 'tell application "Finder" to activate'
}

# Hide (back to defaults) normally hidden system and dotfile types of files
# in Mac OS Finder
function hidehiddenfiles() {
  defaults write com.apple.Finder AppleShowAllFiles NO
  osascript -e 'tell application "Finder" to quit'
  sleep 0.25
  osascript -e 'tell application "Finder" to activate'
}

## hammer a service with curl for a given number of times
## usage: curlhammer $url
function curlhammer () {
  bot "about to hammer $1 with $2 curls ⇒";
  echo "curl -k -s -D - $1 -o /dev/null | grep 'HTTP/1.1' | sed 's/HTTP\/1.1 //'"
  for i in {1..$2}
  do
    curl -k -s -D - $1 -o /dev/null | grep 'HTTP/1.1' | sed 's/HTTP\/1.1 //'
  done
  bot "done"
}

## curlheader will return only a specific response header or all response headers for a given URL
## usage: curlheader $header $url
## usage: curlheader $url
function curlheader() {
  if [[ -z "$2" ]]; then
    echo "curl -k -s -D - $1 -o /dev/null"
    curl -k -s -D - $1 -o /dev/null:
  else
    echo "curl -k -s -D - $2 -o /dev/null | grep $1:"
    curl -k -s -D - $2 -o /dev/null | grep $1:
  fi
}

## get the timings for a curl to a URL
## usage: curltime $url
function curltime(){
    curl -w "   time_namelookup:  %{time_namelookup}\n\
        time_connect:  %{time_connect}\n\
     time_appconnect:  %{time_appconnect}\n\
    time_pretransfer:  %{time_pretransfer}\n\
       time_redirect:  %{time_redirect}\n\
  time_starttransfer:  %{time_starttransfer}\n\
  --------------------------\n\
        time_total:  %{time_total}\n" -o /dev/null -s "$1"
}

function fixperms(){
    find . \( -name "*.sh" -or -type d \) -exec chmod 755 {} \; && find . -type f ! -name "*.sh" -exec chmod 644 {} \;
}

# Create a new directory and enter it
function mkd() {
  mkdir -p "$@" && cd "$_";
}

# Generate Subresource Integrity hashes.
# 1st argument is the filename.
# 2nd argument, optional, is the hash algorithm
# (currently the allowed prefixes are sha256, sha384, and sha512)
# See http://www.w3.org/TR/SRI/ and
# https://developer.mozilla.org/docs/Web/Security/Subresource_Integrity
function sri() {
  if [ -z "${1}" ]; then
    echo "ERROR: No file specified.";
    return 1;
  fi;
  local algorithm="${2:-sha512}"
  if ! echo "${algorithm}" | egrep -q "^sha(256|384|512)$"; then
    echo "ERROR: hash algorithm must be sha256, sha384 or sha512.";
    return 1;
  fi;
  local filehash=$(openssl dgst "-${algorithm}" -binary "$1" | openssl base64 -A)
  if [ -z "${filehash}" ]; then
    return 1;
  fi;
  echo "${algorithm}-${filehash}";
}

## output directory/file tree, excluding ignorables
function tre(){
  tree -aC -I '.git|node_modules|bower_components|.DS_Store' --dirsfirst "$@"
}

## weather seattle
function weather() {
  curl wttr.in/$1
}
