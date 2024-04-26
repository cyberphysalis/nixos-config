vim.g.mapleader = ","

local keymap = vim.keymap

keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
-- keymap.set("n", "gd", ":lua vim.lsp.buf.definition()<CR>")
keymap.set("n", "gd", vim.lsp.buf.definition)
keymap.set("n", "gr", vim.lsp.buf.references)
keymap.set("n", "gh", vim.lsp.buf.hover)
