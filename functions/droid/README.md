# droid: tools for android devices
* unlock/relock bootloader
* install bootloader recovery tool
* root/unroot device
* factory restore (unroot) device
* Install Kali NetHunter
* Install timurs kernel extensions

currently only supports Nexus 7 devices

use at your own risk.

###Install and Initialize:
```bash
git clone git@github.com:bhedana/droid.git ~/.droid
~/.droid/bin/droid init
```
follow instructions to add droid to your path

###Download required factory image files:
```bash
~/.droid/bin/droid download
```

###See what other commands are available:
```bash
~/.droid/bin/droid help
```
