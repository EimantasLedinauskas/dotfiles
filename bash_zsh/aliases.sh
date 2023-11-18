# general
alias ..='cd ..'
alias ...="cd ../.."
alias cdc='cd ~/.dotfiles'  # to config directory
alias ls='ls --color=auto --group-directories-first -lh'
alias Find='sudo find / -name'  # global find by name
alias mkdir='mkdir -p'  # create nested dirs

# nvim
alias nvimd='nvim --noplugin -u NONE'  # launch nvim without any plugin or config

# nnn
alias N='sudo -E nnn -a -E -x -A -u -C'

# pacman
alias paci='sudo pacman -S'  # install
alias pacs='pacman -Ss'  # search
alias pacu='sudo pacman -Syu'  # update
alias pacr='sudo pacman -R'  # remove single
alias pacrr='sudo pacman -Rs'  # remove with dependencies
alias pacl='sudo pacman -Ql'  # list files installed by package
alias pacb="pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse"  # browse
