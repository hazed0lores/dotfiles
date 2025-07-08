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

fetch
atuin init fish | source
#bat as anpager
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

#Default Applications
set EDITOR nvim

# Function Backup
function backup --argument filename
    cp $filename $filename.bak
end

# ls replacements
abbr lla 'lsd -alh'
abbr ls 'lsd -h'
abbr la 'lsd -A'
abbr ll 'lsd -l'
abbr l. "lsd -a | grep '^\.'"
abbr cp "cp -iv"
abbr mv "mv -iv"
abbr ip "ip -color"
abbr rm "rm -vI"
abbr mkdir "mkdir -pv"
abbr cat "bat"
abbr sn "shutdown now"
abbr grep "grep --color=auto"
abbr df "df -h"

# Misc commands
abbr jctl "journalctl -p 3 -xb"
abbr rmdb "doas rm /var/lib/pacman/db.lck"
abbr pastebin "curl -F 'f:1=<-' ix.io"
abbr cleanup 'doas pacman -Rcns (pacman -Qtdq)'
abbr myip 'dig +short myip.opendns.com @resolver1.opendns.com'

# Git commands
abbr addup 'git add -u'
abbr addall 'git add .'
abbr commit 'git commit -m'
abbr push 'git push'
abbr stat 'git status'
