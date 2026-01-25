#!/usr/bin/env bash
# Setup desktop environment (requires VM with display)
set -e

echo "[INFO] Installing desktop environment..."

sudo apt-get install -y \
    xorg lightdm lightdm-gtk-greeter x11-xserver-utils \
    i3 i3status i3lock dunst pavucontrol arandr feh picom flameshot

sudo systemctl enable lightdm

# i3 as default session
sudo mkdir -p /etc/lightdm/lightdm.conf.d
echo -e "[Seat:*]\nuser-session=i3" | sudo tee /etc/lightdm/lightdm.conf.d/50-i3.conf >/dev/null

# Ghostty
command -v snap &>/dev/null || sudo apt-get install -y snapd
sudo snap install ghostty --classic

# Chrome
command -v google-chrome &>/dev/null || {
    wget -qO /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt-get install -y /tmp/chrome.deb
    rm /tmp/chrome.deb
}

# Cascadia Code fonts
if [[ ! -d "$HOME/.local/share/fonts/cascadia-code" ]]; then
    wget -qO /tmp/cascadia.zip "https://github.com/microsoft/cascadia-code/releases/download/v2407.24/CascadiaCode-2407.24.zip"
    unzip -q /tmp/cascadia.zip -d /tmp/cascadia
    mkdir -p "$HOME/.local/share/fonts/cascadia-code"
    cp /tmp/cascadia/ttf/*.ttf "$HOME/.local/share/fonts/cascadia-code/"
    fc-cache -f
    rm -rf /tmp/cascadia /tmp/cascadia.zip
fi

echo "[OK] Desktop ready. Reboot to start LightDM."
