
running "Install Atom: A hackable text editor for the 21st Century"
wget https://github.com/atom/atom/releases/download/v1.3.2/atom-amd64.deb
sudo dpkg --install atom-amd64.deb
rm -f atom-amd64.deb
ok

apm install atom-beautify
apm install editorconfig
apm install language-babel
apm install language-docker
apm install language-nginx
apm install language-ldif
apm install linter-eslint
apm install linter
apm install linter-docker
apm install nuclide
apm install vim-mode-plus
