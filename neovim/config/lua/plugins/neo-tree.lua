require("neo-tree").setup({
  filesystem = {
    window = {
      -- :h neo-tree-custom-mappings
      mappings = {
        ["<Tab>"] = "toggle_node",
      }
    }
  },
})
