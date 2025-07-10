#!/bin/bash

mkdir $HOME/.config/backup

for dir in .config/*; do
  name=$(basename "$dir")
  target="$HOME/.config/$name"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "Backing up existing $target to $HOME/.config/backup/$name"
    mv "$target" "$HOME/.config/backup"
  fi
done

stow  -v .
