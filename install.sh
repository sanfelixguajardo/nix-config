#!/bin/sh

SCRIPT_DIR=~/.dotfiles

nix-shell -p git --command "git clone https://github.com/sanfelixguajardo/nixos-config $SCRIPT_DIR"

# Generate hardware config for the system
sudo nixos-generate-config --show-hardware-config > $SCRIPT_DIR/system/hardware-configuration.nix

# Rebuild system
sudo nixos-rebuild switch --flake $SCRIPT_DIR;

# Install and build home-manager configuration
nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake $SCRIPT_DIR#sanfe;
