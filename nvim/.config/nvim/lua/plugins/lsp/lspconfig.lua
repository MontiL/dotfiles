return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim",
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

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- mason-lspconfig is configured in mason.lua
    local mason_lspconfig = require("mason-lspconfig")

    local lspconfig = require("lspconfig")

    -- Automatic server setup (advanced feature) :h mason-lspconfig-automatic-server-setup
    if mason_lspconfig.setup_handlers then
      mason_lspconfig.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
            -- on_attach = on_attach,
            -- settings = servers[server_name],
          })
        end,
      })
    else
      -- Fallback: setup common servers manually if setup_handlers doesn't exist
      local servers = { "lua_ls", "ts_ls", "jsonls", "bashls", "pyright" }
      for _, server_name in ipairs(servers) do
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
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
    -- Show line diagnostics automatically in hover window
    vim.lsp.handlers["textDocument/hover"] = function(_, result, _, handler_config)
      local hover_config = handler_config or {}
      hover_config.border = "rounded"
      vim.lsp.util.open_floating_preview(
        vim.lsp.util.convert_input_to_markdown_lines(result.contents),
        "markdown",
        hover_config
      )
    end
    vim.lsp.handlers["textDocument/signatureHelp"] = function(_, result, ctx, handler_config)
      local sig_config = handler_config or {}
      sig_config.border = "rounded"
      local signatures = result.signatures
      if ctx and ctx.client_id then
        signatures = vim.lsp.util.stylize_markdown(signatures, { client_id = ctx.client_id })
      end
      vim.lsp.util.open_floating_preview(
        vim.lsp.util.convert_input_to_markdown_lines(signatures),
        "markdown",
        sig_config
      )
    end
  end,
}
