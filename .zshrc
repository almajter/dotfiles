# >>> Alias for config files >>>
alias config='git --git-dir=/Users/majal/dotfiles.git --work-tree=/Users/majal'
# <<< Alias for config files <<<

# >>> .local/bin >>>
export PATH="$HOME/.local/bin:$PATH"
# <<< .local/bin <<<

# >>> zinit bootstrap >>>
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME/.git ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"
# <<< zinit bootstrap <<<

# --- OMZ libraries required by the robbyrussell theme + git plugins ---
setopt prompt_subst
zstyle ':omz:alpha:lib:git' async-prompt no
zinit snippet OMZL::git.zsh
zinit snippet OMZL::theme-and-appearance.zsh
zinit snippet OMZL::functions.zsh

# --- OMZ libs ---
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::key-bindings.zsh

# >>> tmux pane-nav key fixes >>>
# Ctrl-h/j/k/l belong to tmux pane nav, so they never reach zsh. Unbind ^H
# (OMZ maps it to backspace via terminfo kbs) and move the casualties off the
# nav keys. Physical Backspace still works via its own DEL/^? binding.
bindkey -r '^H'
bindkey '^G' clear-screen   # was ^L
bindkey '^[k' kill-line     # was ^K
# <<< tmux pane-nav key fixes <<<

# --- Theme (robbyrussell) ---
zinit snippet OMZT::robbyrussell

# --- OMZ plugins (deferred: aliases only, prompt's git lib already loaded above) ---
zinit ice wait lucid
zinit snippet OMZP::git

# --- External plugins ---
zinit wait lucid for \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  atinit"zicompinit; zicdreplay; compdef _tmux_sessions to tks" \
    zsh-users/zsh-syntax-highlighting

# Ctrl+f accepts the current autosuggestion (Ctrl+Space is eaten by macOS
# input-source switching before it reaches the terminal)
bindkey '^f' autosuggest-accept

# >>> nvm lazy initialize >>>
export NVM_DIR="$HOME/.nvm"
_load_nvm() {
  unset -f nvm node npm npx 2>/dev/null   # remove these stubs
  local brew_prefix="${HOMEBREW_PREFIX:-/opt/homebrew}"
  [ -s "$brew_prefix/opt/nvm/nvm.sh" ] && \. "$brew_prefix/opt/nvm/nvm.sh"
  [ -s "$brew_prefix/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$brew_prefix/opt/nvm/etc/bash_completion.d/nvm"
}
nvm()  { _load_nvm; nvm "$@"; }
node() { _load_nvm; node "$@"; }
npm()  { _load_nvm; npm "$@"; }
npx()  { _load_nvm; npx "$@"; }
# <<< nvm lazy initialize <<<

# >>> pyenv lazy initialize >>>
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_SHELL=zsh
export PATH="$PYENV_ROOT/shims:$PATH"
pyenv() {
  unset -f pyenv
  eval "$(command pyenv init - --no-rehash zsh)"   # shims already on PATH above
  pyenv "$@"
}
# <<< pyenv lazy initialize <<<

# >>> Go program installations (GOBIN) >>>
export PATH=$PATH:$HOME/go/bin
# <<< Go program installations (GOBIN) <<<

# >>> fzf shell integration >>>
# Ctrl-R fuzzy history search, Ctrl-T fuzzy file find, Alt-C fuzzy cd
eval "$(fzf --zsh)"
# <<< fzf shell integration <<<

# >>> tmux aliases >>>
alias tl='tmux list-sessions'

# Attach to a session by name (default: $PWD's basename), creating it with
# a "git" window if it doesn't exist yet.
to() {
  local session="${1:-${PWD:t}}"

  if ! command tmux has-session -t "=$session" 2>/dev/null; then
    command tmux new-session -d -s "$session" -n git -c "$PWD"
  fi

  if [[ -n $TMUX ]]; then
    command tmux switch-client -t "=$session"
  else
    command tmux attach-session -t "=$session"
  fi
}

tks() {
  command tmux kill-session -t "$1"
}

# Tab-complete existing session names for `to`/`tks`.
_tmux_sessions() {
  local -a sessions
  sessions=(${(f)"$(command tmux list-sessions -F '#S' 2>/dev/null)"})
  compadd -a sessions
}
# Registered by the deferred zicompinit hook above -- compdef doesn't exist yet.
# <<< tmux aliases <<<
