#!/bin/bash

# Enforce strict execution policies
set -euo pipefail
IFS=$'\n\t'

# Function to display error messages and exit
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Ensure the script is run with sudo
if [[ "${EUID}" -ne 0 ]]; then
    error_exit "Please run this script with sudo: sudo $0"
fi

# Determine the username of the user executing the script
USERNAME="${SUDO_USER:-$(whoami)}"

# Define the path to the greetd configuration file
CONFIG_FILE="/etc/greetd/config.toml"

# Determine the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Path to the local config.toml
LOCAL_CONFIG="${SCRIPT_DIR}/config.toml"

# Check if the local config.toml exists
if [[ ! -f "${LOCAL_CONFIG}" ]]; then
    error_exit "config.toml not found in the script directory (${SCRIPT_DIR})."
fi

# Create a temporary file for the updated configuration
TEMP_CONFIG="$(mktemp)"

# Ensure the temporary file is deleted upon script exit
cleanup() {
    rm -f "${TEMP_CONFIG}"
}
trap cleanup EXIT

# Replace the empty user field under [initial_session] with the current username
sed -e "/^\[initial_session\]/,/^\[/{s/^user = \"\"/user = \"${USERNAME}\"/}" "${LOCAL_CONFIG}" > "${TEMP_CONFIG}" || error_exit "Failed to update config.toml."

# Replace the existing greetd configuration with the updated one
cp "${TEMP_CONFIG}" "${CONFIG_FILE}" || error_exit "Failed to replace ${CONFIG_FILE}."

# Mask getty on tty1 to prevent conflicts with greetd
systemctl mask getty@tty1.service || error_exit "Failed to mask getty@tty1.service."

# Enable and start the greetd service
systemctl enable greetd.service || error_exit "Failed to enable greetd.service."
systemctl restart greetd.service || error_exit "Failed to restart greetd.service."
