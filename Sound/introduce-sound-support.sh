#!/bin/bash

set -e

# Ensure that DBus user session is available
echo "Checking if DBus is available for user session..."
if ! pgrep -u "$USER" -f "dbus-daemon.*--session"; then
    echo "[ERROR] DBus session is not running. Launching DBus..."
    # Start dbus-launch in the current session
    eval $(dbus-launch --sh-syntax)
else
    echo "DBus session is already running."
fi

# Update package list and install PipeWire packages
echo "Updating package list..."
sudo apt update

echo "Installing PipeWire and related packages..."
sudo apt install -y pipewire pipewire-audio-client-libraries pipewire-pulse pavucontrol wireplumber

# Enable and start PipeWire services for the user
echo "Enabling and starting PipeWire services..."

# Enable PipeWire for user session
systemctl --user enable --now pipewire
systemctl --user enable --now pipewire-pulse

# Ensure that PipeWire services are running
echo "Checking PipeWire status..."
systemctl --user status pipewire pipewire-pulse
