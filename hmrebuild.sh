#!/run/current-system/sw/bin/bash

if [[ "$1" == "-lim" ]]; then
  echo "Max jobs 4"
  home-manager switch --flake .#cn@Chip --option max-jobs 4
else
  home-manager switch --flake .#cn@Chip
fi
