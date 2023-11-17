# edit command in nvim by pressing <C-e> in normal mode
edit_command_line() {
    # Save the current command to a temporary file
    local tmpfile=$(mktemp)
    echo "$READLINE_LINE" > "$tmpfile"

    # Open the command in nvim
    nvim "$tmpfile"

    # Update the command line with the edited command
    if [ -f "$tmpfile" ]; then
        READLINE_LINE=$(<"$tmpfile")
        READLINE_POINT=${#READLINE_LINE}
    fi

    # Clean up
    rm -f "$tmpfile"
}
