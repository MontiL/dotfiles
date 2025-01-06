local status, null_ls = pcall(require, "null-ls")
if not status then return end

-- code action sources
local code_actions = null_ls.builtins.code_actions
-- diagnostic sources
local diagnostics = null_ls.builtins.diagnostics
-- formatting sources
local formatting = null_ls.builtins.formatting
-- hover sources
--[[ local hover = null_ls.builtins.hover ]]
-- completion sources
--[[ local completion = null_ls.builtins.completion ]]

-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- local lsp_formatting = function(bufnr)
--   vim.lsp.buf.format({
--     filter = function(client) return client.name == "null-ls" end,
--     bufnr = bufnr,
--   })
-- end

null_ls.setup({
  sources = {
    -- formatting.prettierd.with({
    --   env = {
    --     PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/nvim/utils/.prettierrc.json"),
    --   },
    -- }),
    -- formatting.prettierd.with({
    --   extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
    -- }),

    formatting.prettier,
    -- formatting.prettier.with({ async = true }),
    -- formatting.prettierd,
    -- formatting.prettierd.with({
    --   env = {
    --     PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/nvim/utils/.prettierrc.json"),
    --   },
    -- }),
    -- formatting.prettierd.with({
    --   extra_args = {
    --     "--plugin-search-dir=.",
    --     "--plugin=prettier-plugin-tailwindcss",
    --   },
    -- }),

    -- formatting.black.with({ extra_args = { "--fast" } }), -- for Python
    -- diagnostics.flake8 -- for Python

    diagnostics.fish,
    formatting.fish_indent,

    diagnostics.vint,
    code_actions.eslint_d,
    -- formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
    --[[ formatting.prettier, ]]
    --[[ diagnostics.eslint_d.with({ ]]
    --[[   diagnostics_format = '[eslint] #{m}\n(#{c})' ]]
    --[[ }), ]]
    --
    -- For Lua
    --[[ diagnostics.selene,
		diagnostics.luacheck.with({ extra_args = { "--globals", "vim" } }),
		formatting.stylua, ]]
  },

  -- Formatting on save
  -- you can reuse a shared lspconfig on_attach callback here
  --[[ on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end, ]]

  -- on_attach = function(client, bufnr)
  --   if client.supports_method("textDocument/formatting") then
  --     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  --     vim.api.nvim_create_autocmd("BufWritePre", {
  --       group = augroup,
  --       buffer = bufnr,
  --       callback = function()
  --         lsp_formatting(bufnr)
  --       end,
  --     })
  --   end
  -- end,
})

--[[ vim.api.nvim_create_user_command("DisableLspFormatting", function()
  vim.api.nvim_clear_autocmds({ group = augroup, buffer = 0 })
end, { nargs = 0 }) ]]
