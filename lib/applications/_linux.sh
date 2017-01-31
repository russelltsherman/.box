
running "Install Atom: A hackable text editor for the 21st Century"
wget https://github.com/atom/atom/releases/download/v1.3.2/atom-amd64.deb
sudo dpkg --install atom-amd64.deb
rm -f atom-amd64.deb
ok

require_apm atom-beautify
require_apm editorconfig
require_apm language-babel
require_apm language-docker
require_apm language-nginx
require_apm language-ldif
require_apm linter-eslint
require_apm linter
require_apm linter-docker
require_apm nuclide
require_apm vim-mode-plus
