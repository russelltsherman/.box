ifeq '$(findstring ;,$(PATH))' ';'
	detected_OS := Windows
else
	detected_OS := $(shell uname 2>/dev/null || echo Unknown)
	detected_OS := $(patsubst CYGWIN%,Cygwin,$(detected_OS))
	detected_OS := $(patsubst MSYS%,MSYS,$(detected_OS))
	detected_OS := $(patsubst MINGW%,MSYS,$(detected_OS))
endif

current_dir = $(shell pwd)
DOTFILE_NAMES := $(subst ./dotfiles/, , $(shell find ./dotfiles -maxdepth 1 -name ".*"))
DOTFILES := $(addprefix ~/, $(DOTFILE_NAMES))

all: \
	brew \
	postbrew \
	dotfiles \
	vscode

bootstrap: \
	all

# OSX Specific targets
ifeq ($(detected_OS),Darwin)

/usr/local/bin/brew:
	ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew analytics off

.PHONY: brew
brew: /usr/local/bin/brew
	brew bundle --file=Brewfile.osx

.PHONY: postbrew
postbrew:
	if ! grep -q "/usr/local/bin/bash" "/etc/shells"; then echo "/usr/local/bin/bash" | sudo tee -a /etc/shells; fi
	if [ ! -f /usr/local/bin/sha256sum ]; then sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum; fi
	if ! grep -q "/usr/local/bin/zsh" "/etc/shells"; then echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells; fi
	chsh -s /usr/local/bin/zsh

.PHONY: defaults
defaults:
	./lib/defaults/_darwin.sh

endif

# Linux specific targets
ifeq ($(detected_OS),Linux)

/usr/local/bin/brew:
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
	# TODO: shits all broke camp - fix this
	# test -d ~/.linuxbrew && PATH="$$HOME/.linuxbrew/bin:$$HOME/.linuxbrew/sbin:$$PATH"
	# test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$$PATH"
	# test -r ~/.bash_profile && echo "export PATH='$$(brew --prefix)/bin:$$(brew --prefix)/sbin'":'"$$PATH"' >>~/.bash_profile
	# echo "export PATH='$$(brew --prefix)/bin:$$(brew --prefix)/sbin'":'"$$PATH"' >>~/.profile

.PHONY: brew
brew: /usr/local/bin/brew
	brew bundle --file=Brewfile.lin

.PHONY: defaults
defaults:
	./lib/defaults/_linux.sh

endif

.PHONY: clean
clean: # if there are existing symlinks for our dotfiles in ~/ remove them
	for file in $(DOTFILE_NAMES) ; do if [ -L ~/$$file ];then rm ~/$$file; fi; done

.PHONY: dotfiles
dotfiles: clean \
	$(DOTFILES) # iterate our list of dotfiles and ensure they are symlinked

/etc/hosts:
	sudo wget -O /etc/hosts https://someonewhocares.org/hosts/hosts

~/.%: # create symlink form ~/.dotfile and ./dotfiles/.dotfile
	cd ~ && ln -sv $(current_dir)/dotfiles/$(notdir $@) $@

.PHONY: vscode
vscode:
	code --install-extension bungcip.better-toml
	code --install-extension coolbear.systemd-unit-file
	code --install-extension cssho.vscode-svgviewer
	code --install-extension DavidAnson.vscode-markdownlint
	code --install-extension dbaeumer.vscode-eslint
	code --install-extension EditorConfig.EditorConfig
	code --install-extension eamodio.gitlens
	code --install-extension formulahendry.auto-close-tag
	code --install-extension HookyQR.beautify
	code --install-extension idleberg.applescript
	code --install-extension mauve.terraform
	code --install-extension ms-python.python
	code --install-extension ms-vscode.Go
	code --install-extension msjsdiag.debugger-for-chrome
	code --install-extension PeterJausovec.vscode-docker
	code --install-extension PKief.material-icon-theme
	code --install-extension timonwong.shellcheck
	code --install-extension tomoki1207.pdf
	code --install-extension WakaTime.vscode-wakatime
	code --install-extension wholroyd.jinja

	mkdir -p ~/Library/Application\ Support/Code/User/
	ln -sv ~/.vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
