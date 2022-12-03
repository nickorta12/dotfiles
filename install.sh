#!/bin/bash
set -euo pipefail

here="$(realpath $(dirname $0))"
cd $here

for i in */; do
    stow -t "$HOME" $i
done
