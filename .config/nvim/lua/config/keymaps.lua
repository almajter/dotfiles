-- Keymaps. Deliberately short — only things that fix a real annoyance.
-- Leader is <Space>, set in init.lua.

local map = vim.keymap.set

-- <Esc> clears search highlighting instead of leaving it on screen
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Move between splits without the <C-w> prefix
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Keep the cursor centred when jumping by half a page
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down, centred" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up, centred" })

-- Move the selected block up/down and reindent it
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Stay in visual mode after indenting, so you can repeat < or >
map("v", "<", "<gv", { desc = "Outdent and keep selection" })
map("v", ">", ">gv", { desc = "Indent and keep selection" })

-- Open the built-in diagnostics list (useful once LSP lands in a later step)
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
