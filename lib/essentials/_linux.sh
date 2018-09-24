#!/usr/bin/env bash

action "Update apt cache"
  (sudo "$PM" update > /dev/null 2>&1)
ok

#########################################################
action "Installing build tools"
  (
    sudo "$PM" -y install \
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
      iproute2 \
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
