#!/usr/bin/env bash
# Create Ubuntu VM with incus for testing dotfiles
set -e

VM_NAME="${1:-dotfiles-test}"
UBUNTU_VERSION="${2:-25.04}"

echo "[INFO] Creating Ubuntu $UBUNTU_VERSION VM: $VM_NAME"

# Create VM with desktop-friendly resources
incus launch images:ubuntu/$UBUNTU_VERSION/cloud "$VM_NAME" --vm \
    -c limits.cpu=4 \
    -c limits.memory=8GB \
    -d root,size=50GB

echo "[INFO] Waiting for VM to start..."
sleep 10

# Wait for cloud-init to finish
incus exec "$VM_NAME" -- cloud-init status --wait

# Create user matching host user
echo "[INFO] Creating user: $USER"
incus exec "$VM_NAME" -- useradd -m -s /bin/bash -G sudo "$USER"
incus exec "$VM_NAME" -- bash -c "echo '$USER ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/$USER"

# Copy dotfiles into VM
echo "[INFO] Copying dotfiles..."
incus file push -r ~/dotfiles "$VM_NAME/home/$USER/"
incus exec "$VM_NAME" -- chown -R "$USER:$USER" "/home/$USER/dotfiles"

# Enable GUI console access
incus config set "$VM_NAME" raw.qemu="-device virtio-vga-gl -display sdl,gl=on"

echo ""
echo "[OK] VM ready!"
echo ""
echo "Commands:"
echo "  incus exec $VM_NAME -- su - $USER     # Shell access"
echo "  incus console $VM_NAME --type=vga     # GUI console"
echo ""
echo "To test:"
echo "  cd ~/dotfiles && ./setup.sh && ./setup-desktop.sh"
echo "  sudo reboot"
