#!/bin/bash

# Download JetBrains Toolbox
curl -L https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-2.4.0.32175.tar.gz -o jetbrains-toolbox-2.4.0.32175.tar.gz

# Extract the downloaded tar.gz file
tar -xzvf jetbrains-toolbox-2.4.0.32175.tar.gz

# Change directory to the extracted folder
cd jetbrains-toolbox-2.4.0.32175/

# Make the toolbox executable
chmod +x jetbrains-toolbox

# Run JetBrains Toolbox
./jetbrains-toolbox
