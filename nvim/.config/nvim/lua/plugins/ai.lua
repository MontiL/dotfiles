return {
  {
    'Exafunction/codeium.vim',
    enabled = true,
    version = "1.8.37",
    event = "InsertEnter",
    config = function()
      -- disable all keybindings
      vim.g.codeium_disable_bindings = 1
      vim.g.codeium_idle_delay = 0
      vim.keymap.set('i', '<C-f>', function() return vim.fn['codeium#Accept']() end,
        { desc = "Codeium [f]or me", silent = true, expr = true })
      vim.keymap.set('i', '<C-d>', function() return vim.fn['codeium#Clear']() end,
        { desc = "Codeium [D]ismiss", silent = true, expr = true })
      vim.keymap.set('i', '<C-j>', function() return vim.fn['codeium#CycleCompletions'](1) end,
        { desc = "Codeium [j]ump to next", silent = true, expr = true })
      vim.keymap.set('i', '<C-o>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
        { desc = "Codeium jump to [o]ld", silent = true, expr = true })
    end
  },
}
