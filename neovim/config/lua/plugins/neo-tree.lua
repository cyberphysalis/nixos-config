local neo_tree = require("neo-tree")
local fc = require("neo-tree.sources.filesystem.commands")
neo_tree.setup({
  filesystem = {
    window = {
      -- :h neo-tree-custom-mappings
      mappings = {
--        ["<Tab>"] = "toggle_node",
        ["<Tab>"] = function (state)
          local node = state.tree:get_node()
          if node.type == "directory" then
            fc.toggle_node(state)
          else
            fc.close_node(state)
          end
        end
      }
    }
  },
})
