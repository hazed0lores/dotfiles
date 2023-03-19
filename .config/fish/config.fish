set -e fish_user_paths
set -U fish_user_paths $HOME/.local/bin $fish_user_paths

# Add ~/AppImages to PATH
if test -d ~/Applications
   if not contains -- ~/Applications $PATH
      set -p PATH ~/Applications
   end
end   

#Supresses fish's intro message
set fish_greeting
set LANG en_US.UTF-8

#bat as anpager
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

#Default Applications
set EDITOR nvim

# Function Backup
function backup --argument filename
    cp $filename $filename.bak
end

#ls
alias lla 'lsd -alh' 
alias ls 'lsd -h'
alias la 'lsd -A'
alias ll 'lsd -l'
alias l. "lsd -a | grep '^\.'"
alias cp "cp -iv"

# Verbosity and settings
alias mv 'mv -iv'
alias ip 'ip -color'
alias rm 'rm -vI'
alias mkdir 'mkdir -pv'
alias cat 'bat'
alias sn 'shutdown now'
alias grep 'grep --color=auto'
alias df 'df -h' 

# Abbreviate commands.
alias jctl "journalctl -p 3 -xb" 
alias rmdb 'doas rm /var/lib/pacman/db.lck'
alias pastebin "curl -F 'f:1=<-' ix.io"
alias cleanup 'doas pacman -Rcns (pacman -Qtdq)'
alias myip 'dig +short myip.opendns.com @resolver1.opendns.com'

# git
alias addup 'git add -u'      
alias addall 'git add .'      
alias commit 'git commit -m'  
alias push 'git push'   
alias stat 'git status'

if status --is-interactive
   source ("/usr/local/bin/starship" init fish --print-full-init | psub)
end   
