#!/run/current-system/sw/bin/bash

sudo nixos-rebuild switch --flake .#Chip
home-manager switch --flake .#cn@Chip
