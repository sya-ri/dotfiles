#!/bin/sh
# Install dotfiles via GNU stow. Safe to re-run.

set -eu

cd "$(dirname "$0")"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required. Install it from https://brew.sh/ first." >&2
  exit 1
fi

echo "Installing Homebrew bundle..."
brew bundle --file=Brewfile

echo "Stowing starship..."
stow --no-folding --restow --target "$HOME" starship

echo "Done."
