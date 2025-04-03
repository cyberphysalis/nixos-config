vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>e", ":Neotree position=left reveal toggle<CR>")
keymap.set("n", "<leader>a", "<C-w>h")
keymap.set("n", "<leader>d", "<C-w>l")
keymap.set("n", "<leader>s", "<C-w>j")
keymap.set("n", "<leader>w", "<C-w>k")
-- keymap.set("n", "gd", ":lua vim.lsp.buf.definition()<CR>")
keymap.set("n", "gd", vim.lsp.buf.definition)
keymap.set("n", "gr", vim.lsp.buf.references)
-- keymap.set("n", "gh", vim.lsp.buf.hover)

-- keymap.set("n", "<leader>q", vim.diagnostic.open_float)
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = true,
})
keymap.set("n", "<leader>l", require("lsp_lines").toggle)
keymap.set("n", "<leader>p", function () vim.diagnostic.goto_prev({float = false}) end)
keymap.set("n", "<leader>n", function () vim.diagnostic.goto_next({float = false}) end)


-- leader + Enter to open terminals
keymap.set("n", "<leader><CR>", ":ToggleTerm<CR>")

-- vim.g.codeium_disable_bindings = 1
-- keymap.set("i", "<C-j>", function () return vim.fn['codeium#Accept']() end, { expr = true })
-- when the esc key is not working
keymap.set("i", ";'", "<Esc>")

-- Do not yank with x 
keymap.set("n", "x", "\"_x")
