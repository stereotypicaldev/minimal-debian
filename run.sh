#!/bin/bash

# SCRIPT NAME: cleanup.sh
# DESCRIPTION: Aggressively purges unnecessary packages and their dependencies/configs
# from a minimal Debian 13 server intended for dedicated network services.
# FOCUS: Only package management (interactive purge).

# --- Configuration & Hardening ---
# Exit immediately if a command exits with a non-zero status
set -e
set -u       # Treat unset variables as an error
set -o pipefail # Set exit status of a pipeline to status of last command that exited with non-zero status

# --- 1. Pre-Flight Check: Root Permissions and Input Files ---
if [ "$EUID" -ne 0 ]; then
  echo "!!! FATAL ERROR: Insufficient Permissions !!!"
  echo "This script must be run as root to perform system cleaning and package removal."
  echo "Please execute it using 'sudo ./cleanup.sh'"
  exit 1
fi

# Check for packages.txt file
if [ ! -f "packages.txt" ]; then
    echo "!!! FATAL ERROR: Missing Input File !!!"
    echo "The required file 'packages.txt' was not found in the current directory."
    echo "Please create 'packages.txt' with one package name per line."
    exit 1
fi

# Check for wildcards.txt file
if [ ! -f "wildcards.txt" ]; then
    echo "!!! FATAL ERROR: Missing Input File !!!"
    echo "The required file 'wildcards.txt' was not found in the current directory."
    echo "Please create 'wildcards.txt' with one package wildcard per line (e.g., 'libreoffice*')."
    exit 1
fi

# --- Error Handling & Trapping ---
# Function to execute when an error occurs
error_exit() {
    echo ""
    echo "!!! CRITICAL ERROR (Failure Point Detected) !!!"
    # $? is the exit status of the most recently executed command
    echo "The script exited with an error status ($?)."
    echo "This usually means: 1) Network failure during update/purge, or 2) APT repository issue."
    echo "Check the last output message for details on the failure."
    exit 1
}

# Trap non-zero exit status (exit code 1-255) and call error_exit function
trap error_exit ERR

echo "--- Starting Debian 13 Minimal Server Package Purge (Running as Root) ---"

# --- 2. Define Unnecessary Packages ---
# NOTE: Hardcoded UNNEEDED_PACKAGES array was removed. Package list is now read from packages.txt.

# Note: Section 3 (Utility Function) was removed to support direct apt calls in the interactive loop.

# --- 4. Targeted Kernel Purge Function ---
purge_old_kernels() {
    
    # This keeps the currently running kernel (`uname -r`) and removes older ones.
    # Note: Use of '|| true' after grep -v prevents 'set -o pipefail' from exiting 
    # if no old kernels are found (grep -v returns 1 in that case).
    local old_kernels
    old_kernels=$(dpkg -l | awk '/^ii.*linux-(image|headers)/ {print $2}' | grep -v "$(uname -r)" || true | tr '\n' ' ')
    
    if [ ! -z "$old_kernels" ]; then
        # Use 'remove' here, as APT handles purging the associated configs for kernel packages.
        # Removed '|| true' to allow trap ERR to catch actual APT errors.
        apt remove -y $old_kernels
    else
        # No old kernels to remove, continue silently
        :
    fi
}

# --- 5. Core Cleanup Operations (Interactive & Non-Interactive) ---

# Network/Repository Check
apt update -y

# 5a. Interactive Package Removal Loop - READING FROM packages.txt
echo "--- Starting Interactive Package Purge from packages.txt ---"
# Read package names line by line from the input file
while IFS= read -r package; do
    # Trim whitespace, skip empty lines and lines starting with '#' (comments)
    package=$(echo "$package" | xargs)
    if [[ -z "$package" || "$package" =~ ^# ]]; then
        continue
    fi

    # Check if the package is installed before prompting (suppress errors from dpkg)
    if dpkg -s "$package" 2>/dev/null | grep -q 'Status: install'; then
        read -r -p "Purge package '$package' and its configuration files? [y/N]: " confirmation
        if [[ "$confirmation" =~ ^[Yy]$ ]]; then
            # Execute purge with auto-remove and ignore-missing for robustness
            apt purge --ignore-missing --auto-remove -y "$package"
        fi
    fi
done < "packages.txt" # Read input from the file

# 5b. Non-Interactive Wildcard Removal Loop - READING FROM wildcards.txt
echo "--- Starting Non-Interactive Wildcard Purge from wildcards.txt (DANGER: Fully automated) ---"
# Read wildcards line by line from the input file
while IFS= read -r wildcard; do
    # Trim whitespace, skip empty lines and lines starting with '#' (comments)
    wildcard=$(echo "$wildcard" | xargs)
    if [[ -z "$wildcard" || "$wildcard" =~ ^# ]]; then
        continue
    fi
    
    echo "Processing pattern: $wildcard"
    # Execute purge with auto-remove and ignore-missing. This is NON-INTERACTIVE.
    # The 'ignore-missing' handles cases where the wildcard matches nothing or packages that aren't installed.
    # Note: If a wildcard matches core system components, this will attempt removal. Use patterns carefully.
    apt purge --ignore-missing --auto-remove -y "$wildcard"
    
done < "wildcards.txt" # Read input from the file


# Purge Old Kernels
purge_old_kernels

# Dependency Cleanup (This is critical: autoremove with --purge ensures dependencies and their configs are purged)
apt autoremove --purge -y

# Cache Cleanup (Removes downloaded .deb files)
apt autoclean -y

# --- 6. Final Message ---
trap - ERR # Disable the trap before the successful exit message
echo ""
echo "--- Cleanup Complete! ---"
echo "Your Debian server is now ruthlessly optimized. All targeted packages, their configuration files, and orphaned dependencies have been fully purged (subject to your confirmation)."
echo ""
