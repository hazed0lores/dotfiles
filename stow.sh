#!/bin/bash

for dir in .config/*; do
  name=$(basename "$dir")
  target="$HOME/.config/$name"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "Backing up existing $target to $target.backup"
    mv "$target" "$target.backup"
  fi
done

stow  -v .
