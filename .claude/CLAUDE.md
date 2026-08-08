@RTK.md

# Dotfiles

Config files under `$HOME` (`.zshrc`, `.tmux.conf`, `.vimrc`, `.config/**`,
`~/.claude`) are tracked in a bare repo, not a normal one — plain `git` gives
wrong answers there. Invoke the `dotfiles` skill before reading, editing, or
committing any of them.

# Python

Run Python with `uv run`, never bare `python` / `python3`.
