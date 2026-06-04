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
- `~/.local/bin/starship-pr.sh` — cached PR number lookup for the current branch (30 s TTL with background refresh)

Requires the [`gh` CLI](https://cli.github.com) to be authenticated (`gh auth login`).

## Usage

```sh
stow <package>       # link files into $HOME
stow -D <package>    # unlink
stow -R <package>    # re-link
```
