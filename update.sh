#!/run/current-system/sw/bin/bash

if [[ "$1" == "boot" ]]; then
    sudo nixos-rebuild boot --flake .#Chip
else
    sudo nixos-rebuild switch --flake .#Chip
    home-manager switch --flake .#cn@Chip
fi
