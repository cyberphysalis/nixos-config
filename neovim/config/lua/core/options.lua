-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

-- 行号
opt.relativenumber = true
opt.number = true

-- 缩进
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- 防止包裹
opt.wrap = true

-- 光标行
opt.cursorline = true

-- 系统剪切板
opt.clipboard:append("unnamedplus")

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.foldlevel = 99

-- 默认新窗口在右和下
opt.splitright = true
opt.splitbelow = true

-- 外观
opt.termguicolors = true
opt.signcolumn = "yes"
vim.cmd.colorscheme "catppuccin-frappe"

-- setup diagnostics
-- vim.diagnostic.config({ virtual_text = false })

-- set a global statusline, see `:h windows`
opt.laststatus = 3

vim.o.foldcolumn = "1"  -- '0' is not bad
vim.o.foldlevel = 99    -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true  -- disable fold at start time
