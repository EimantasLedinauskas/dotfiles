export SHELL="/usr/bin/bash"
export BDOTDIR="$HOME/.dotfiles/bash_zsh"
export HISTFILE="$HOME/.bash_history"  # history filepath
export HISTSIZE=10000  # maximum events for internal history
export HISTFILESIZE=20000  # maximum events for internal history
export HISTCONTROL=ignoreboth:erasedups  # dont write a duplicate event to the history file
shopt -s autocd  # cd then entering just path
PS1='\e[32m\u@\h\e:\e[34m\W \e[31m>\e[0m '  # prompt

set -o vi  # vi mode
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

# edit command in nvim by pressing <C-e> in normal mode
source "$BDOTDIR/edit_command.sh"
bind -x '"\C-e": edit_command_line'

# fzf
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# shared with zsh options
source "$BDOTDIR/shared.sh"
