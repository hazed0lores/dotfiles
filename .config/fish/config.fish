if status is-interactive
    # Commands to run in interactive sessions can go here
end
rxfetch
#colorscript random

set -e fish_user_paths
set -U fish_user_paths $HOME/.local/bin $HOME/AppImages $fish_user_paths

#Supresses fish's intro message
set fish_greeting
set LANG en_US.UTF-8

#bat as anpager
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

#Default Applications
set EDITOR nvim

#Alias
alias lla='lsd -alh' 
alias ls='lsd -h'
alias la='lsd -A'
alias ll='lsd -l'
alias cp="cp -iv"
alias mv='mv -iv'
alias rm='rm -vI'
alias mkdir='mkdir -pv'
alias cat='bat'
alias ssn='sudo shutdown now'
alias grep='grep --color=auto'
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
alias df='df -h' 
alias jctl="journalctl -p 3 -xb" 
alias pastebin="curl -F 'f:1=<-' ix.io"
alias addup='git add -u'      
alias addall='git add .'      
alias commit='git commit -m'  
alias push='git push'         
alias stat='git status'       

starship init fish | source
