#!/bin/bash

# Exit script on any error
set -e

echo "🚀 Starting dotfiles setup on Ubuntu..."

# Ensure the script is run on Ubuntu
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" != "ubuntu" ]]; then
        echo "❌ This script is for Ubuntu only. Exiting."
        exit 1
    fi
else
    echo "❌ Unable to detect the OS. Exiting."
    exit 1
fi

# Function to install GCC
install_gcc() {
    echo "📦 Installing GCC..."
    sudo apt-get update
    sudo apt-get install -y gcc
    echo "✅ GCC installed successfully."
}

# Prompt the user to install GCC
read -p "❓ Do you want to install GCC for compiling C files? (y/n): " INSTALL_GCC
if [[ "$INSTALL_GCC" =~ ^[Yy]$ ]]; then
    install_gcc
else
    echo "⚠️ Skipping GCC installation."
fi

# Install Visual Studio Code
echo "📦 Installing Visual Studio Code..."
sudo apt-get update
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update
sudo apt-get install -y code
rm -f packages.microsoft.gpg

# Verify that the 'code' command is installed
if ! command -v code &> /dev/null; then
    echo "❌ 'code' command not found. Installation failed. Exiting."
    exit 1
else
    echo "✅ 'code' command installed and available."
fi

# Copy VS Code settings.json
echo "📄 Copying VS Code settings.json..."
VSCODE_CONFIG_PATH="$HOME/.config/Code/User"
mkdir -p "$VSCODE_CONFIG_PATH"
cp ./vscode/settings.json "$VSCODE_CONFIG_PATH/settings.json"


# Completion message
echo "✅ Dotfiles setup complete! You can now use VS Code with your custom settings."