---
name: dotfiles
description: Use when reading, editing, staging, or committing the user's config files under $HOME - .zshrc, .tmux.conf, .vimrc, .gitconfig, .config/nvim/**, .config/alacritty/alacritty.toml, .config/ghostty/config, or anything in ~/.claude. They live in a bare git repo driven by a `config` alias, so plain `git`, `git status`, and `.gitignore` assumptions all give wrong answers there. Use it before touching any of those paths, including when the user only asks to edit one - the edit is fine, but staging, committing, or reasoning about what's tracked will be wrong without this.
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
- **Pathspec commands are cwd-relative, and the cwd is usually not `$HOME`.**
  `config ls-files` run from a project directory silently lists nothing, which
  reads exactly like "nothing is tracked". Run `cd $HOME` first, or pass an
  explicit path, before concluding a file isn't tracked.
- **Add files by name, never a directory.** `$HOME` contains nested git repos
  (`~/.config/nvim` was one before it was rebuilt; every `*.bak` of it still is).
  `config add .config/` would record a nested repo as a gitlink, producing a
  phantom submodule that clones as an empty directory. Untracked-file invisibility
  means nothing warns you.

## What's tracked

`.zshrc`, `.tmux.conf`, `.vimrc`, `.gitconfig`, `.config/git/ignore`,
`.config/nvim/**`, `.config/alacritty/alacritty.toml`,
`.config/ghostty/config`, and part of `.claude/`.

The nvim config is hand-built (not a kickstart/LazyVim fork) and includes
`lazy-lock.json`, which is tracked deliberately so plugin versions are
reproducible. Plugins themselves live in `~/.local/share/nvim`, outside the
work tree, so there is nothing to exclude there.

`~/.claude/.gitignore` ignores that directory wholesale (`*`) and opts files back
in by name, because `~/.claude` accumulates runtime state (transcripts, caches,
sessions, brew-managed hooks) that must never be committed. **A new file under
`~/.claude` is ignored until it is added to that whitelist** — adding a skill,
agent, or command means editing `.claude/.gitignore` too, or it silently stays
untracked.

## Keep README.md in sync

`README.md` documents usage for every tracked config (plugin tables, keymap
tables, "Reloading after config changes"). Any change to a tracked file that
alters user-facing behavior — a new nvim plugin, a changed keymap, a new tmux
binding — needs a matching README edit in the *same* piece of work, not a
follow-up. Since README.md lives only on `main` (see below), this means an
extra plumbing commit alongside the `local` commit that made the change.

## Branches

Work lands on `local` and reaches `main` by pull request.

`README.md` exists **only on `main`**, so editing it means committing to `main`
directly rather than going through `local`. Build that commit with plumbing on a
temp index, so the working tree (checked out on `local`) is never touched:

```sh
cd "$HOME"
config fetch -q origin                      # see below — this line matters

draft=$(mktemp)                             # mktemp, not a fixed /tmp name:
idx=$(mktemp -u)                            # those are pre-creatable by others
config show origin/main:README.md > "$draft"
# ...edit "$draft"...

blob=$(config hash-object -w --path README.md "$draft")
export GIT_INDEX_FILE="$idx"
config read-tree origin/main
config update-index --cacheinfo 100644,"$blob",README.md
tree=$(config write-tree)
commit=$(config commit-tree "$tree" -p origin/main -m "README: ...")
unset GIT_INDEX_FILE
config update-ref refs/heads/main "$commit"
config push origin main
```

**Parent the commit on `origin/main`, not the local `main` ref, and fetch
first.** The user merges `local` into `main` through GitHub pull requests, so
the local `main` ref goes stale without anything local changing. Building on it
produces a commit whose parent is an ancestor of the remote tip, and the push is
rejected as non-fast-forward. If that happens, don't force: fetch, confirm
`README.md` is byte-identical on both tips (`config rev-parse <ref>:README.md`
— compare the blob hashes), and replay the edit onto the new tip.

After the plumbing, verify nothing leaked into the working tree: `config diff
--stat origin/main main` should list `README.md` alone, and `config status`
should still be clean on `local`.

## Verifying

- `config check-ignore -v <path>` — confirm a path's ignore status before
  assuming it will be committed.
- `config diff --cached` — review staged content. The repo is public
  (github.com/almajter/dotfiles), so scan for anything secret before pushing.
  Config files are exactly where credential helpers, internal hostnames, and
  API tokens accumulate; read the whole staged diff rather than trusting a
  filename.
- `config rev-list --left-right --count local...origin/local` — ahead/behind in
  one shot. Prefer it over reading a push's "Everything up-to-date", which is
  also what you get when the user already pushed the same commits themselves.
- `config ls-tree -r --name-only origin/main` — what the remote branch actually
  contains. Worth checking before adding relative links to `README.md`: `main`
  can lag `local` by several commits, and a link to a file that hasn't merged up
  yet renders as a 404 on GitHub.
