#!/usr/bin/env bash
# Create Ubuntu VM with incus for testing dotfiles
set -e

VM_NAME="${1:-dotfiles-test}"
UBUNTU_VERSION="${2:-25.04}"

# Check if VM already exists
if incus info "$VM_NAME" &>/dev/null; then
    echo "[WARN] VM '$VM_NAME' already exists."
    read -rp "Delete existing VM and recreate? [y/N] " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo "[INFO] Deleting existing VM..."
        incus delete "$VM_NAME" --force
    else
        echo "[INFO] Aborted."
        exit 0
    fi
fi

echo "[INFO] Creating Ubuntu $UBUNTU_VERSION VM: $VM_NAME"

# Create VM with desktop-friendly resources
incus init images:ubuntu/$UBUNTU_VERSION/cloud "$VM_NAME" --vm \
    -c limits.cpu=4 \
    -c limits.memory=8GB \
    -d root,size=50GB \
    --network incusbr0

incus start "$VM_NAME"

echo "[INFO] Waiting for VM agent..."
for i in {1..60}; do
    if incus exec "$VM_NAME" -- true 2>/dev/null; then
        break
    fi
    sleep 2
done

# Wait for cloud-init to finish
echo "[INFO] Waiting for cloud-init..."
incus exec "$VM_NAME" -- cloud-init status --wait

# Create user matching host user
echo "[INFO] Creating user: $USER"
incus exec "$VM_NAME" -- useradd -m -s /bin/bash -G sudo "$USER"
incus exec "$VM_NAME" -- bash -c "echo '$USER:test' | chpasswd"
incus exec "$VM_NAME" -- bash -c "echo '$USER ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/$USER"

# Mount dotfiles from host (changes visible in real-time)
echo "[INFO] Mounting dotfiles from host..."
incus config device add "$VM_NAME" dotfiles disk source="$HOME/dotfiles" path="/home/$USER/dotfiles"

echo ""
echo "[OK] VM ready!"
echo ""
echo "Commands:"
echo "  incus exec $VM_NAME -- su - $USER     # Shell access"
echo "  incus console $VM_NAME --type=vga     # GUI console (after desktop install)"
echo ""
echo "To test:"
echo "  cd ~/dotfiles && ./setup.sh && ./setup-desktop.sh"
echo "  sudo reboot"
