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
opt.wrap = false

-- 光标行
opt.cursorline = true

-- 系统剪切板
-- opt.clipboard:append("unnamedplus")

-- 默认新窗口在右和下
opt.splitright = true
opt.splitbelow = true

-- 外观
opt.termguicolors = true
opt.signcolumn = "yes"
vim.cmd.colorscheme "catppuccin-frappe"
