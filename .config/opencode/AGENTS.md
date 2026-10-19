# Global instructions

## Dotfiles

Config files under `$HOME` (`.zshrc`, `.tmux.conf`, `.vimrc`, `.config/**`,
`~/.claude`, `~/.config/opencode`) are tracked in a bare repo, not a normal one
— plain `git` gives wrong answers there. Invoke the `dotfiles` skill before
reading, editing, or committing any of them.

## Python

Run Python with `uv run`, never bare `python` / `python3`.

## RTK — Rust Token Killer

Token-optimized CLI proxy (cuts up to 90% of bash output). Installed at
`/opt/homebrew/bin/rtk`. The OpenCode `rtk` plugin transparently rewrites shell
commands through the hook engine, so run commands normally.

Meta commands (always use directly):

- `rtk gain` — show token savings analytics
- `rtk gain --history` — command usage history with savings
- `rtk discover` — analyze history for missed opportunities
- `rtk proxy <cmd>` — run a raw command without filtering (debugging)

When rtk truncates long output, the full text is tee'd to
`~/Library/Application Support/rtk/tee/*.log` — read the newest matching log
instead of re-running the command.
