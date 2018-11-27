ifeq '$(findstring ;,$(PATH))' ';'
	detected_OS := Windows
else
	detected_OS := $(shell uname 2>/dev/null || echo Unknown)
	detected_OS := $(patsubst CYGWIN%,Cygwin,$(detected_OS))
	detected_OS := $(patsubst MSYS%,MSYS,$(detected_OS))
	detected_OS := $(patsubst MINGW%,MSYS,$(detected_OS))
endif

EXCLUDED_DOTFILES := .git .git-crypt .gitattributes .gitignore .gitmodules .ssh
DOTFILES := $(addprefix ~/, $(filter-out $(EXCLUDED_DOTFILES), $(wildcard .*)))

# everything, geared towards to be run for setup and maintenance
all: \
	brew

# bootstrap only, add one-time bootstrap tasks here
# setups everything
# restore .gnupg and thus decrypt the secrets from this repository
# setup ssh config (relies on decrypted repository)
bootstrap: \
	all

ifeq ($(detected_OS),Darwin)
# OSX Specific targets

/usr/local/bin/brew:
	ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew analytics off

brew: /usr/local/bin/brew
	brew bundle --file=Brewfile.osx

endif

ifeq ($(detected_OS),Linux)
# TODO: shits all broke camp - fix this

/usr/local/bin/brew:
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
	# test -d ~/.linuxbrew && PATH="$$HOME/.linuxbrew/bin:$$HOME/.linuxbrew/sbin:$$PATH"
	# test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$$PATH"
	# test -r ~/.bash_profile && echo "export PATH='$$(brew --prefix)/bin:$$(brew --prefix)/sbin'":'"$$PATH"' >>~/.bash_profile
	# echo "export PATH='$$(brew --prefix)/bin:$$(brew --prefix)/sbin'":'"$$PATH"' >>~/.profile

brew: /usr/local/bin/brew
	brew bundle --file=Brewfile.lin

endif

