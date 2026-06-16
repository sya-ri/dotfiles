# dotfiles zsh initialization.

if command -v tmux >/dev/null 2>&1 && [ -z "$TMUX" ] && [ -n "$PS1" ]; then
  tmux attach-session -t main || tmux new-session -s main
fi

eval "$(starship init zsh)"

export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE="/var/run/docker.sock"
