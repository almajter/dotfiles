-- Bootstrap lazy.nvim: clone it on first run, then put it on the runtime path.
-- Everything under lua/plugins/ is imported automatically, one file per plugin.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Pin lazy.nvim to its latest release tag. Left to itself it tracks the
    -- `main` branch, whose tip is months behind the tagged releases.
    { "folke/lazy.nvim", version = "*" },
    { import = "plugins" },
  },
  -- Stay on the built-in colorscheme after a fresh install
  install = { colorscheme = { "default" } },
  -- luarocks support needs hererocks; nothing here uses it, and leaving it on
  -- is what produced the "luarocks not installed" error in the old setup.
  rocks = { enabled = false },
  change_detection = { notify = false },
})
