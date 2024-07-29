-- setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.termguicolors = true

local plugins = {
  -- theme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, config = function () vim.cmd.colorscheme "catppuccin-frappe" end},
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }},
  { import = "plugins.bufferline" },
  -- file explorer
  { import = "plugins.neo-tree" },
  -- tree-sitter
  -- `:TSUpdate` option ensures all the installed parsers are updated before itself upgrading
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  -- LSP 
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  "hrsh7th/nvim-cmp",
  -- plugin name: nvim-lsp
  "hrsh7th/cmp-nvim-lsp", -- nvim-cmp source for neovim's built-in language server client.
  "L3MON4D3/LuaSnip", -- Snippet Engine
  "lewis6991/gitsigns.nvim", -- display git hunks in side panel
  "zbirenbaum/copilot.lua",
}

require("lazy").setup({
  spec = plugins,
})
