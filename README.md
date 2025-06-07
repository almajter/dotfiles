# dotfiles

A collection of my personal configuration files ("dotfiles") for various tools and environments.

## Table of contents

- [Tmux](.tmux.conf) - Terminal multiplexer configuration

## Installation

### Clone as Bare Repository

1. Clone the repository as a bare repository

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

## Usage

After installation, use the `config` command as you would use `git`:
