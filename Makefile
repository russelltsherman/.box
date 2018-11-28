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

# everything, geared towards to be run for setup and maintenance
all: \
	brew \
	clean \
	dotfiles \
	vscode

# bootstrap only, add one-time bootstrap tasks here
# setups everything
# restore .gnupg and thus decrypt the secrets from this repository
# setup ssh config (relies on decrypted repository)
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

endif

.PHONY: clean
clean: # if there are existing symlinks for our dotfiles in ~/ remove them
	for file in $(DOTFILE_NAMES) ; do if [ -L ~/$$file ];then rm ~/$$file; fi; done

.PHONY: dotfiles
dotfiles: $(DOTFILES) # iterate our list of dotfiles and ensure they are symlinked

~/.%: # create symlink form ~/.dotfile and ./dotfiles/.dotfile
	cd ~ && ln -sv $(current_dir)/dotfiles/$(notdir $@) $@

.PHONY: vscode
vscode:
	code --install-extension coolbear.systemd-unit-file
	code --install-extension cssho.vscode-svgviewer
	code --install-extension DavidAnson.vscode-markdownlint
	code --install-extension dbaeumer.vscode-eslint
	code --install-extension EditorConfig.EditorConfig
	code --install-extension esbenp.prettier-vscode
	code --install-extension idleberg.applescript
	code --install-extension jaysonsantos.vscode-flake8
	code --install-extension mauve.terraform
	code --install-extension ms-python.python
	code --install-extension ms-vscode.Go
	code --install-extension msjsdiag.debugger-for-chrome
	code --install-extension PeterJausovec.vscode-docker
	code --install-extension PKief.material-icon-theme
	code --install-extension timonwong.shellcheck
	code --install-extension WakaTime.vscode-wakatime
	code --install-extension wholroyd.jinja
