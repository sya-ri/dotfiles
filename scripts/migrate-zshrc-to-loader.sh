#!/bin/sh
# One-time migration from old inline dotfiles snippets to the shared zsh loader.

set -eu

zshrc="${1:-$HOME/.zshrc}"
touch "$zshrc"

tmp_zshrc=$(mktemp)
trap 'rm -f "$tmp_zshrc"' EXIT

awk '
  $0 == "# dotfiles: zsh init" { next }
  $0 == ". \"$HOME/.config/dotfiles/zsh-init.zsh\"" { next }
  $0 == "[ -r \"$HOME/.config/dotfiles/zsh-init.zsh\" ] && . \"$HOME/.config/dotfiles/zsh-init.zsh\"" { next }
  $0 == "# starship prompt" { next }
  $0 == "# testcontainers" { next }
  $0 == "eval \"$(starship init zsh)\"" { next }
  $0 == "export DOCKER_HOST=\"unix://${HOME}/.colima/default/docker.sock\"" { next }
  $0 == "export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=\"/var/run/docker.sock\"" { next }
  $0 == "# dotfiles: tmux auto-start" { skip = 1; next }
  $0 == "# dotfiles: end tmux auto-start" { skip = 0; next }
  skip { next }
  { print }
' "$zshrc" > "$tmp_zshrc"

cat >> "$tmp_zshrc" <<'EOF'

# dotfiles: zsh init
[ -r "$HOME/.config/dotfiles/zsh-init.zsh" ] && . "$HOME/.config/dotfiles/zsh-init.zsh"
EOF

mv "$tmp_zshrc" "$zshrc"
trap - EXIT
