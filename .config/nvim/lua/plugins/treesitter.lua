-- Syntax highlighting and indentation from real parse trees rather than regex.
--
-- This uses nvim-treesitter's `main` branch, which is now its default. The
-- rewrite dropped the old `setup({ ensure_installed, highlight = { enable } })`
-- table that most configs and tutorials still show: parsers are installed with
-- install(), and highlighting is started per-buffer with vim.treesitter.start.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  -- Highlighting has to be attached to the first buffer read, so this one
  -- loads at startup rather than lazily.
  lazy = false,
  config = function()
    local ts = require("nvim-treesitter")

    ts.install({
      "bash",
      "c",
      "diff",
      "git_config",
      "git_rebase",
      "gitcommit",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "query",
      "toml",
      "vim",
      "vimdoc",
      "yaml",
    })

    -- zsh has no grammar of its own; bash's parses .zshrc well enough, and
    -- these dotfiles are mostly zsh.
    vim.treesitter.language.register("bash", "zsh")

    vim.api.nvim_create_autocmd("FileType", {
      desc = "Start treesitter highlighting where a parser exists",
      callback = function(args)
        -- pcall: a filetype with no installed parser is the normal case, not
        -- an error — it just keeps Neovim's regex highlighting.
        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
