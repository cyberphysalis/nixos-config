require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

vim.lsp.config["luals"] = {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc" },
  single_file_support = true,
}
vim.lsp.enable("luals")

vim.lsp.config["ts_ls"] = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx"},
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
  single_file_support = true,
}
vim.lsp.enable("ts_ls")

vim.lsp.config["svelte"] = {
  cmd = { "svelteserver", "--stdio" },
  filetypes = { "svelte" },
  root_markers = { "package.json", "svelte.config.js", "svelte.config.cjs" },
  single_file_support = true,
}
vim.lsp.enable("svelte")

vim.lsp.config["rust-analyzer"] = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    single_file_support = true,
    root_dir = function(bufnr, cb)
      local cargo_crate_dir = vim.fs.root(bufnr, { 'Cargo.toml' })
      if cargo_crate_dir then
          vim.system({
              'cargo',
              'metadata',
              '--no-depts',
              '--format-version',
              '1',
              '--manifest-path',
              cargo_crate_dir .. '/Cargo.toml',
          }, { cwd = cargo_crate_dir }, function(obj)
              if obj.code ~= 0 then
                  cb(cargo_crate_dir)
              else
                  local success, result = pcall(vim.json.decode, obj.stdout)
                  if success and result['workspace_root'] then
                      cb(vim.fs.normalize(result['workspace_root']))
                  else
                      cb(cargo_crate_dir)
                  end
              end
          end)
      else
          cb(vim.fs.root(bufnr, { 'rust-project.json', '.git' }))
      end
    end,
  capabilities = {
      experimental = {
          serverStatusNotification = true,
      },
  },
  before_init = function(init_params, config)
      -- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
      if config.settings and config.settings['rust-analyzer'] then
          init_params.initializationOptions = config.settings['rust-analyzer']
      end
  end,
}
vim.lsp.enable("rust-analyzer")
--require("mason-lspconfig").setup({
--  -- 确保需要安装的 LSP 服务，根据需要填写
--  ensure_installed = should_installed_lsp
----  ensure_installed = {
----    "lua_ls",
----    "gopls",
----   },
--})
-- local luasnip = require("luasnip")
-- local cmp = require('cmp')
-- cmp.setup {
--   preselect = cmp.PreselectMode.None,
--   sources = {
--     { name = 'nvim_lsp' }
--   },
--   snippet = {
--     expand = function(args)
--       luasnip.lsp_expand(args.body)
--     end,
--   },
--   mapping = cmp.mapping.preset.insert{
--     -- tab 键向下补全候选词, shift-tab 向上选择
--     ['<Tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       else
--         fallback()
--       end
--     end, { 'i' }),
--     ['<S-Tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       else
--         fallback()
--       end
--     end, { 'i' }),
--     ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace, }),
-- --     ['<CR>'] = cmp.mapping(function(fallback)
-- --         if cmp.visible() then
-- --             if luasnip.expandable() then
-- --                 luasnip.expand()
-- --             else
-- --                 cmp.confirm({
-- --                     select = true,
-- --                 })
-- --             end
-- --         else
-- --             fallback()
-- --         end
-- --     end),
--     ['<C-e>'] = cmp.mapping.abort(),  -- 取消补全，esc也可以退出
--   },
-- }

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
--local capabilities = require('cmp_nvim_lsp').default_capabilities()
--
---- An example for configuring `clangd` LSP to use nvim-cmp as a completion engine
---- require('lspconfig').lua_ls.setup {
----   -- other lspconfig configs
---- }
---- require("lspconfig").lua_ls.setup{}
--local lspconfig = require('lspconfig')
--lspconfig.lua_ls.setup {
--  on_init = function(client)
--    local path = client.workspace_folders[1].name
--    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
--      return
--    end
--
--    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
--      runtime = {
--        -- Tell the language server which version of Lua you're using
--        -- (most likely LuaJIT in the case of Neovim)
--        version = 'LuaJIT'
--      },
--      -- Make the server aware of Neovim runtime files
--      workspace = {
--        checkThirdParty = false,
--        library = {
--          vim.env.VIMRUNTIME
--          -- Depending on the usage, you might want to add additional paths here.
--          -- "${3rd}/luv/library"
--          -- "${3rd}/busted/library",
--        }
--        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
--        -- library = vim.api.nvim_get_runtime_file("", true)
--      }
--    })
--  end,
--  settings = {
--    Lua = {}
--  },
--  capabilities = capabilities,
--}
--
--lspconfig.gopls.setup {
--  capabilities = capabilities,
--}
--
--lspconfig.tsserver.setup{
--  -- capabilities = require("plugins.my").capabilities,
--  capabilities = capabilities,
--}
--
--lspconfig.rust_analyzer.setup {
--  capabilities = capabilities,
--}
--
---- workaround for rust-analyzer server cancelled request
---- https://github.com/neovim/neovim/issues/30985
--for _, method in ipairs { 'textDocument/diagnostic', 'workspace/diagnostic' } do
--  local default_diagnostic_handler = vim.lsp.handlers[method]
--  vim.lsp.handlers[method] = function(err, result, context, config)
--    if err ~= nil and err.code == -32802 then
--      return
--    end
--    return default_diagnostic_handler(err, result, context, config)
--  end
--end
--
--
--lspconfig.svelte.setup {
--  capabilities = capabilities,
--}
--
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
