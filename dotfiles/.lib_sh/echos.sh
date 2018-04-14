#!/usr/bin/env bash
# shellcheck disable=SC1117
# shellcheck disable=SC2034

###
# some colorized echo helpers
# @author Adam Eivy
###

# Colors
ESC_SEQ="\x1b["
C_RESET="${ESC_SEQ}39;49;00m"
C_RED="${ESC_SEQ}31;01m"
C_GREEN="${ESC_SEQ}32;01m"
C_YELLOW="${ESC_SEQ}33;01m"
C_BLUE="${ESC_SEQ}34;01m"
C_MAGENTA="${ESC_SEQ}35;01m"
C_CYAN="${ESC_SEQ}36;01m"

################################################################################
# TUI Functions
################################################################################

function banner() {
  clear
  # shellcheck disable=SC1004
  echo -e "$C_GREEN"'
               _                      _
  ___ ___   __| | ___ _ __ ___  _ __ (_)_ __
 / __/ _ \ / _  |/ _ \  __/ _ \|  _ \| |  _ \
| (_| (_) | (_| |  __/ | | (_) | | | | | | | |
 \___\___/ \__,_|\___|_|  \___/|_| |_|_|_| |_|
'"$C_RESET"
}

function line() {
  echo -e "------------------------------------------------------------------------------------"
}

function die() {
  echo -e "\n$*" 1>&2; exit 1;
}

function ok() {
  echo -e "\n${C_GREEN}[ok]${C_RESET} $1"
}

function bot() {
  echo -e "\n${C_GREEN}\[._.]/${C_RESET} - $1"
}

function running() {
  echo -en "\n${C_YELLOW} ⇒ ${C_RESET} $1 ..."
}

function action() {
  echo -e "\n${C_YELLOW}[action]${C_RESET} ⇒ $1 ..."
}

function info() {
  echo -e "\n${C_GREEN}[info]${C_RESET} $1"
}
function warn() {
  echo -e "\n${C_YELLOW}[warning]${C_RESET} $1"
}

function error() {
  echo -e "\n${C_RED}[error]${C_RESET} $1"
}
