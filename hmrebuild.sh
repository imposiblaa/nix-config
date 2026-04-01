#!/run/current-system/sw/bin/bash

nix shell nixpkgs#home-manager --command home-manager switch --flake .#cn@Chip
