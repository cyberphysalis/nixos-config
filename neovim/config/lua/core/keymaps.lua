vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
keymap.set("n", "<leader>a", "<C-w>h")
keymap.set("n", "<leader>d", "<C-w>l")
keymap.set("n", "<leader>s", "<C-w>j")
keymap.set("n", "<leader>w", "<C-w>k")
-- keymap.set("n", "gd", ":lua vim.lsp.buf.definition()<CR>")
keymap.set("n", "gd", vim.lsp.buf.definition)
keymap.set("n", "gr", vim.lsp.buf.references)
keymap.set("n", "gh", vim.lsp.buf.hover)

keymap.set("n", "<leader>qq", vim.diagnostic.open_float)
keymap.set("n", "<leader>qp", vim.diagnostic.goto_prev)
keymap.set("n", "<leader>qn", vim.diagnostic.goto_next)

-- vim.g.codeium_disable_bindings = 1
-- keymap.set("i", "<C-j>", function () return vim.fn['codeium#Accept']() end, { expr = true })
-- when the esc key is not working
keymap.set("i", ";;", "<Esc>")
