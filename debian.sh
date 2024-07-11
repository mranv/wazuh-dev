#!/bin/bash

# Log file to capture errors
LOG_FILE=/tmp/wazuh_setup_errors.log

# Function to append errors to log file
log_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: $*" >> "$LOG_FILE"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   log_error "This script must be run as root" 
   exit 1
fi

# Installing dependencies
apt-get update >> "$LOG_FILE" 2>&1 || log_error "Failed to update repositories"
apt-get install -y build-essential python3 python-is-python3 -y >> "$LOG_FILE" 2>&1 || log_error "Failed to install dependencies"
apt-get install -y gcc g++ make libc6-dev curl policycoreutils automake autoconf libtool libssl-dev -y >> "$LOG_FILE" 2>&1 || log_error "Failed to install dependencies"

# Install CMake 3.18 from sources
curl -OL https://packages.wazuh.com/utils/cmake/cmake-3.18.3.tar.gz && \
tar -zxf cmake-3.18.3.tar.gz && \
cd cmake-3.18.3 && \
./bootstrap --no-system-curl && \
make -j$(nproc) && \
make install && \
cd .. && \
rm -rf cmake-* >> "$LOG_FILE" 2>&1 || log_error "Failed to install CMake"

# Optional: Install Python build dependencies
echo "deb-src http://archive.ubuntu.com/ubuntu $(lsb_release -cs) main" >> /etc/apt/sources.list
apt-get update >> "$LOG_FILE" 2>&1 || log_error "Failed to update repositories"
apt-get build-dep python3 -y >> "$LOG_FILE" 2>&1 || log_error "Failed to install Python build dependencies"

# Installing Wazuh manager
# Download and extract the latest version
cd ~/Desktop/
curl -Ls https://github.com/wazuh/wazuh/archive/v4.8.0.tar.gz | tar zx
cd wazuh-4.8.0

# Clean build if necessary
make -C src clean >> "$LOG_FILE" 2>&1 || log_error "Failed to clean build"

# Clean dependencies if necessary
make -C src clean-deps >> "$LOG_FILE" 2>&1 || log_error "Failed to clean dependencies"

# Print errors logged during script execution
if [ -s "$LOG_FILE" ]; then
    echo "Errors encountered during script execution:"
    cat "$LOG_FILE"
    exit 1
else
    echo "Script executed successfully with no errors."
fi
