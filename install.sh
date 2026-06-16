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

echo "Stowing tmux..."
stow --no-folding --restow --target "$HOME" tmux

echo "Stowing zsh..."
stow --no-folding --restow --target "$HOME" zsh

echo "Linking docker-compose CLI plugin..."
mkdir -p "$HOME/.docker/cli-plugins"
ln -sfn "$(command -v docker-compose)" "$HOME/.docker/cli-plugins/docker-compose"

echo "Starting colima if not running..."
if ! colima status >/dev/null 2>&1; then
  colima start
fi

echo "Updating ~/.zshrc..."
zshrc="$HOME/.zshrc"
loader='[ -r "$HOME/.config/dotfiles/zsh-init.zsh" ] && . "$HOME/.config/dotfiles/zsh-init.zsh"'
touch "$zshrc"
if ! grep -qF "$loader" "$zshrc"; then
  cat >> "$zshrc" <<'EOF'

# dotfiles: zsh init
[ -r "$HOME/.config/dotfiles/zsh-init.zsh" ] && . "$HOME/.config/dotfiles/zsh-init.zsh"
EOF
fi

echo "Done."
