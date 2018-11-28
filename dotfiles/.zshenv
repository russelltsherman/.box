#!/usr/bin/env bash
# shellcheck disable=SC2206

export ZDOTDIR="${HOME}"
export BOXROOTDIR="${HOME}/src/github.com/russelltsherman/.box"
export BOXFUNCDIR="${BOXROOTDIR}/functions"

# fpath=($fpath $HOME/.zsh/functions.zsh)
fpath=($fpath "${BOXROOTDIR}/completions")
typeset -U fpath
