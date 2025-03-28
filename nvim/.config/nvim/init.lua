-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- required by lazy and nvim-tree
vim.opt.termguicolors = true

-- disable netrw at the very start of your init.lua (strongly advised)
-- suggested from nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- skip backwards compatibility routines and speed up loading
vim.g.skip_ts_context_commentstring_module = true

require("config.lazy")
require("core")
