return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/lazydev.nvim",
    --[[ "williamboman/nvim-lsp-installer", ]]
    --[[ "tamago324/nlsp-settings.nvim", -- language server settings defined in json ]]
    -- "jose-elias-alvarez/null-ls.nvim",
  },
  config = function()
    -- Server Configurations
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#dockerls
    -- local servers = {
    --   bashls = {},
    --   vimls = {},
    --   taplo = {},
    --   yamlls = {},
    --   lua_ls = {
    --     Lua = {
    --       runtime = {
    --         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
    --         version = "LuaJIT",
    --       },
    --       diagnostics = {
    --         -- Get the language server to recognize the `vim` global
    --         globals = { "vim" },
    --       },
    --       workspace = {
    --         -- Make the server aware of Neovim runtime files
    --         --[[ library = vim.api.nvim_get_runtime_file("", true), ]]
    --         checkThirdParty = false,
    --       },
    --       -- Do not send telemetry data containing a randomized but unique identifier
    --       telemetry = { enable = false },
    --     },
    --   },
    --   -- luau_lsp = {},
    --   -- NOTE: need to have `pyrightconfig.json` in root folder
    --   -- pyright = {
    --   --   Python = {
    --   --     analysis = {
    --   --       autoSearchPaths = true,
    --   --       diagnosticMode = "workspace",
    --   --       useLibraryCodeForTypes = true,
    --   --     }
    --   --   }
    --   -- },
    --   pylsp = {},
    --   -- web
    --   ts_ls = {},
    --   tailwindcss = {},
    --   emmet_ls = {},
    --   jsonls = {},
    --   prosemd_lsp = {},
    --   -- studying
    --   --[[ vuels = {}, ]]
    --   --[[ astro = {}, ]]
    --   --[[ svelte = {}, ]]
    --   prismals = {},
    --   -- dockerls = {},
    -- }

    -- blink.cmp provides LSP capabilities
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- ts_ls: prioritize tsconfig.json for root detection (monorepo support)
    vim.lsp.config('ts_ls', {
      root_markers = { 'tsconfig.json', 'package.json' },
    })

    -- mason-lspconfig is configured in mason.lua
    local mason_lspconfig = require("mason-lspconfig")

    -- Use new vim.lsp.config API instead of deprecated lspconfig
    -- Automatic server setup (advanced feature) :h mason-lspconfig-automatic-server-setup
    if mason_lspconfig.setup_handlers then
      mason_lspconfig.setup_handlers({
        function(server_name)
          -- Use vim.lsp.enable with configuration
          vim.lsp.enable(server_name)
          -- Configure capabilities through vim.lsp.config
          if vim.lsp.config[server_name] then
            vim.lsp.config[server_name] = vim.tbl_deep_extend('force', vim.lsp.config[server_name] or {}, {
              capabilities = capabilities,
            })
          end
        end,
      })
    else
      -- Fallback: setup common servers manually if setup_handlers doesn't exist
      local servers = { "lua_ls", "ts_ls", "jsonls", "bashls", "pyright" }
      for _, server_name in ipairs(servers) do
        vim.lsp.enable(server_name)
        if vim.lsp.config[server_name] then
          vim.lsp.config[server_name] = vim.tbl_deep_extend('force', vim.lsp.config[server_name] or {}, {
            capabilities = capabilities,
          })
        end
      end
    end

    -- Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = "● ", Info = "" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
    local config = {
      -- disable virtual text
      --[[ virtual_text = true, ]]
      virtual_text = { prefix = "●" },
      -- show signs
      signs = { active = signs },
      update_in_insert = true,
      underline = true,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    }
    vim.diagnostic.config(config)
    -- Rounded borders for hover and signature help
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
  end,
}
