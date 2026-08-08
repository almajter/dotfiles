-- Git: inline gutter signs for added/changed/deleted lines, hunk stage/preview/blame.
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 300,
      virt_text_pos = "eol",
    },
  },
  keys = {
    { "]c", function() require("gitsigns").nav_hunk("next") end, desc = "Next git hunk" },
    { "[c", function() require("gitsigns").nav_hunk("prev") end, desc = "Prev git hunk" },
    { "<leader>hs", function() require("gitsigns").stage_hunk() end, desc = "Stage hunk" },
    { "<leader>hu", function() require("gitsigns").undo_stage_hunk() end, desc = "Undo stage hunk" },
    { "<leader>hr", function() require("gitsigns").reset_hunk() end, desc = "Reset hunk" },
    { "<leader>hp", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk" },
    { "<leader>hb", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame line" },
    { "<leader>tb", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle inline blame" },
  },
}
