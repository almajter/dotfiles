# dotfiles

A collection of my personal configuration files ("dotfiles") for various tools and environments.

## Table of Contents

- [Tmux](.tmux.conf) - Terminal multiplexer configuration

## Installation

1. Clone the repository as a bare repository and switch to the `local` branch.

2. Add the config alias to your shell configuration:
   ```bash
   echo "alias config='git --git-dir=$HOME/Razvijam/dotfiles.git --work-tree=$HOME'" >> $HOME/.zshrc
   ```

3. Reload your shell or source the configuration:
   ```bash
   source $HOME/.zshrc
   ```

4. Configure git to not show untracked files:
   ```bash
   config config --local status.showUntrackedFiles no
   ```

5. Check out the files to your home directory:
   ```bash
   config checkout local
   ```

## Usage

After installation, use the `config` command as you would use `git`.

## Development

- Push changes to the `local` branch (which does not contain README.md)
- Create a pull request from `local` to `main` when ready to merge changes
