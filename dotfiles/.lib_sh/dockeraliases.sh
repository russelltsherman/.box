#!/bin/bash

# ------------------------------------
# Docker alias and function
# ------------------------------------

dlaunch() {
  local name=$1
  local state
  state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)

  if [[ "$state" == "true" ]]; then
    docker attach $name
  else
    docker rm "$name"
    [[ -s "$HOME/.dockerlaunch/$1" ]] && source "$HOME/.dockerlaunch/$1";
  fi
}

# Get latest container ID
alias dl="docker ps -l -q"

# Get container process
alias dps="docker ps"

# Get process included stop container
alias dpa="docker ps -a"

# Get images
alias di="docker images"

# Get container IP
# alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
dip() { docker inspect $1 | grep IPAddress | awk '{print $2}' | tr -d 'null",\n\r' }

# Run deamonized container, e.g., $dkd base /bin/echo hello
alias dkd="docker run -d -P"

# Run interactive container, e.g., $dki base /bin/bash
alias dki="docker run -i -t -P"

# Execute interactive container, e.g., $dex base /bin/bash
alias dex="docker exec -i -t"

# Stop all containers
dstop() { docker stop $(docker ps -a -q) }

# Remove all containers
drm() { docker rm $(docker ps -a -q) }

# Stop and Remove all containers
alias drmf='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

# Remove all images
dri() { docker rmi $(docker images -q) }

# Dockerfile build, e.g., $dbu tcnksm/test
dbu() { docker build -t=$1 . }

# Show all alias related docker
dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }

# Bash into running container
# dbash() { docker exec -it $(docker ps -aqf "name=$1") bash; }
