require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "lua", "vim", "vimdoc", "nix", "javascript", "html", "go", "rust", "svelte", "typescript", "css" },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },  
})
