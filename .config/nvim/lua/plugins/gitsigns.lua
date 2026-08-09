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
    -- stage_hunk toggles: on an unstaged hunk it stages, and on a staged sign
    -- it unstages the hunk under the cursor. That replaces the deprecated
    -- undo_stage_hunk (which popped a session-local stack, ignoring the
    -- cursor), so hs and hu now run the same call -- hu is kept only as
    -- muscle memory for "unstage".
    { "<leader>hs", function() require("gitsigns").stage_hunk() end, desc = "Stage hunk (toggles)" },
    { "<leader>hu", function() require("gitsigns").stage_hunk() end, desc = "Unstage hunk under cursor" },
    { "<leader>hr", function() require("gitsigns").reset_hunk() end, desc = "Reset hunk" },
    { "<leader>hp", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk" },
    { "<leader>hb", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame line" },
    { "<leader>tb", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle inline blame" },
  },
}
