#!/usr/bin/env bash
#
# bootstrap.sh — symlink all dotfile packages into $HOME using GNU Stow.
#
# Usage:
#   ./bootstrap.sh                 # stow every package
#   ./bootstrap.sh -n              # dry run: show what would happen, change nothing
#   ./bootstrap.sh -R              # restow everything (refresh after adding files)
#   ./bootstrap.sh -D              # unstow: remove all the symlinks
#   ./bootstrap.sh nvim tmux       # operate on specific packages only
#   ./bootstrap.sh -n nvim         # flags and package names can be combined
#
set -euo pipefail

# Always operate from the directory this script lives in (the repo root = stow dir),
# so the script works no matter where you call it from.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

# Symlinks are created relative to your home directory.
TARGET="$HOME"

# Entries in the repo that are NOT stow packages and must be skipped.
EXCLUDES=(".git" ".github" "bootstrap.sh" "README.md" "LICENSE" ".gitignore")

STOW_FLAGS=()
PACKAGES=()

# --- parse arguments -------------------------------------------------------
for arg in "$@"; do
  case "$arg" in
    -n|--dry-run|--no)  STOW_FLAGS+=("-n" "-v") ;;  # simulate + explain
    -D|--delete)        STOW_FLAGS+=("-D") ;;        # remove symlinks
    -R|--restow)        STOW_FLAGS+=("-R") ;;        # unstow then stow again
    -v|--verbose)       STOW_FLAGS+=("-v") ;;
    -*)                 echo "Unknown option: $arg" >&2; exit 1 ;;
    *)                  PACKAGES+=("$arg") ;;
  esac
done

# --- preconditions ---------------------------------------------------------
if ! command -v stow >/dev/null 2>&1; then
  echo "Error: GNU Stow is not installed." >&2
  echo "Install it first, e.g.  sudo apt install stow" >&2
  exit 1
fi

# --- discover packages if none were named on the command line --------------
if [ ${#PACKAGES[@]} -eq 0 ]; then
  for dir in */; do
    dir="${dir%/}"                 # strip the trailing slash
    skip=false
    for ex in "${EXCLUDES[@]}"; do
      if [ "$dir" = "$ex" ]; then
        skip=true
        break
      fi
    done
    if [ "$skip" = false ]; then
      PACKAGES+=("$dir")
    fi
  done
fi

if [ ${#PACKAGES[@]} -eq 0 ]; then
  echo "No packages found to stow in $DOTFILES_DIR" >&2
  exit 1
fi

# --- run stow --------------------------------------------------------------
echo "Stow directory: $DOTFILES_DIR"
echo "Target:         $TARGET"
echo "Packages:       ${PACKAGES[*]}"
echo

for pkg in "${PACKAGES[@]}"; do
  if [ ! -d "$pkg" ]; then
    echo "Skipping '$pkg' — not a directory." >&2
    continue
  fi
  echo "==> stow ${STOW_FLAGS[*]:-} $pkg"
  stow "${STOW_FLAGS[@]:-}" --target="$TARGET" "$pkg"
done

echo
echo "Done."
