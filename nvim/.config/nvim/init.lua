-- required by lazy and nvim-tree
vim.opt.termguicolors = true

-- disable netrw at the very start of your init.lua (strongly advised)
-- suggested from nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- skip backwards compatibility routines and speed up loading
vim.g.skip_ts_context_commentstring_module = true

-- Use new regular expression engine to fix issue:              █
-- 'redrawtime' exceeded, syntax highlighting disabled
--[[ vim.cmd "set re=0" ]]
-- Automatically install Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup("plugins")


require("keymaps")
require("options")

--[[ require("styles") ]]
--[[ require("lsp") ]]
