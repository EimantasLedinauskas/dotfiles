# XDG Paths
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# nvim
export EDITOR="nvim"
export VISUAL="nvim"
alias nvimd='nvim --noplugin -u NONE'  # launch nvim without any plugin or config

# nnn
alias N='sudo -E nnn -a -E -x -A -u -C'
export LC_COLLATE="C"
export NNN_BMS="d:$HOME/Documents;D:$HOME/Downloads;p:$HOME/Dropbox/phd"
export NNN_PLUG="d:diffs;f:fzcd;o:fzopen;"
export NNN_ARCHIVE="\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)$"
export NNN_TRASH=1  # use trash cli
source "$HOME/.dotfiles/bash_zsh/nnn_cd_on_quit.sh"  # cd on quit

# general aliases
alias ..='cd ..'
alias cdc='cd ~/.dotfiles'  # to config directory
alias ls='ls --color=auto --group-directories-first -lh'
alias Find='sudo find / -name'  # global find by name

# pacman aliases
alias paci='sudo pacman -S'  # install
alias pacs='pacman -Ss'  # search
alias pacu='sudo pacman -Syu'  # update
alias pacr='sudo pacman -R'  # remove single
alias pacrr='sudo pacman -Rs'  # remove with dependencies
alias pacl='sudo pacman -Ql'  # list files installed by package
alias pacb="pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse"  # browse
