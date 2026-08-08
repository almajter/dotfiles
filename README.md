# dotfiles

A collection of my personal configuration files ("dotfiles") for various tools and environments.

Setup: zsh (oh-my-zsh libs via zinit) + tmux (prefix `Ctrl+a`) + Alacritty/Ghostty, on macOS.

## Table of Contents

- [Tmux](.tmux.conf) - Terminal multiplexer configuration
   - To reload:
  ```sh
  tmux source-file ~/.tmux.conf
  ```
- [Zsh](.zshrc) - Z shell
   - To reload:
  ```sh
  source ~/.zshrc
  ```
- [Vim](.vimrc) - Vim text editor
   - To reload inside vim:
  ```sh
  :source ~/.vimrc
  ```
- [Alacritty](.config/alacritty/alacritty.toml) - Alacritty terminal emulator
   - To reload: quit and relaunch (`option_as_alt` is read at startup)
- [Ghostty](.config/ghostty/config) - Ghostty terminal emulator
   - To reload: `Cmd+Shift+,`
- [Claude Code](.claude/settings.json) - Global Claude Code config
   - Also [`CLAUDE.md`](.claude/CLAUDE.md) / [`RTK.md`](.claude/RTK.md) (global instructions)
     and [`statusline.sh`](.claude/statusline.sh) (custom status line)
   - `.claude/.gitignore` ignores the directory wholesale and opts files back
     in explicitly, so transcripts, caches and brew-managed hooks stay local

## Installation

1. Clone the repository as a bare repository to `$HOME/dotfiles.git` and switch
   to the `local` branch.

2. Add the config alias to your shell configuration:
   ```bash
   echo "alias config='git --git-dir=$HOME/dotfiles.git --work-tree=$HOME'" >> $HOME/.zshrc
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

External dependencies these configs expect: `fzf`, `nvm`, `pyenv`, `tmux` with
[TPM](https://github.com/tmux-plugins/tpm), and (for the Claude Code hooks)
`rtk` and `peon-ping`.

## Usage

After installation, use the `config` command as you would use `git`.

## Development

- Push changes to the `local` branch (which does not contain README.md)
- Create a pull request from `local` to `main` when ready to merge changes

---

# Navigation cheatsheet

## tmux pane navigation

| Key | Action |
|---|---|
| `Ctrl+h` | switch to pane left (or, inside vim/nvim, moves vim split left) |
| `Ctrl+j` | switch to pane down (or vim split down) |
| `Ctrl+k` | switch to pane up (or vim split up) |
| `Ctrl+l` | switch to pane right (or vim split right) |

These are global (no prefix needed) and vim-aware: when the active pane is
running `vim`/`nvim`, the keystroke passes through to vim's own split
navigation instead of moving tmux panes. Handled by the `vim-tmux-navigator`
plugin (see Plugins below) — no hand-rolled `is_vim` shell detection.

**Consequence:** `Ctrl+h/j/k/l` never reach the shell anymore (tmux
intercepts them first) — that's why `clear-screen` and `kill-line` had to
move off `Ctrl+l`/`Ctrl+k` (see below).

## tmux prefix

- Prefix is `Ctrl+a` (remapped from default `Ctrl+b`).
- `Ctrl+a` `Ctrl+a` (press it **twice**) → sends a literal `Ctrl+a` through to
  the shell (readline `beginning-of-line`). The first press is swallowed as the
  prefix wait-state. Note it's `Ctrl+a` again, not a bare `a`.
- `prefix + r` → reload `~/.tmux.conf`.
- `prefix + |` / `prefix + -` → split pane vertically / horizontally, in the
  current pane's directory.
- `prefix + c` → new window, also in the current pane's directory.
- `prefix + p` / `prefix + n` → previous / next window (tmux defaults).
- `prefix + <` / `prefix + >` → move the current window left / right in the
  tab order. Repeatable (`-r`).
- `prefix + h/j/k/l` (with prefix, not the global bindings above) also
  select-pane, kept for muscle memory. Bound with `-r` (repeatable) — hold
  prefix and tap `h/j/k/l` repeatedly instead of re-pressing prefix each time.
- `prefix + I` (capital i) → install/update TPM plugins (see below).

Mouse mode is on: scroll, click-to-focus a pane, and drag borders to resize.
Dragging a selection auto-copies it to the macOS clipboard (via `tmux-yank`);
in copy mode, `v` starts a selection and `y` copies it.

## Session management

Custom zsh functions/aliases in [`.zshrc`](.zshrc) (replaced OMZ's tmux plugin):

| Command | Action |
|---|---|
| `tl` | list tmux sessions |
| `to [name]` | attach to session `name` (default: cwd's basename), creating it with a window named `git` if it doesn't exist yet |
| `tks <name>` | kill session `name` |

`to`/`tks` tab-complete existing session names.

For switching between sessions once inside tmux:

- **Right Alt + s** (must be the **right** Option/Alt key, not left) →
  visual session tree (`choose-tree -sZ`), **single keypress, no prefix
  needed**. Global binding, so it also overwrites zsh's `Alt+s`
  (`spell-word`, rarely used) in every pane — traded away deliberately for
  one-key session switching.
- `prefix + s` → same picker, if you'd rather keep the prefix habit.
- `prefix + S` → create a new session.

Sessions also **persist across restarts**: `tmux-resurrect` +
`tmux-continuum` autosave every 15 min and restore automatically on tmux
startup (see Plugins).

## tmux plugins (TPM)

Bootstrapped via `run '~/.tmux/plugins/tpm/tpm'` at the bottom of
[`.tmux.conf`](.tmux.conf). Install/update with `prefix + I`, remove unused
ones with `prefix + alt+u`.

| Plugin | What it does |
|---|---|
| `tmux-sensible` | sane baseline defaults |
| `tmux-yank` | better copy-to-system-clipboard in copy mode |
| `vim-tmux-navigator` | the `Ctrl+h/j/k/l` vim-aware pane nav above |
| `tmux-resurrect` | manually save/restore session layout (`prefix + Ctrl+s` / `prefix + Ctrl+r`) |
| `tmux-continuum` | auto-save every 15 min + auto-restore on tmux start (`@continuum-restore on`) |
| `tmux-fzf-url` | fuzzy-pick and open URLs visible in the pane |

## zsh line editing (emacs-mode, the zsh/readline default)

| Key | Action |
|---|---|
| `Ctrl+b` / `Ctrl+f` | move back / forward one character (or arrow keys) |
| `Alt+b` / `Alt+f` *(right Option)* | move back / forward one **word** |
| `Ctrl+a` / `Ctrl+e` | jump to start / end of line |
| `Ctrl+w` | delete one word **backward** |
| `Alt+d` *(right Option)* | delete one word **forward** |
| `Alt+k` *(right Option)* | kill from cursor to end of line (was `Ctrl+k`, moved — see below) |
| `Ctrl+u` | kill from cursor to start of line |
| `Ctrl+y` | yank (paste) last killed text |
| `Ctrl+g` | clear screen (was `Ctrl+l`, moved — see below) |
| `Ctrl+r` | fuzzy-search command history (fzf, see below) |
| `Ctrl+t` | fuzzy-find a file, insert its path at cursor (fzf) |
| `Alt+c` *(right Option)* | fuzzy-find a directory and `cd` into it (fzf) |

All three moves fall out of tmux owning `Ctrl+h/j/k/l`, so none of them reach
zsh: `clear-screen` and `kill-line` moved to keys tmux doesn't capture (`Alt+k`
sends `ESC k`, a different byte sequence than `Ctrl+k`), and `Ctrl+h` was
unbound outright (`bindkey -r '^H'` — OMZ had mapped it to backspace via the
`kbs` terminfo capability, which is `^H` under `tmux-256color`). Physical
Backspace is unaffected; it has its own DEL / `^?` binding.

## Alacritty Option key split

[`.config/alacritty/alacritty.toml`](.config/alacritty/alacritty.toml) →
`option_as_alt = "OnlyRight"`

- **Left Option** → normal macOS composition (accents, `Option+N` → `~`, etc).
- **Right Option** → sent to the terminal as Meta/`ESC`-prefixed sequences,
  i.e. use the **right** Option key for all the `Alt+...` bindings above.

## Spotting the cursor and the active pane

`alacritty.toml` sets a blinking block cursor (`[cursor]` section) instead of
the default static one, easier to spot while scanning.

tmux marks the active pane three ways:

- **Border color** — blue (`#89b4fa`) on the active pane, dim grey (`#45475a`)
  on the others.
- **Border label** — `pane-border-status top` puts a line on each border
  showing the pane index and the command running in it.

Pane *backgrounds* are deliberately left at the terminal's own colors
(`window-style` / `window-active-style` set to `default`). They're set
explicitly rather than left unset so tmux-resurrect can't restore stale
background colors on session restore.

Caveat on the borders: they're shared between neighboring panes, so on uneven
layouts the active-border color can look half-and-half — a known tmux
limitation ([tmux/tmux#2540](https://github.com/tmux/tmux/issues/2540)).

### Don't bother dimming inactive panes

Tried twice, doesn't work. tmux only restyles cells the application left at
default colors, and almost nothing does: the zsh prompt, syntax highlighting,
and any colorscheme'd TUI (nvim, htop, lazygit) all paint their own colors and
ignore `window-style` entirely. Background dimming is also capped — Alacritty's
default bg is `#181818`, so even pure black is a 1.18:1 contrast change, which
is invisible. The border color and border label are the cues that actually
work here.

## fzf shell integration

`eval "$(fzf --zsh)"` in [`.zshrc`](.zshrc) wires up `Ctrl+r` / `Ctrl+t` /
`Alt+c` above. `Alt+c` needs the **right** Option key (see Alacritty section).

## Reloading after config changes

- tmux: `prefix + r`, or `tmux source-file ~/.tmux.conf`. Applies tmux-wide
  immediately (key tables are global), no need to repeat per pane/window.
  New/changed `@plugin` lines also need `prefix + I` to actually install.
- zsh: `source ~/.zshrc` in each open pane (or open a new pane/window).
- Alacritty: quit and relaunch the app — `option_as_alt` is read at startup.
- Claude Code: `settings.json` is picked up live; new hooks may need `/hooks`
  opened once, or a restart.
