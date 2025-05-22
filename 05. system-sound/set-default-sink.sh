#!/bin/bash

# Constants for Service and File Paths
SERVICE_NAME="set-default-sink.service"
SERVICE_FILE="$HOME/.config/systemd/user/$SERVICE_NAME"
SINK_NAME="alsa_output.pci-0000_08_00.1.pro-output-3"
SESSION_WAIT_TIME=5  # Time in seconds to wait for Sway to initialize
LOG_FILE="/tmp/set-default-sink.log"  # Temporary log file that will be removed after execution
TEMP_SERVICE_FILE="/tmp/$SERVICE_NAME"  # Temporary service file

# Function to handle errors and exit gracefully
handle_error() {
    echo "[ERROR] $1" | tee -a "$LOG_FILE"
    cleanup
    exit 1
}

# Function to handle warnings without terminating the script
handle_warning() {
    echo "[WARNING] $1" | tee -a "$LOG_FILE"
}

# Function to log the command outputs (for debugging purposes)
log_command() {
    echo "[INFO] Executing: $1" | tee -a "$LOG_FILE"
    eval "$1" 2>&1 | tee -a "$LOG_FILE"
}

# Function to clean up and remove traces after script completion
cleanup() {
    echo "[INFO] Cleaning up..." | tee -a "$LOG_FILE"
    # Remove temporary log and service files
    rm -f "$LOG_FILE" "$TEMP_SERVICE_FILE"
    # Remove the script itself (optional)
    # rm -- "$0"
}

# Function to check if Sway session is active
check_sway_session() {
    local attempts=0
    local max_attempts=10
    local session_active=false

    while [[ $attempts -lt $max_attempts ]]; do
        # Check if Sway is running
        if systemctl --user is-active --quiet sway.service; then
            session_active=true
            break
        fi
        sleep 1
        attempts=$((attempts + 1))
    done

    if [[ "$session_active" == false ]]; then
        handle_error "Sway session not active after $max_attempts attempts."
    fi
}

# Step 1: Ensure required directories exist
echo "[INFO] Ensuring required directories exist..." | tee -a "$LOG_FILE"
mkdir -p "$HOME/.config/systemd/user" || handle_error "Failed to create systemd directory."

# Step 2: Check if the service file already exists
if [[ -f "$SERVICE_FILE" ]]; then
    handle_warning "Service file '$SERVICE_FILE' already exists. Skipping creation to avoid overwriting."
    cleanup
    exit 0
fi

# Step 3: Define the service content
SERVICE_CONTENT="[Unit]
Description=Set default audio sink for PipeWire when Sway session starts
After=graphical-session.target  # Ensures it runs after graphical session starts

[Service]
Type=oneshot
ExecStart=/usr/bin/pactl set-default-sink $SINK_NAME
Environment=PIPEWIRE_AUDIO_SINK=$SINK_NAME
ExecStartPost=/bin/sleep 1  # Adding delay to ensure PipeWire has initialized

[Install]
WantedBy=graphical-session.target
"

# Step 4: Create the systemd service file temporarily
echo "[INFO] Creating systemd service file..." | tee -a "$LOG_FILE"
echo "$SERVICE_CONTENT" > "$TEMP_SERVICE_FILE" || handle_error "Failed to write to temporary service file."

# Step 5: Verify service file was created successfully
if [[ ! -f "$TEMP_SERVICE_FILE" ]]; then
    handle_error "Temporary service file '$TEMP_SERVICE_FILE' was not created."
fi

# Step 6: Copy service file to correct location
log_command "cp $TEMP_SERVICE_FILE $SERVICE_FILE" || handle_error "Failed to copy service file to the target location."

# Step 7: Reload the systemd daemon to pick up the new service
log_command "systemctl --user daemon-reload" || handle_error "Failed to reload systemd daemon."

# Step 8: Enable the systemd service
log_command "systemctl --user enable $SERVICE_NAME" || handle_error "Failed to enable the systemd service."

# Step 9: Start the systemd service immediately
log_command "systemctl --user start $SERVICE_NAME" || handle_error "Failed to start the systemd service."

# Step 10: Verify the service is running
if ! systemctl --user is-active --quiet "$SERVICE_NAME"; then
    handle_error "The service is not running after start."
fi

# Step 11: Ensure the service was enabled for the next session
log_command "systemctl --user is-enabled $SERVICE_NAME" || handle_error "Failed to verify that the service is enabled."

# Final Step: Inform the user the process was successful
echo "[INFO] Service successfully created, enabled, and started." | tee -a "$LOG_FILE"
echo "[INFO] The default audio sink will be set on Sway session startup." | tee -a "$LOG_FILE"

# Step 12: Confirm Sway session is active
check_sway_session

# Clean up after script execution
cleanup

# End of script