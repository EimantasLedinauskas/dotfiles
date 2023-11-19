source "$HOME/.dotfiles/bash_zsh/env_vars.sh"

export HISTFILE="$HOME/.zhistory"  # history filepath
export HISTSIZE=10000  # maximum events for internal history
export SAVEHIST=20000  # maximum events in history file
setopt HIST_SAVE_NO_DUPS  # dont write a duplicate event to the history file
setopt AUTO_CD  # do cd if just path without command is given
unsetopt BEEP  # disable beeping
PROMPT="%F{green}%n%B@%b%m:%f%F{blue}%~%f %F{red}>%f "

bindkey -v  # vi mode
export KEYTIMEOUT=1  # faster switching between vi modes
source "$HOME/.dotfiles/bash_zsh/vi_mode_improvements.zsh"  # change cursor in insert and normal modes

bindkey '^[[Z' reverse-menu-complete  # Shift-Tab for reverse order in completions

# edit command in nvim by pressing <C-e> in normal mode
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd '^e' edit-command-line

zstyle ':completion::complete:*' gain-privileges 1  # allow completion when using sudo
autoload -U compinit; compinit  # initialize completion
_comp_options+=(globdots)  # complete hidden files

setopt AUTO_PUSHD  # push the current directory visited on the stack
setopt PUSHD_IGNORE_DUPS  # do not store duplicates in the stack
setopt PUSHD_SILENT  # do not print the directory stack after pushd or popd
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index  # alias for jumping in dir stack

# fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# nn cd on quit
source "$HOME/.dotfiles/bash_zsh/nnn_cd_on_quit.sh"

# aliases
source "$HOME/.dotfiles/bash_zsh/aliases.sh"
