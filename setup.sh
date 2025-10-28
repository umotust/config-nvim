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

# Determine NeoVim config destination directory
if [ -n "$XDG_CONFIG_HOME" ]; then
  DST="$XDG_CONFIG_HOME/nvim"
else
  DST="$HOME/.config/nvim"
fi

mkdir -p "$DST"

# Files/directories to link
for item in after lua; do
  SRC="$SCRIPT_DIR/$item"
  DEST="$DST/$item"

  # Skip if destination already points to the same source
  if [ -e "$DEST" ] && [ "$(realpath "$SRC")" == "$(realpath "$DEST" 2>/dev/null)" ]; then
    echo "skip: (same as target) $(basename "$DEST")"
    continue
  fi

  ln ${LN_OPTS} "$SRC" "$DST/"
done
