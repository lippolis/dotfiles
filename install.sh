#!/bin/bash

echo "RUNNING dotfiles repo install.sh"

echo "STEP 1: 💾 copying .gitconfig and .gitignore_global"
cp -r ./git/.gitconfig ./git/.gitignore_global ~

# Funzione per verificare se VS Code è installato
check_vscode_installed() {
    if command -v code &> /dev/null; then
        return 0
    else
        echo "Visual Studio Code non risulta installato."
        return 1
    fi
}

# Funzione per verificare se code-server è installato
check_code_server_installed() {
    if command -v code-server &> /dev/null; then
        return 0
    else
        echo "code-server non risulta installato."
        return 1
    fi
}

# Funzione per copiare settings.json nella cartella di VS Code (macOS)
copy_settings_vscode() {
    local dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local settings_source="$dotfiles_dir/code/settings.json"
    local settings_target="$HOME/Library/Application Support/Code/User/settings.json"

    # Verifica se esiste il file sorgente
    if [ ! -f "$settings_source" ]; then
        echo "settings.json non trovato in $dotfiles_dir/code"
        return 1
    fi

    # Copia il file
    if cp "$settings_source" "$settings_target"; then
        echo "💾 Copiato settings.json in $settings_target"
    else
        echo "Impossibile copiare settings.json in $settings_target"
        return 1
    fi
}

# Funzione per copiare settings.json nella cartella di code-server (Linux)
copy_settings_codeserver() {
    local dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local settings_source="$dotfiles_dir/code/settings.json"
    # Path tipico dell'utente nell'immagine: /home/USERNAME/.local/share/code-server/User/settings.json
    # Qui usiamo la $HOME in modo che funzioni per ogni utente
    local settings_target="$HOME/.local/share/code-server/User/settings.json"

    # Verifica se esiste il file sorgente
    if [ ! -f "$settings_source" ]; then
        echo "settings.json non trovato in $dotfiles_dir/code"
        return 1
    fi

    # Crea la cartella se non esiste
    mkdir -p "$(dirname "$settings_target")"

    # Copia il file
    if cp "$settings_source" "$settings_target"; then
        echo "💾 Copiato settings.json in $settings_target"
    else
        echo "Impossibile copiare settings.json in $settings_target"
        return 1
    fi
}

# Main execution
# 1. Verifica ed eventualmente copia per VS Code (macOS)
if check_vscode_installed; then
    copy_settings_vscode
else
    echo "Installazione di settings.json per VS Code saltata."
fi

# 2. Verifica ed eventualmente copia per code-server (Linux)
if check_code_server_installed; then
    copy_settings_codeserver
else
    echo "Installazione di settings.json per code-server saltata."
fi
