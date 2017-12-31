#!/usr/bin/env bash

#test if aptitude exists and default to using that if possible
if command -v aptitude >/dev/null 2>&1 ; then
  pm="aptitude"
else
  pm="apt-get"
fi

action "Update apt cache"
  (sudo $pm update > /dev/null 2>&1)
ok

#########################################################
action "Installing build tools"
  (
    sudo $pm -y install \
      autoconf \
      automake \
      bison \
      build-essential \
      module-assistant \
      clang \
      curl \
      direnv \
      git \
      jq \
      most \
      libxslt1.1 \
      libssl-dev \
      libxslt1-dev \
      libxml2 \
      libxml2-dev \
      libffi-dev \
      libyaml-dev \
      libxslt-dev \
      libc6-dev \
      libreadline-dev \
      libcurl4-openssl-dev \
      libtool \
      openssl \
      xclip \
      zlib1g \
      zlib1g-dev \
      wget \
      zsh > /dev/null 2>&1
  )

ok

#########################################################
