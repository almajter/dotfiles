# dotfiles

My macOS terminal setup: zsh (oh-my-zsh libs via zinit) + tmux (prefix
`Ctrl+a`) + Alacritty/Ghostty, with a Neovim config built from scratch rather
than forked from a distribution.

Tracked in a **bare** repo at `$HOME/dotfiles.git` with `$HOME` as the work
tree. Nothing is symlinked — the files are checked out where they belong.

## Install

```sh
git clone --bare https://github.com/almajter/dotfiles.git "$HOME/dotfiles.git"
alias config='git --git-dir=$HOME/dotfiles.git --work-tree=$HOME'

# without this every file in $HOME shows up as untracked
config config --local status.showUntrackedFiles no

config checkout local
```

The alias is already in the tracked `.zshrc`, so it persists once the checkout
lands. Use `config` exactly as you would `git`.

**Dependencies:** `fzf`, `zoxide`, `nvm`, `pyenv`, `ripgrep`, `tree-sitter-cli`,
`nvim` (0.9+, required by lazy.nvim), `tmux` +
[TPM](https://github.com/tmux-plugins/tpm), and `rtk` + `peon-ping` for the
Claude Code hooks.

## What's tracked

| Path | What | Reload after editing |
|---|---|---|
| [`.zshrc`](.zshrc) | shell, prompt, plugins, tmux helpers | `source ~/.zshrc` — per pane |
| [`.tmux.conf`](.tmux.conf) | multiplexer | `prefix + r` (global, once) |
| [`.vimrc`](.vimrc) | plain `vim` only — shares nothing with Neovim | `:source ~/.vimrc` |
| [`.config/nvim/`](.config/nvim/init.lua) | Neovim | restart; `require` caches Lua modules |
| [`.gitconfig`](.gitconfig) + [`.config/git/ignore`](.config/git/ignore) | git identity, difftool, global ignore (`.DS_Store`, `settings.local.json`) | immediate |
| [`.config/alacritty/`](.config/alacritty/alacritty.toml) | terminal | quit and relaunch |
| [`.config/ghostty/`](.config/ghostty/config) | terminal | `Cmd+Shift+,` |
| [`.claude/`](.claude/settings.json) | Claude Code settings, instructions, statusline | immediate |

New `@plugin` lines in `.tmux.conf` also need `prefix + I`. Neovim plugin spec
changes also need `:Lazy sync`.

`.claude/.gitignore` ignores that directory wholesale and opts files back in by
name — transcripts, caches and brew-managed hooks stay local. **Adding a skill
or agent there means editing that whitelist too, or it silently stays
untracked.**

## tmux

Prefix is `Ctrl+a`. Press it **twice** to send a literal `Ctrl+a` to the shell.

| Key | Action |
|---|---|
| `prefix r` | reload `.tmux.conf` |
| `prefix \|` / `prefix -` | split vertical / horizontal, in the current pane's dir |
| `prefix c` | new window, same dir |
| `prefix p` / `prefix n` | previous / next window |
| `prefix <` / `prefix >` | move current window left / right in the tab order |
| `prefix I` | install/update TPM plugins (`prefix alt+u` removes unused) |
| `Ctrl+h/j/k/l` | move between panes — **no prefix**, vim-aware ([why](#gotchas)) |
| `prefix h/j/k/l` | same, prefix'd, kept for muscle memory |
| `Alt+h/j/k/l` | resize active pane by 2 cells — **no prefix**, needs the right Option key |

Mouse mode is on: scroll, click-to-focus, drag borders to resize. Dragging a
selection copies to the macOS clipboard; in copy mode `v` selects and `y` copies.

### Sessions

| Command | Action |
|---|---|
| `tl` | list sessions |
| `to [name]` | attach to `name` (default: cwd basename), creating it with a `git` window |
| `tks <name>` | kill session `name` |
| `Alt+s` | session tree — **single keypress, no prefix** (right Option) |
| `prefix s` / `prefix S` | same picker / new session |

`to` and `tks` tab-complete existing session names. Sessions survive restarts:
`tmux-resurrect` + `tmux-continuum` autosave every 15 min and restore on start.

`Alt+s` is a global binding, so it costs zsh's `spell-word` in every pane —
traded deliberately for one-key session switching.

### Plugins

`tmux-sensible` · `tmux-yank` (clipboard) · `vim-tmux-navigator` (pane nav
above) · `tmux-resurrect` (`prefix Ctrl+s` / `prefix Ctrl+r`) ·
`tmux-continuum` (autosave) · `tmux-fzf-url` (fuzzy-open visible URLs).

## zsh

Emacs-mode line editing. Every `Alt+…` binding needs the **right** Option key
([why](#gotchas)).

| Key | Action |
|---|---|
| `Ctrl+a` / `Ctrl+e` | start / end of line |
| `Ctrl+b` / `Alt+b` | back one character / word |
| `Ctrl+f` | forward one character |
| `Alt+f` | **accept autosuggestion** |
| `Ctrl+w` / `Alt+d` | delete word backward / forward |
| `Alt+k` | kill to end of line — moved off `Ctrl+k` |
| `Ctrl+u` | kill to start of line |
| `Ctrl+y` | yank last killed text |
| `Ctrl+g` | clear screen — moved off `Ctrl+l` |
| `Ctrl+r` | fuzzy history search (fzf) |
| `Ctrl+t` | fuzzy-find a file, insert its path (fzf) |
| `Alt+c` | fuzzy-find a directory and `cd` (fzf) |
| `Alt+p` | history search backward on the current prefix |

### zoxide

| Command | Action |
|---|---|
| `z <query>` | jump to the highest-frecency match |
| `zi <query>` | interactive fuzzy picker over matches |

`cd` is untouched — zoxide only learns from it. Distinct from `Alt+c`, which
browses *all* directories under the cwd; `z` only knows ones you've visited.

## Neovim

```
.config/nvim/
├── init.lua              leader + requires, nothing else
├── lazy-lock.json        pinned plugin commits — tracked on purpose
└── lua/
    ├── config/
    │   ├── options.lua   vim.opt settings
    │   ├── keymaps.lua   vim.keymap.set
    │   └── lazy.lua      lazy.nvim bootstrap
    └── plugins/          one file per plugin, auto-imported
```

Adding a plugin means dropping a file in `lua/plugins/` that returns a spec —
`{ import = "plugins" }` picks up the directory, so there's no central list to
keep in sync.

Leader is `<Space>`. Keymaps are deliberately short — only things that fix a
real annoyance.

| Key | Action |
|---|---|
| `<Esc>` | clear search highlight |
| `Ctrl+h/j/k/l` | move between splits, crossing into tmux panes at the edge |
| `Ctrl+\` | previously active split/pane |
| `Ctrl+d` / `Ctrl+u` | half page down/up, cursor re-centred |
| `J` / `K` *(visual)* | move selection down/up and reindent |
| `<` / `>` *(visual)* | indent, keeping the selection |
| `<leader>q` | diagnostics to location list |

### Telescope

| Key | Action |
|---|---|
| `<leader>ff` | find files |
| `<leader>fg` | live grep |
| `<leader>fb` | switch buffer |
| `<leader>fh` | help tags |
| `<leader>fr` | reopen last picker, query intact |
| `<leader>fd` | diagnostics |
| `<leader>/` | fuzzy-search the current buffer |

`<Esc>` closes a picker straight from insert mode. `find_files` passes
`--hidden` — dotfiles are the point of this repo — while still respecting
`.gitignore`, with `--glob !.git/*` to keep the object database out.

The native C sorter is built with `make` at install and only *then* loaded
(`pcall(load_extension, "fzf")`), so a machine without a compiler falls back to
the Lua sorter instead of erroring on every start.

### Other plugins

`vim-tmux-navigator` · `nvim-treesitter` · `plenary.nvim` (telescope dep) ·
`vim-fugitive` and `gitsigns.nvim` ([keys below](#git)).

Telescope, fugitive and vim-tmux-navigator load on their keys/commands.
`gitsigns` loads on buffer read and `nvim-treesitter` is `lazy = false` —
highlighting has to attach to the first buffer.

## Git

`diff.tool = nvimdiff` and `difftool.prompt = false`, so `git difftool` opens
side-by-side in nvim, file after file without a prompt between each.

| Key | Action |
|---|---|
| `]c` / `[c` | next / previous change |
| `do` / `dp` | pull the other pane's version in / push yours out |
| `:qa` | close both panes, move to the **next file** |
| `:cq` | abort the run, skipping remaining files |

`git difftool -d` opens the whole changeset at once instead of file-by-file.

### Fugitive

| Key | Action |
|---|---|
| `<leader>gs` | `:Git` status — `-` stages a file, `=` expands its inline diff |
| `<leader>gd` | `:Gdiffsplit` — hunk-level diff against the index |
| `<leader>gb` | `:Git blame` |
| `<leader>gl` | `:Gclog` — log into the quickfix list |
| `<leader>gp` | `:Git push` |

To stage a single hunk: `<leader>gs`, `=` on the file, then `-` on a `+`/`-`
line.

### Gitsigns

| Key | Action |
|---|---|
| `]c` / `[c` | next / previous hunk *(in a normal buffer)* |
| `<leader>hs` | stage the hunk under the cursor — or unstage it if already staged |
| `<leader>hu` | unstage the hunk under the cursor (same call as `hs`) |
| `<leader>hr` | reset hunk (discard) |
| `<leader>hp` | preview hunk diff inline |
| `<leader>hb` | full blame for the current line |
| `<leader>tb` | toggle current-line blame virtual text |

`stage_hunk` is a toggle, which is why `hs` and `hu` are the same call — `hu`
is kept purely as muscle memory. Gitsigns complements Fugitive rather than
replacing it: gitsigns for glance-and-hunk work, Fugitive for the full status
window and commit/push.

## Gotchas

Things that cost real time to work out. Reasons, not restatements of the config.

- **`Ctrl+h/j/k/l` belong to tmux**, globally and prefix-free, and they're
  vim-aware: inside vim/nvim the keystroke moves a split instead, and crossing
  back out at the edge of the layout works too. That needs `vim-tmux-navigator`
  installed on **both** sides — TPM for tmux, lazy.nvim for Neovim. The tmux
  half alone gets the key into nvim but can't get you back out.
- **Consequence:** those keys never reach zsh. `clear-screen` moved to `Ctrl+g`
  and `kill-line` to `Alt+k` (`ESC k` is a different byte sequence, so tmux
  doesn't eat it), and `^H` is unbound outright — OMZ mapped it to backspace via
  the `kbs` terminfo capability, which is `^H` under `tmux-256color`. Physical
  Backspace is unaffected; it has its own `^?` binding.
- **Use the right Option key for every `Alt+…` binding.** `option_as_alt =
  "OnlyRight"` leaves left Option on macOS composition (`Option+N` → `~`).
- **`Alt+f` accepts autosuggestions** (instead of its usual forward-word,
  which isn't needed here) because macOS swallows `Ctrl+Space` globally for
  input-source switching before the terminal ever sees it. `Ctrl+f` stays
  forward-char. Needs the **right** Option key, like every other `Alt+…`
  binding.
- **Don't try to dim inactive panes.** Tried twice, doesn't work: tmux only
  restyles cells the application left at default colors, and the prompt, syntax
  highlighting and any colorscheme'd TUI all paint their own. Border color and
  the `pane-border-status` label are the cues that actually work.
- **Shift+Enter is wired end to end.** Alacritty sends it as CSI u
  (`ESC[13;2u`) and `.tmux.conf` sets `extended-keys always` + `csi-u` to pass
  it through. It can't be `\n` — that's `0x0a` == `Ctrl+j`, which
  vim-tmux-navigator owns.
- **nvim-treesitter tracks `main`,** now upstream's default. Nearly every
  tutorial online still shows the `master` API, which no longer applies:
  `install({...})` replaces `configs.setup({ ensure_installed })`, and
  `vim.treesitter.start(buf)` in a `FileType` autocmd replaces
  `highlight = { enable = true }`. Parsers land in
  `~/.local/share/nvim/site/parser/`. zsh has no grammar, so bash's is
  registered for it — otherwise `.zshrc` would be the one unhighlighted file.
- **lazy.nvim is pinned to its release tag** (`version = "*"`). Left alone it
  tracks `main`, whose tip runs *months behind* the tagged releases — the stock
  bootstrap clones `--branch=stable` and then silently downgrades on first sync.
- **`rocks = { enabled = false }`.** luarocks wants hererocks, nothing here
  needs it, and leaving it on puts a permanent ERROR in `:checkhealth`.
- **`lazy-lock.json` is tracked on purpose** (distributions usually ignore it).
  It pins every plugin to a commit, so `:Lazy restore` undoes a bad update.
- **zinit's `zi` alias is unaliased** so zoxide's `zi` can take over — in zsh an
  alias shadows a same-named function regardless of definition order. The full
  `zinit` command still works unabbreviated.
- **`credential.helper` is the one machine-specific line here.** It's an
  absolute path to Git Credential Manager at `/usr/local/share/gcm-core/` (the
  `.pkg` location); a Homebrew install on Apple Silicon lands under
  `/opt/homebrew`. `credential.https://github.com.username` is pinned too —
  without it, a second stored account for the host triggers an account picker on
  every push.

## Repo workflow

Work lands on `local` and reaches `main` by pull request.

`README.md` exists **only on `main`**, so it never appears in the `local`
working tree and editing it means committing to `main` directly. Everything
else is the other way round — commit to `local`, then open the PR.
