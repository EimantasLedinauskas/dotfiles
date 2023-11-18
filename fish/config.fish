set -g fish_greeting  # disable greeting
fish_vi_key_bindings  # vi bindings
function fish_mode_prompt; end  # disable default vi mode indicator

# prompt
function fish_prompt
    set_color green
    echo -n (whoami)
    echo -n '@'
    echo -n (hostname | cut -d '.' -f 1)
    echo -n ':'
    set_color blue
    echo -n (prompt_pwd)

    # vi mode indicator
    set_color red --bold
    switch $fish_bind_mode
        case insert
            echo -n ' > '
        case visual
            echo -n ' V '
        case replace
            echo -n ' R '
        case replace_one
            echo -n ' r '
        case default
            echo -n ' N '
    end

    set_color normal
end

# aliases shared with bash
source $HOME/.dotfiles/bash_zsh/aliases.sh
