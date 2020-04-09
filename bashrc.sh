export PS1="\[\033[38;5;196m\]\u\[$(tput sgr0)\]\[\033[38;5;10m\]@\[$(tput sgr0)\]\[\033[38;5;14m\]\w\[$(tput sgr0)\]\[\033[38;5;10m\][\T]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"
alias ls='ls --color'

LS_COLORS='no=0;92:di=1;36:ex=1;92' ; export LS_COLORS
