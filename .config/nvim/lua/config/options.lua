-- Options ported from ~/.vimrc, minus everything Neovim already does by default.
-- Dropped as redundant: syntax enable, encoding=utf8, filetype plugin/indent on,
-- autoread, backspace, wildmenu, hlsearch, incsearch, mouse=a, ruler.
-- Dropped as vim-only: t_vb (Neovim has no termcap options).

local opt = vim.opt

-- Indentation
opt.expandtab = true -- spaces, never tabs
opt.shiftwidth = 2 -- size of an indent step
opt.tabstop = 2 -- how wide an existing <Tab> renders
opt.softtabstop = 2 -- how many spaces <Tab> inserts (replaces vim's smarttab)
opt.smartindent = true -- infer indent for new lines

-- Line numbers and cursor (all three were in your .vimrc)
opt.number = true
opt.relativenumber = true -- relative numbers make 5j / 12k easy to aim
opt.cursorline = true

-- Search
opt.ignorecase = true
opt.smartcase = true -- ...unless the query contains an uppercase letter

-- Brackets
opt.showmatch = true
opt.matchtime = 2 -- blink delay, in tenths of a second

-- No bells
opt.errorbells = false
opt.visualbell = false

-- No clutter files. Undo history persists to disk instead, which is strictly
-- better than swapfiles: it survives a close and gives you undo across sessions.
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true

-- Files
opt.fileformats = { "unix", "dos", "mac" }
opt.wrap = true

-- Clipboard. unnamedplus is the Neovim-correct choice; on macOS it maps to the
-- same system pasteboard your .vimrc's `unnamed` used.
opt.clipboard = "unnamedplus"

-- Splits open where you'd expect
opt.splitright = true
opt.splitbelow = true

-- Timing
opt.timeoutlen = 500 -- ms to wait for a mapped sequence to complete
opt.updatetime = 250 -- ms of idle before writing the swap/CursorHold events

-- Remember buffer list between sessions (your .vimrc's `viminfo^=%`)
opt.shada:append("%")

-- Restore the last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Return to last edit position",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})
