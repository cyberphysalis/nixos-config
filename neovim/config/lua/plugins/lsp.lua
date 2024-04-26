require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

local file_ext = vim.fn.expand("%:e")
local should_installed_lsp = {}
if file_ext == "lua" then
  table.insert(should_installed_lsp, "lua_ls")
end
vim.notify("lsp should installed:"..table.concat(should_installed_lsp, " "))

require("mason-lspconfig").setup({
  -- 确保需要安装的 LSP 服务，根据需要填写
  ensure_installed = should_installed_lsp
--  ensure_installed = {
--    "lua_ls",
--    "gopls",
--   },
})

local cmp = require('cmp')
cmp.setup {
  preselect = cmp.PreselectMode.None,
  sources = {
    { name = 'nvim_lsp' }
  },
  mapping = cmp.mapping.preset.insert{
    -- tab 键向下补全候选词, shift-tab 向上选择
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i' }),
--    ['<CR>'] = cmp.confirm({ select = true }),
    ['<C-e>'] = cmp.mapping.abort(),  -- 取消补全，esc也可以退出
  },
}

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- An example for configuring `clangd` LSP to use nvim-cmp as a completion engine
-- require('lspconfig').lua_ls.setup {
--   -- other lspconfig configs
-- }
-- require("lspconfig").lua_ls.setup{}
local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  },
  capabilities = capabilities,
}

lspconfig.gopls.setup {
  capabilities = capabilities,
}
