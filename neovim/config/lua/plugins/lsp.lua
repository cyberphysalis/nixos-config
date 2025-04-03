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
elseif file_ext == "go" then
  table.insert(should_installed_lsp, "gopls")
elseif file_ext == "js" then
  -- table.insert(should_installed_lsp, "biome")
  table.insert(should_installed_lsp, "ts_ls")
elseif file_ext == "rs" then
  table.insert(should_installed_lsp, "rust_analyzer")
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
local luasnip = require("luasnip")
local cmp = require('cmp')
cmp.setup {
  preselect = cmp.PreselectMode.None,
  sources = {
    { name = 'nvim_lsp' }
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
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
    ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace, }),
--     ['<CR>'] = cmp.mapping(function(fallback)
--         if cmp.visible() then
--             if luasnip.expandable() then
--                 luasnip.expand()
--             else
--                 cmp.confirm({
--                     select = true,
--                 })
--             end
--         else
--             fallback()
--         end
--     end),
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

lspconfig.ts_ls.setup{
  -- capabilities = require("plugins.my").capabilities,
  capabilities = capabilities,
}

lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
}

-- workaround for rust-analyzer server cancelled request
-- https://github.com/neovim/neovim/issues/30985
for _, method in ipairs { 'textDocument/diagnostic', 'workspace/diagnostic' } do
  local default_diagnostic_handler = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function(err, result, context, config)
    if err ~= nil and err.code == -32802 then
      return
    end
    return default_diagnostic_handler(err, result, context, config)
  end
end


lspconfig.svelte.setup {
  capabilities = capabilities,
}

require('copilot').setup({
  suggestion = {
    auto_trigger = true,
    keymap = {
      accept = "<C-j>",
    }
  },
  filetypes = {
    markdown = true,
    yaml = true,
  },
})
