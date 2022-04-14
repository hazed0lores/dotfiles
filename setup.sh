#!/bin/bash

sudo pacman -S zsh kitty xorg-xrdb bat btop lsd --needed --noconfirm ## Installing required programs ##
cp -r .config/* $HOME/.config/ ## Copying everything from .config to $HOME/.config ##
ln -s ~/.config/shell/profile ~/.zprofile ## Creating a symlink for .zprofile (Changes made in .zprofile are applied after logout and logging in again) ##

###################################### zsh plugins i use #################################################################################
git clone https://github.com/zsh-users/zsh-history-substring-search $HOME/.config/zsh/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.config/zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.config/zsh/zsh-autosuggestions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.config/zsh/powerlevel10k
##########################################################################################################################################

#### Randomly insults the users when entering an invalid command. (Works in zsh and bash) Comment out the next two lines if u dont need it 
git clone https://github.com/hkbakke/bash-insulter.git bash-insulter
sudo mv bash-insulter/src/bash.command-not-found /etc/
#############################################################################################################################################

chsh -s $(which zsh) ## Changing the default user shell to zsh ##
sudo sh -c "$(curl -fsSL https://starship.rs/install.sh)" ## Install starship prompt ##
xrdb merge ~/.config/x11/Xresources ## Xresources ##
sudo mkdir -p /usr/share/btop/themes;sudo mv catppuccin.theme /usr/share/btop/themes  
###########################################################################################

######### Copies pacman hooks to /etc/pacman.d/hooks/ ###########
sudo mkdir /etc/pacman.d/hooks/
sudo cp etc/pacman.d/hooks/* /etc/pacman.d/hooks/
sed -i "s/admin/$USER/" /etc/pacman.d/hooks/pkglist.hook
sed -i "s/admin/$USER/" /etc/pacman.d/hooks/aur.hook
#### Asks the user if they want to install programs in pkglist.txt ####

echo "Install Programs from pkglist.txt ?"
read pkglist
[ $pkglist = "y" ] && sudo pacman -S --needed $(comm -12 <(pacman -Slq | sort) <(sort pkglist.txt))

echo "Install programs from aur.txt ? "
read aur 
[ $aur = "y" ] && paru -S --needed - < aur.txt
