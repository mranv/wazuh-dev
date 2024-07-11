#!/bin/bash

# Log file to capture errors
LOG_FILE=/tmp/install_script_errors.log

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
sudo yum install -y make cmake gcc gcc-c++ python3 python3-policycoreutils automake autoconf libtool openssl-devel yum-utils >> "$LOG_FILE" 2>&1 || log_error "Failed to install dependencies"

# Install custom GCC version
sudo curl -OL http://packages.wazuh.com/utils/gcc/gcc-9.4.0.tar.gz && \
sudo tar xzf gcc-9.4.0.tar.gz && \
cd gcc-9.4.0/ && \
sudo ./contrib/download_prerequisites && \
sudo ./configure --enable-languages=c,c++ --prefix=/usr --disable-multilib --disable-libsanitizer && \
sudo make -j$(nproc) && \
sudo make install && \
sudo ln -fs /usr/bin/g++ /bin/c++ && \
sudo ln -fs /usr/bin/gcc /bin/cc && \
cd .. && \
sudo rm -rf gcc-* && \
sudo scl enable devtoolset-7 bash >> "$LOG_FILE" 2>&1 || log_error "Failed to install custom GCC"

# Enable Powertools repository
sudo yum-config-manager --enable powertools >> "$LOG_FILE" 2>&1 || log_error "Failed to enable Powertools repository"

# Install libstdc++-static
sudo yum install libstdc++-static -y >> "$LOG_FILE" 2>&1 || log_error "Failed to install libstdc++-static"

# Optional: Install CMake 3.18 from sources
sudo curl -OL https://packages.wazuh.com/utils/cmake/cmake-3.18.3.tar.gz && \
sudo tar -zxf cmake-3.18.3.tar.gz && \
cd cmake-3.18.3 && \
sudo ./bootstrap --no-system-curl && \
sudo make -j$(nproc) && \
sudo make install && \
cd .. && \
sudo rm -rf cmake-* >> "$LOG_FILE" 2>&1 || log_error "Failed to install CMake"

# Export /usr/local/bin to PATH
export PATH=/usr/local/bin:$PATH

# Optional: Install Python build dependencies
sudo yum install epel-release yum-utils -y >> "$LOG_FILE" 2>&1 || log_error "Failed to install epel-release or yum-utils"
sudo yum-builddep python34 -y >> "$LOG_FILE" 2>&1 || log_error "Failed to install Python build dependencies"

# Installing Wazuh manager
# Download and extract the latest version
sudo curl -Ls https://github.com/wazuh/wazuh/archive/v4.8.0.tar.gz | tar zx
cd wazuh-4.8.0

# Clean build if necessary
sudo make -C src clean >> "$LOG_FILE" 2>&1 || log_error "Failed to clean build"

# Clean dependencies if necessary
sudo make -C src clean-deps >> "$LOG_FILE" 2>&1 || log_error "Failed to clean dependencies"

# Print errors logged during script execution
if [ -s "$LOG_FILE" ]; then
    echo "Errors encountered during script execution:"
    cat "$LOG_FILE"
    exit 1
else
    echo "Script executed successfully with no errors."
fi
