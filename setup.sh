#!/bin/bash

# Define constants
CONFIG_DIR="$HOME/.config"
ZSH_PLUGINS_DIR="$CONFIG_DIR/zsh"
PKG_LIST="pkglist.txt"
AUR_LIST="aur.txt"

# Source the functions from the original script
source functions.sh

# Call the functions as needed
install_required_programs
copy_configuration_files
install_zsh_plugins
install_bash_insulter
change_default_shell
install_starship_prompt
merge_xresources
install_btop_theme
copy_pacman_hooks
install_pkglist_programs
install_aur_programs
