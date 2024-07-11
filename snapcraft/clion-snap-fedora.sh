#!/bin/bash

# Log file path
LOG_FILE="/tmp/install_clion.log"

# Function to log messages
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to log and handle errors
log_error() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - ERROR: $1" | tee -a "$LOG_FILE" >&2
    exit 1
}

# Update package list and install snapd
log_message "Updating package list and installing snapd..."
sudo dnf install -y snapd 2>>"$LOG_FILE" || log_error "Failed to install snapd."

# Restart the system to update snap's paths
log_message "Restarting the system to update snap's paths..."
log_message "You will need to log back in after the restart to continue the installation."
sudo reboot || log_error "Failed to reboot the system."

# Wait for user to log back in
log_message "Please log back in to continue the installation."

# Create a symbolic link for classic snap support
log_message "Enabling classic snap support..."
sudo ln -s /var/lib/snapd/snap /snap 2>>"$LOG_FILE" || log_error "Failed to create symbolic link for classic snap support."

# Install CLion
log_message "Installing CLion..."
sudo snap install clion --classic 2>>"$LOG_FILE" || log_error "Failed to install CLion."

log_message "CLion installation completed successfully!"
