#!/bin/bash
set -ouex pipefail

dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm

dnf copr enable -y ligenix/enterprise-cosmic rhel+epel-10-x86_64

dnf install -y \
  cosmic-desktop \
  tmux \
  && dnf clean all

dnf copr disable ligenix/enterprise-cosmic


systemctl enable podman.socket
