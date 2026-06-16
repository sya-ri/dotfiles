# dotfiles

Personal dotfiles managed with [GNU stow](https://www.gnu.org/software/stow/).

## Setup

```sh
git clone git@github.com:sya-ri/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` runs `brew bundle` against `Brewfile` and then stows every package.

## Packages

### starship

- `~/.config/starship.toml` — [Starship](https://starship.rs) prompt config
### tmux

- `~/.tmux.conf` — tmux config with `C-a` prefix, mouse support, vi copy mode, true color, and current-directory pane splits

## Usage

```sh
stow <package>       # link files into $HOME
stow -D <package>    # unlink
stow -R <package>    # re-link
```
