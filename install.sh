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

echo "Linking docker-compose CLI plugin..."
mkdir -p "$HOME/.docker/cli-plugins"
ln -sfn "$(command -v docker-compose)" "$HOME/.docker/cli-plugins/docker-compose"

echo "Starting colima if not running..."
if ! colima status >/dev/null 2>&1; then
  colima start
fi

echo "Updating ~/.zshrc..."
zshrc="$HOME/.zshrc"
ensure_zshrc_line() {
  if ! grep -qF "$1" "$zshrc" 2>/dev/null; then
    printf '+ %s\n' "$1"
    printf '%s\n' "$1" >> "$zshrc"
  fi
}
ensure_zshrc_block() {
  marker="$1"
  shift
  if ! grep -qF "$marker" "$zshrc" 2>/dev/null; then
    printf '+ %s\n' "$marker"
    printf '%s\n' "$marker" >> "$zshrc"
    while [ "$#" -gt 0 ]; do
      printf '+ %s\n' "$1"
      printf '%s\n' "$1" >> "$zshrc"
      shift
    done
  fi
}
# shellcheck disable=SC2016
ensure_zshrc_line 'eval "$(starship init zsh)"'
ensure_zshrc_block '# dotfiles: tmux auto-start' \
  'if command -v tmux >/dev/null 2>&1 && [ -z "$TMUX" ] && [ -n "$PS1" ]; then' \
  '  tmux attach-session -t main || tmux new-session -s main' \
  'fi' \
  '# dotfiles: end tmux auto-start'
# shellcheck disable=SC2016
ensure_zshrc_line 'export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"'
ensure_zshrc_line 'export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE="/var/run/docker.sock"'

echo "Done."
