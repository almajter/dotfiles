-- Git: status/stage/diff/blame/log, all through :G commands.
return {
  "tpope/vim-fugitive",
  cmd = { "G", "Git", "Gdiffsplit", "Gvdiffsplit", "Gclog", "Gblame", "Gwrite", "Gread" },
  keys = {
    { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
    { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git diff split" },
    { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
    { "<leader>gl", "<cmd>Gclog<cr>", desc = "Git log (quickfix)" },
    { "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
  },
}
