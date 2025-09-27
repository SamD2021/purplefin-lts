#!/bin/bash
set -ouex pipefail

mkdir -p /etc/xdg-desktop-portal

tee /etc/xdg-desktop-portal/portals.conf >/dev/null <<'EOF'
[preferred]
# Default: GNOME first, then GTK fallback
default=gnome;gtk;

# Explicit mappings
org.freedesktop.impl.portal.FileChooser=gnome;gtk;
org.freedesktop.impl.portal.Secret=gnome-keyring;gnome;gtk;
org.freedesktop.impl.portal.Screenshot=gnome;gtk;
org.freedesktop.impl.portal.Wallpaper=gnome;gtk;

# Screen sharing / remote desktop
org.freedesktop.impl.portal.ScreenCast=gnome;gtk;
org.freedesktop.impl.portal.RemoteDesktop=gnome;gtk;

# Notifications
org.freedesktop.impl.portal.Notification=gnome;gtk;

# Background apps
org.freedesktop.impl.portal.Background=gnome;gtk;

# Location (if needed)
org.freedesktop.impl.portal.Location=gnome;gtk;
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
