#!/bin/bash

create_symlink() {
    local target=$1
    local link=$2

    # Check if the target exists (file or directory)
    if [ ! -e "$target" ]; then
        echo "Target does not exist: $target"
        return 1
    fi

    # Remove the existing link if it is not a symbolic link
    if [ -e "$link" ] && [ ! -L "$link" ]; then
        echo "Removing existing file/directory at link location: $link"
        # Use 'rm -rf' to handle both files and directories
        rm -rf "$link"
    fi

    # Create the symbolic link
    ln -snf "$target" "$link"
    echo "Symbolic link created for $target"
}

create_symlink "$HOME/.dotfiles/bash_zsh/.inputrc" "$HOME/.inputrc"
create_symlink "$HOME/.dotfiles/bash_zsh/.bashrc" "$HOME/.bashrc"
create_symlink "$HOME/.dotfiles/bash_zsh/.zshrc" "$HOME/.zshrc"
create_symlink "$HOME/.dotfiles/tmux/" "$HOME/.config/tmux"
create_symlink "$HOME/.dotfiles/alacritty/" "$HOME/.config/alacritty"
