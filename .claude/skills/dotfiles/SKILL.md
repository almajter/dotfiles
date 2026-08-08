---
name: dotfiles
description: Use when reading, editing, staging, or committing the user's config files under $HOME - .zshrc, .tmux.conf, .vimrc, .config/alacritty/alacritty.toml, .config/ghostty/config, or anything in ~/.claude. They live in a bare git repo driven by a `config` alias, so plain `git`, `git status`, and `.gitignore` assumptions all give wrong answers there.
user_invocable: true
---

# Dotfiles

Config files under `$HOME` live in a **bare** repo at `~/dotfiles.git` with
`--work-tree=$HOME`, reached through the `config` alias defined in `.zshrc`:

```sh
alias config='git --git-dir=$HOME/dotfiles.git --work-tree=$HOME'
```

`config` is a zsh alias, and it is available in this environment because the
shell is initialized from the user's profile. Use it exactly as you would `git`.

## Rules

- **Use `config`, never `git`, for anything under `$HOME`.** A plain `git`
  command there resolves to the wrong repo or none at all, so `cd ~ && git
  status` is never the right check.
- **`status.showUntrackedFiles=no`.** `config status` lists tracked files only.
  An untracked file is therefore *invisible*, not merely unstaged — never read a
  clean `config status` as "everything is committed".
- **There are no remote-tracking refs by default.** A fetch refspec was added,
  so `origin/main` and `origin/local` now resolve; if they ever don't, don't
  assume in-sync — a push either fast-forwards or is rejected, so let it tell you.

## What's tracked

`.zshrc`, `.tmux.conf`, `.vimrc`, `.config/alacritty/alacritty.toml`,
`.config/ghostty/config`, and part of `.claude/`.

`~/.claude/.gitignore` ignores that directory wholesale (`*`) and opts files back
in by name, because `~/.claude` accumulates runtime state (transcripts, caches,
sessions, brew-managed hooks) that must never be committed. **A new file under
`~/.claude` is ignored until it is added to that whitelist** — adding a skill,
agent, or command means editing `.claude/.gitignore` too, or it silently stays
untracked.

## Branches

Work lands on `local` and reaches `main` by pull request.

`README.md` exists **only on `main`**, so editing it means committing to `main`
directly rather than going through `local`. To change it without disturbing the
working tree (which is checked out on `local`), build the commit with plumbing —
`hash-object` → `read-tree`/`update-index` on a temp index → `write-tree` →
`commit-tree` → `update-ref` — rather than checking `main` out.

## Verifying

- `config check-ignore -v <path>` — confirm a path's ignore status before
  assuming it will be committed.
- `config diff --cached` — review staged content. The repo is public
  (github.com/almajter/dotfiles), so scan for anything secret before pushing.
