#!/usr/bin/env bash

set -e

REPO="SolarBeamRed/idk"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"

INSTALL_DIR="$HOME/.local/bin"

SCRIPTS=(
  "program2.sh"
  "program3.sh"
  "program4.sh"
  "program5.sh"
  "program6.sh"
  "program7.sh"
)

echo "Installing scripts to $INSTALL_DIR ..."

mkdir -p "$INSTALL_DIR"

for script in "${SCRIPTS[@]}"; do
    echo "Downloading $script..."

    curl -fsSL \
        "$BASE_URL/$script" \
        -o "$INSTALL_DIR/${script%.sh}"

    chmod +x "$INSTALL_DIR/${script%.sh}"

    echo "Installed ${script%.sh}"
done

# Add ~/.local/bin to PATH if missing
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then

    SHELL_RC=""

    if [[ "$SHELL" == *"zsh"* ]]; then
        SHELL_RC="$HOME/.zshrc"
    else
        SHELL_RC="$HOME/.bashrc"
    fi

    echo "" >> "$SHELL_RC"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"

    export PATH="$HOME/.local/bin:$PATH"

    echo
    echo "Added $INSTALL_DIR to PATH in $SHELL_RC"
fi

echo
echo "Installation complete!"
echo
echo "You can now run:"
echo "  program2"
echo "  program3"
echo "  ..."
