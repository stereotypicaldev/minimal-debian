#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# Trap cleanup on exit or interruption
cleanup() {
    [[ -n "${SSH_AGENT_PID:-}" ]] && eval "$(ssh-agent -k)" >/dev/null 2>&1
}
trap cleanup EXIT INT TERM

# Function to show errors and exit
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Restrictive file creation
umask 077

# Prompt for SSH key comment
read -rp "Enter a comment for your SSH key (e.g., GitHub Key): " key_comment
echo "$key_comment" | grep -Eq '^[a-zA-Z0-9 _-]+$' || error_exit "Invalid comment. Use only letters, numbers, spaces, underscores, or hyphens."

# SSH key location
key_file="$HOME/.ssh/id_ed25519_github"
generate_key=true

# Check if key already exists
if [ -f "$key_file" ]; then
    read -rp "Key file already exists. Overwrite? (y/N): " overwrite
    overwrite=${overwrite:-N}
    if [[ "$overwrite" =~ ^[Yy]$ ]]; then
        rm -f "$key_file" "$key_file.pub" || error_exit "Could not remove old key."
    else
        echo "Skipping key generation."
        generate_key=false
    fi
fi

# Generate key if requested
if [ "$generate_key" = true ]; then
    ssh-keygen -q -t ed25519 -a 100 -C "$key_comment" -f "$key_file" || error_exit "SSH keygen failed"
    chmod 700 "$HOME/.ssh" || error_exit "Failed to set permissions on ~/.ssh"
    chmod 600 "$key_file" || error_exit "Failed to set permissions on private key"
    chmod 644 "${key_file}.pub" || error_exit "Failed to set permissions on public key"
fi

# Attempt to copy public key to clipboard
if command -v wl-copy >/dev/null; then
    if wl-copy < "${key_file}.pub"; then
        echo -e "\nSSH public key copied to clipboard."
    else
        echo -e "\nCould not access Wayland clipboard. Please copy the key manually:"
        cat "${key_file}.pub"
    fi
else
    echo -e "\nwl-copy not found. Please copy the key manually:"
    cat "${key_file}.pub"
fi

# Add an empty line before browser info
echo

# Open GitHub SSH keys page silently
echo "Opening GitHub SSH keys page in your browser..."
command -v xdg-open >/dev/null && xdg-open "https://github.com/settings/keys" >/dev/null 2>&1 &

# Add another empty line before prompt
echo

# Wait for user confirmation
read -rp "Press Enter after you've added the key to GitHub..."

# Start ssh-agent silently
eval "$(ssh-agent -s 2>/dev/null | grep -Ev 'Agent pid')" || error_exit "Failed to start ssh-agent"

# Add private key
ssh-add "$key_file" >/dev/null || error_exit "Failed to add key to ssh-agent"

# Final verification: ensure key is active and authentication works
ssh-add "$key_file" >/dev/null || error_exit "Failed to add key to ssh-agent again"

echo -e "\nTesting SSH authentication with GitHub..."
ssh -T git@github.com