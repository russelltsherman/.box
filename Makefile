-include $(shell curl -sSL -o .build-harness "https://raw.githubusercontent.com/russelltsherman/build-harness/master/templates/Makefile.build-harness"; echo .build-harness)

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
	code --install-extension davidwang.ini-for-vscode
	code --install-extension dbaeumer.vscode-eslint
	code --install-extension EditorConfig.EditorConfig
	code --install-extension eamodio.gitlens
	code --install-extension formulahendry.auto-close-tag
	code --install-extension haaaad.ansible
	code --install-extension HookyQR.beautify
	code --install-extension idleberg.applescript
	code --install-extension marcostazi.vs-code-vagrantfile
	code --install-extension mauve.terraform
	code --install-extension ms-python.python
	code --install-extension ms-vscode.Go
	code --install-extension msjsdiag.debugger-for-chrome
	code --install-extension PeterJausovec.vscode-docker
	code --install-extension PKief.material-icon-theme
	code --install-extension bradymholt.pgformatter
	code --install-extension jptarquino.postgresql
	code --install-extension redhat.vscode-yaml
	code --install-extension timonwong.shellcheck
	code --install-extension tomoki1207.pdf
	code --install-extension vscodevim.vim
	code --install-extension WakaTime.vscode-wakatime
	code --install-extension wholroyd.jinja
	code --install-extension xaver.clang-format
	code --install-extension zxh404.vscode-proto3
	code --install-extension esbenp.prettier-vscode


	mkdir -p ~/Library/Application\ Support/Code/User/
	ln -sv ~/.vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
