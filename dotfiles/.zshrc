# ##############################################################################
# Import the zsh specific environment config
# ##############################################################################
source ~/.zsh/antibody.zsh
source ~/.zsh/bindkeys.zsh
source ~/.zsh/colors.zsh
source ~/.zsh/completion.zsh
source ~/.zsh/exports.zsh
source ~/.zsh/functions.zsh
source ~/.zsh/history.zsh
source ~/.zsh/oh-my-zsh.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/window.zsh
source ~/.zsh/zsh_hooks.zsh

# new env var to hide legacy commands in docker cli
export DOCKER_HIDE_LEGACY_COMMANDS=1

type direnv &>/dev/null && eval "$(direnv hook zsh)"
