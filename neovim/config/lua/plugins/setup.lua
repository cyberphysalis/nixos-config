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

local plugins = {
  -- theme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }},
  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
  },
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
}

require("lazy").setup(plugins)
