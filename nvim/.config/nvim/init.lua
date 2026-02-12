-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- required by lazy
vim.opt.termguicolors = true

-- skip backwards compatibility routines and speed up loading
vim.g.skip_ts_context_commentstring_module = true

require("config.lazy")
require("core")
