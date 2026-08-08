-- Entry point. Keep this file thin: it only pulls in the real config.
-- Leader must be set before any keymap or plugin is loaded, so it lives here.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.lazy")
