-- The nvim half of vim-tmux-navigator. The tmux half is already declared in
-- ~/.tmux.conf; without this, C-h/j/k/l move between nvim splits but stop dead
-- at the edge of the layout instead of continuing on to the next tmux pane.
--
-- These replace the plain <C-w>h/j/k/l mappings that used to live in
-- config/keymaps.lua — the plugin decides whether a keystroke moves an nvim
-- split or hands off to tmux.
return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Go left (nvim split or tmux pane)" },
    { "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Go down (nvim split or tmux pane)" },
    { "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Go up (nvim split or tmux pane)" },
    { "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Go right (nvim split or tmux pane)" },
    { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Go to previously active split/pane" },
  },
}
