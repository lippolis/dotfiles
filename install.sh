#!/bin/bash

echo "RUNNING dotfiles repo install.sh"

echo "STEP 1: 💾 copying .gitconfig and .gitignore_global"
cp -r ./git/.gitconfig ./git/.gitignore_global ~

# Function to check if VS Code is installed
check_vscode_installed() {
    if command -v code &> /dev/null; then
        return 0
    else
        echo "Visual Studio Code is not installed."
        return 1
    fi
}

# Function to copy settings.json to VS Code's user settings directory for macOS
copy_settings() {
    local dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local settings_source="$dotfiles_dir/code/settings.json"
    local settings_target="$HOME/Library/Application Support/Code/User/settings.json"

    # Check if source file exists
    if [ ! -f "$settings_source" ]; then
        echo "settings.json not found in $dotfiles_dir/code"
        return 1
    fi

    # Copy the settings file
    if cp "$settings_source" "$settings_target"; then
        echo "💾 copied settings.json to $settings_target"
    else
        echo "Failed to copy settings.json to $settings_target"
        return 1
    fi
}

# Main execution
if check_vscode_installed; then
    copy_settings
else
    echo "Installation of settings.json skipped due to VS Code not being installed."
fi