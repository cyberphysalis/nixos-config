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
  { import = "plugins.ui" },
  { import = "plugins.bufferline" },
  -- file explorer
  { import = "plugins.neo-tree" },
  -- tree-sitter
  -- `:TSUpdate` option ensures all the installed parsers are updated before itself upgrading
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { import = "plugins.flash" },
  -- LSP 
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  { import = "plugins.blink" },
  --"hrsh7th/nvim-cmp",
  -- plugin name: nvim-lsp
  --"hrsh7th/cmp-nvim-lsp", -- nvim-cmp source for neovim's built-in language server client.
  -- "L3MON4D3/LuaSnip", -- Snippet Engine
  -- https://git.sr.ht/~whynothugo/lsp_lines.nvim 
  { url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim", name = "lsp_lines" , config = true },
  "lewis6991/gitsigns.nvim", -- display git hunks in side panel
  "zbirenbaum/copilot.lua",
  { import = "plugins.ufo" },
  { import = "plugins.avante"},
  { import = "plugins.term" },
  { import = "plugins.outline" },
  { "j-hui/fidget.nvim", opts = { }, },
  'JoosepAlviste/nvim-ts-context-commentstring',
--  { 'numToStr/Comment.nvim', opts = { }, },
}

require("lazy").setup({
  spec = plugins,
})
