#!/bin/bash

target="$HOME/.dotfiles/zsh/zshrc"
link="$HOME/.zshrc"

# Check if the target file exists
if [ ! -f "$target" ]; then
    echo "Target file does not exist: $target"
    exit 1
fi

# Remove the existing .zshrc file if it exists and is not a symbolic link
if [ -f "$link" ] && [ ! -L "$link" ]; then
    echo "Removing existing .zshrc file..."
    rm "$link"
fi

# Create the symbolic link
ln -sf "$target" "$link"
echo "Symbolic link created successfully."
