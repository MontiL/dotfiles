local M = {}

-- TODO: backfill this to template
M.setup = function()
  -- Diagnostic symbols in the sign column (gutter)
  local signs = { Error = " ", Warn = " ", Hint = "● ", Info = "" }

  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  local config = {
    -- disable virtual text
    --[[ virtual_text = true, ]]
    virtual_text = { prefix = '●' },
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
  vim.lsp.handlers["textDocument/hover"] = function(_, result, _, handler_config)
    local hover_config = handler_config or {}
    hover_config.border = "rounded"
    vim.lsp.util.open_floating_preview(vim.lsp.util.convert_input_to_markdown_lines(result.contents), "markdown", hover_config)
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
      "markdown", sig_config)
  end
end

return M
