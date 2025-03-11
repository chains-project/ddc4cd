#!/bin/bash
# run ddc locally, has side effects in /tmp
# dependency: nix

echo "Running DDC using nix locally"
./.github/workflows/scripts/clean.sh
nix-shell --argstr pkgs-rev "07518c851b0f12351d7709274bbbd4ecc1f089c7" --pure --run "./.github/workflows/scripts/setup.sh"
nix-shell --argstr pkgs-rev "07518c851b0f12351d7709274bbbd4ecc1f089c7" --pure --run "./.github/workflows/scripts/ddc.sh -e local_machine -h f6385c05308f715bdd2c06336801193a21d69b50"
