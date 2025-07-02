#!/bin/bash

#!/bin/bash

# Define constants
CONFIG_DIR="$HOME/.config"
ZSH_PLUGINS_DIR="$CONFIG_DIR/zsh"
PKG_LIST="pkglist.txt"
AUR_LIST="aur.txt"
DOTFILES_REPO="https://gitlab.com/hazedolores/dotfiles.git"
DOTFILES_DIR="dotfiles"

# Define functions
install_dialog() {
    if ! command -v dialog &> /dev/null; then
        echo "dialog not found, installing dialog..."
        sudo pacman -S dialog --needed --noconfirm
    fi
}

clone_repo() {
    if [ "$(basename "$PWD")" != "$DOTFILES_DIR" ]; then

    # Clone if the directory doesn't exist
    if [ ! -d "$DOTFILES_DIR" ]; then
        echo "Cloning $DOTFILES_REPO..."
        git clone "$DOTFILES_REPO"
    fi

    # Enter the dotfiles directory
    cd "$DOTFILES_DIR"
        echo "Now in $(pwd)"
    else
        echo "Already in '$DOTFILES_DIR'."
   fi
}

install_git() {
    if ! command -v git &> /dev/null; then
        echo "git not found, installing dialog..."
        sudo pacman -S git --needed --noconfirm
    fi
}

install_required_programs() {
    sudo pacman -S zsh kitty wget xorg-xrdb git bat btop lsd tree lf --needed --noconfirm
 
 # Check if paru is installed
    if ! command -v paru &> /dev/null; then
        echo "paru not found, installing paru..."
        
        sudo pacman -S --needed --noconfirm base-devel git
        git clone https://aur.archlinux.org/paru-bin.git
        cd paru-bin
        makepkg -si --noconfirm
        cd ..
        rm -rf paru-bin
    else
        echo "paru is already installed."
    fi
}

copy_configuration_files() {
    cp -r .config/* $CONFIG_DIR && ln -sf $HOME/.config/zsh/.zshrc $HOME/.zshrc
}

install_zsh_plugins() {
    git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_PLUGINS_DIR/zsh-history-substring-search"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_PLUGINS_DIR/powerlevel10k"
    git clone https://github.com/KulkarniKaustubh/fzf-dir-navigator "$ZSH_PLUGINS_DIR/fzf-dir-navigator"
    curl https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh --output ~/.config/zsh/fzf-keybindings.zsh
}

install_bash_insulter() {
    git clone https://github.com/hkbakke/bash-insulter.git bash-insulter
    sudo mv bash-insulter/src/bash.command-not-found /etc/
}

change_default_shell() {
    chsh -s "$(which zsh)"
}

install_starship_prompt() {
    if [ ! -f /usr/local/bin/starship ]; then
        echo "Starship prompt not found, installing Starship..."
        sudo pacman -S starship
    else
        echo "Starship prompt is already installed."
    fi
}

install_btop_theme() {
    sudo mkdir -p /usr/share/btop/themes
    wget https://raw.githubusercontent.com/catppuccin/btop/main/themes/catppuccin_mocha.theme && sudo mv catppuccin_mocha.theme /usr/share/btop/themes/
}

copy_pacman_hooks() {
    sudo mkdir -p /etc/pacman.d/hooks
    sudo cp etc/pacman.d/hooks/* /etc/pacman.d/hooks
    sudo sed -i "s/haze/$USER/" /etc/pacman.d/hooks/pkglist.hook
    sudo sed -i "s/haze/$USER/" /etc/pacman.d/hooks/aur.hook
}

install_pkglist_programs() {
	sudo pacman -S --needed $(comm -12 <(pacman -Slq | sort) <(sort "$PKG_LIST"))
}

install_aur_programs() {
	paru -S --needed - < "$AUR_LIST"
}

setup_virtualization() {
	sudo pacman -S qemu-full swtpm libvirt dnsmasq virt-manager --needed --noconfirm
	sudo systemctl enable --now libvirtd.service 
	sudo usermod -aG libvirt,libvirt-qemu,kvm $USER
	sudo virsh net-start default
	sudo virsh net-autostart default
}

setup_tailscale() {
    if ! command -v tailscale &> /dev/null; then
    echo "Tailscale not found. Installing with pacman..."
    sudo pacman -Sy --noconfirm tailscale
fi
sudo systemctl enable --now tailscaled
AUTH_FILE=$(mktemp)
    dialog --title "Tailscale Auth Key" \
           --inputbox "Enter Tailscale Auth Key:" 10 60 2> "$AUTH_FILE"

    TAILSCALE_AUTH_KEY=$(<"$AUTH_FILE")
    rm -f "$AUTH_FILE"

    if [ -z "$TAILSCALE_AUTH_KEY" ]; then
    echo "No auth key entered. Aborting."
    return 1
fi

    sudo tailscale up --auth-key="$TAILSCALE_AUTH_KEY"
}

handle_interrupt() {
    dialog --msgbox "Setup interrupted." 10 40
    clear
    exit 1
}

trap handle_interrupt SIGINT

install_dialog
clone_repo
install_git

show_menu() {
    cmd=(dialog --separate-output --checklist "Toggle ON/OFF actions to perform using [SPACE]" 22 76 16)
    options=(
        1 "Install required programs" on
        2 "Copy configuration files" on
        3 "Install Zsh plugins" on
        4 "Install Bash Insulter" on
        5 "Change default shell to Zsh" on
        6 "Install Starship prompt" on
        7 "Install btop theme" on
        8 "Copy pacman hooks" on
        9 "Install programs from pkglist.txt" on
        10 "Install programs from aur.txt" on
        11 "Setup Virtualization" off
        12 "Setup Tailscale" off
)
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    exit_status=$?
    clear

    if [ $exit_status -eq 1 ]; then
        dialog --msgbox "Setup cancelled." 10 40
        clear
        exit 1
    fi


    for choice in $choices; do
        case $choice in
            1)
                install_required_programs
                ;;
            2)
                copy_configuration_files
                ;;
            3)
                install_zsh_plugins
                ;;
            4)
                install_bash_insulter
                ;;
            5)
                change_default_shell
                ;;
            6)
                install_starship_prompt
                ;;
            7)
                install_btop_theme
                ;;
            8)
                copy_pacman_hooks
                ;;
            9)
                install_pkglist_programs
                ;;
            10)
                install_aur_programs
                ;;

	    11) setup_virtualization
                ;;
                
            12) setup_tailscale
                ;;
        esac
    done
}

show_menu

dialog --msgbox "Setup completed." 10 40

