#!/bin/bash

# Hardcoded links
API_URL="https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release"

set -e
set -o pipefail

TMP_DIR="/tmp"
INSTALL_DIR="$HOME/.local/share/JetBrains/Toolbox/bin"
SYMLINK_DIR="$HOME/.local/bin"

# Colors
BLUE='\033[1;34m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

echo -e "${BLUE}Fetching the URL of the latest version...${NC}"
ARCHIVE_URL=$(curl -s "$API_URL" | grep -Po '"linux":.*?[^\\]",' | awk -F ':"' '{print $2}' | sed 's/[", ]//g')
ARCHIVE_FILENAME=$(basename "$ARCHIVE_URL")

echo -e "${BLUE}Downloading $ARCHIVE_FILENAME...${NC}"
rm -f "$TMP_DIR/$ARCHIVE_FILENAME" 2>/dev/null || true
wget -q -O "$TMP_DIR/$ARCHIVE_FILENAME" "$ARCHIVE_URL"

echo -e "${BLUE}Extracting to $INSTALL_DIR...${NC}"
mkdir -p "$INSTALL_DIR"
rm -rf "$INSTALL_DIR/*" 2>/dev/null || true
tar -xzf "$TMP_DIR/$ARCHIVE_FILENAME" -C "$INSTALL_DIR" --strip-components=1
rm -f "$TMP_DIR/$ARCHIVE_FILENAME"
chmod +x "$INSTALL_DIR/jetbrains-toolbox"

echo -e "${BLUE}Symlinking to $SYMLINK_DIR/jetbrains-toolbox...${NC}"
mkdir -p "$SYMLINK_DIR"
rm -f "$SYMLINK_DIR/jetbrains-toolbox" 2>/dev/null || true
ln -s "$INSTALL_DIR/jetbrains-toolbox" "$SYMLINK_DIR/jetbrains-toolbox"

if [ -z "$CI" ]; then
    echo -e "${BLUE}Running for the first time to set up...${NC}"
    ( "$INSTALL_DIR/jetbrains-toolbox" & )
    echo -e "\n${GREEN}Done! JetBrains Toolbox should now be running, in your application list, and you can run it in terminal as jetbrains-toolbox (ensure that $SYMLINK_DIR is on your PATH)${NC}\n"
else
    echo -e "\n${GREEN}Done! Running in a CI -- skipped launching the AppImage.${NC}\n"
fi
