return  {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  opts = function (_, _)
    local fc = require("neo-tree.sources.filesystem.commands")
    return {
      window = { position = "float" },
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
    }
  end
}
