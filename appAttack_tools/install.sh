#!/bin/bash

# Define installation paths
INSTALL_DIR="/opt/appAttack_toolkit"
BIN_DIR="/usr/local/bin"
ENTRY_SCRIPT="./main.sh"

# Install the toolkit
echo "Installing AppAttack Toolkit..."
mkdir -p "$INSTALL_DIR"
cp -r ./* "$INSTALL_DIR"

# Run the first_run.sh script
#echo "Running first-time setup..."
#(cd "$INSTALL_DIR/toolkit" && ./first_run.sh)

echo "Running first-time setup..."
chmod +x ./first_run.sh # Ensure the script is executable
./first_run.sh

# Create a symlink in /usr/local/bin
ln -sf "$INSTALL_DIR/$ENTRY_SCRIPT" "$BIN_DIR/appAttack_toolkit"

echo "Installation complete. Run the toolkit using 'appAttack_toolkit'."
