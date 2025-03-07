#!/bin/bash
# run ddc locally, has side effects in /tmp
# dependency: nix

echo "Running DDC using nix locally"
./.github/workflows/scripts/clean.sh
nix-shell --pure --run "./.github/workflows/scripts/setup.sh"
nix-shell --pure --run "./.github/workflows/scripts/ddc.sh -e local_machine -i ./.github/workflows/scripts/init.sh"
