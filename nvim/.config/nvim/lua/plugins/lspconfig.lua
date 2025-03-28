return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    --[[ "williamboman/nvim-lsp-installer", ]]
    --[[ "tamago324/nlsp-settings.nvim", -- language server settings defined in json ]]
    -- "jose-elias-alvarez/null-ls.nvim",
    "folke/neodev.nvim",
  },
  config = function()
    -- Server Configurations
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#dockerls
    local servers = {
      bashls = {},
      vimls = {},
      taplo = {},
      yamlls = {},
      lua_ls = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            --[[ library = vim.api.nvim_get_runtime_file("", true), ]]
            checkThirdParty = false,
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = { enable = false },
        },
      },
      -- luau_lsp = {},
      -- NOTE: need to have `pyrightconfig.json` in root folder
      -- pyright = {
      --   Python = {
      --     analysis = {
      --       autoSearchPaths = true,
      --       diagnosticMode = "workspace",
      --       useLibraryCodeForTypes = true,
      --     }
      --   }
      -- },
      pylsp = {},
      -- web
      ts_ls = {},
      tailwindcss = {},
      emmet_ls = {},
      jsonls = {},
      prosemd_lsp = {},
      -- studying
      --[[ vuels = {}, ]]
      --[[ astro = {}, ]]
      --[[ svelte = {}, ]]
      prismals = {},
      -- dockerls = {},
    }

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    -- Setup mason so it can manage external tooling
    require("mason").setup()

    -- Ensure the servers above are installed
    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers) })
    local lspconfig = require("lspconfig")

    -- Automatic server setup (advanced feature) :h mason-lspconfig-automatic-server-setup
    mason_lspconfig.setup_handlers({
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
          -- on_attach = on_attach,
          settings = servers[server_name],
        })
      end,
    })

    require("lsp_handlers").setup()
    -- require("lsp.null-ls")
    --[[ require("lsp.lsp-installer") ]]
  end,
}
