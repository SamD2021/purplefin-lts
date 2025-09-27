#!/bin/bash
set -ouex pipefail

mkdir -p /etc/xdg-desktop-portal

tee /etc/xdg-desktop-portal/portals.conf >/dev/null <<'EOF'
[preferred]
# use GNOME/GTK backends by default
default=gnome;gtk;

# be explicit for common interfaces
org.freedesktop.impl.portal.FileChooser=gnome;gtk;
org.freedesktop.impl.portal.Secret=gnome-keyring;gnome;gtk;
org.freedesktop.impl.portal.Screenshot=gnome;gtk;
org.freedesktop.impl.portal.Wallpaper=gnome;gtk;
EOF

dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm

dnf copr enable -y ligenix/enterprise-cosmic rhel+epel-10-x86_64

dnf install -y \
  cosmic-desktop \
  tmux \
  NetworkManager-openvpn \
  NetworkManager-openvpn-gnome &&
  dnf clean all

dnf copr disable ligenix/enterprise-cosmic

systemctl enable podman.socket
