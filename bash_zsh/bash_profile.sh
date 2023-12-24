new_entry=/opt/cuda/bin
case ":$PATH:" in
  *":$new_entry:"*) :;; # already there
  *) PATH="$new_entry:$PATH";; # or PATH="$PATH:$new_entry"
esac

if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
