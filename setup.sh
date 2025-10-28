#!/bin/bash

# Get the directory where this script resides
SCRIPT_DIR=$(cd "$(dirname "$0")" || exit; pwd)
# shellcheck disable=SC2128

# Set symlink options depending on the OS
case $(uname) in
  Darwin)
    LN_OPTS="-sv"
    ;;
  Linux)
    LN_OPTS="-sv --backup=numbered"
    ;;
esac

ln ${LN_OPTS} $SCRIPT_DIR/after ~/.config/nvim/
ln ${LN_OPTS} $SCRIPT_DIR/lua ~/.config/nvim/
