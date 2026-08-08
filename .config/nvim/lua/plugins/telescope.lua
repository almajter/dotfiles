-- Fuzzy finder: files, live grep, buffers, help.
-- Loads on first <leader>f keypress rather than at startup.
return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      -- Native C sorter. Without it telescope falls back to a Lua sorter that
      -- is noticeably slower on big repos. `make` and `cc` are both present,
      -- and `cond` skips the build cleanly on a machine where they aren't.
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffer" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find help tag" },
    { "<leader>fr", "<cmd>Telescope resume<cr>", desc = "Resume last picker" },
    { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Find diagnostic" },
    { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in buffer" },
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        -- <Esc> closes the picker straight from insert mode, instead of first
        -- dropping into telescope's normal mode.
        mappings = {
          i = { ["<esc>"] = require("telescope.actions").close },
        },
      },
      pickers = {
        find_files = {
          -- Dotfiles are the point of this repo, so show them. Still respects
          -- .gitignore; --glob !.git keeps the object database out.
          hidden = true,
          find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
        },
      },
    })

    pcall(telescope.load_extension, "fzf")
  end,
}
