return {
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    -- lazy = true,
    cmd = "Trouble",
    config = function()
      require("trouble").setup()
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local status, dap = pcall(require, "dap")
      if not status then
        return
      end

      local is_windows = vim.loop.os_uname().version:match("Windows")

      -- local venv = os.getenv("VIRTUAL_ENV")
      -- local command = vim.fn.getcwd() .. string.format("%s/bin/python", venv)
      -- dap.adapters.python = {
      -- 	type = "executable",
      -- 	-- command = 'path/to/virtualenvs/debugpy/bin/python';
      -- 	-- command = { os.getenv("HOME") .. "/.virtualenvs/debugpy/bin/python" },
      -- 	command = command,
      -- 	args = { "-m", "debugpy.adapter" },
      -- }
      --
      -- dap.configurations.python = {
      -- 	{
      -- 		-- The first three options are required by nvim-dap
      -- 		type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
      -- 		request = "launch",
      -- 		name = "Launch file",
      --
      -- 		-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
      --
      -- 		program = "${file}", -- This configuration will launch the current file if used.
      -- 		pythonPath = function()
      -- 			-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- 			-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- 			-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      -- 			-- local cwd = vim.fn.getcwd()
      -- 			-- if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
      -- 			-- 	return cwd .. "/venv/bin/python"
      -- 			-- elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
      -- 			-- 	return cwd .. "/.venv/bin/python"
      -- 			-- else
      -- 			-- 	return "/usr/bin/python"
      -- 			-- end
      -- 			return command
      -- 		end,
      -- 	},
      -- }

      if is_windows then
        PYTHON_PATH = "~/.pyenv/pyenv-win/shims/python.bat"
        -- HOME_PATH = os.getenv("UserProfile")
      else
        local handle = io.popen("brew --prefix")
        if not handle then
          return
        end

        local brew_prefix = string.gsub(handle:read("*a"), "\n", "")
        -- PYTHON_PATH = "~/.virtualenvs/debugpy/bin/python"
        -- PYTHON_PATH = "~/.pyenv/shims/python"

        -- PYTHON_PATH = brew_prefix .. "/opt/python@3.12/libexec/bin/python"
        PYTHON_PATH = "/Users/monti/.pyenv/shims/python"
        -- HOME_PATH = os.getenv("HOME")
      end

      require("dap-python").setup(PYTHON_PATH)

      --[[ dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { os.getenv("HOME") .. "/.z/ghq/github.com/microsoft/vscode-node-debug2/out/src/nodeDebug.js" },
}
dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require 'dap.utils'.pick_process,
  },
} ]]
      -- require('dap').set_log_level('INFO')
      dap.defaults.fallback.terminal_win_cmd = "10split new"
      -- vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
      -- vim.fn.sign_define("DapBreakpointRejected", { text = "🟦", texthl = "", linehl = "", numhl = "" })
      -- vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })
      --[[ vim.highlight.create("DapBreakpoint", { ctermbg = 0, guifg = "#993939", guibg = "#31353f" }, false) ]]
      --[[ vim.highlight.create("DapLogPoint", { ctermbg = 0, guifg = "#61afef", guibg = "#31353f" }, false) ]]
      --[[ vim.highlight.create("DapStopped", { ctermbg = 0, guifg = "#98c379", guibg = "#31353f" }, false) ]]
      vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
      vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

      vim.fn.sign_define(
        "DapBreakpoint",
        --[[ { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" } ]]
        { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapBreakpointCondition", { text = "ﳁ", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )
      vim.fn.sign_define(
        "DapLogPoint",
        { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
      )
      vim.fn.sign_define(
        "DapStopped",
        { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
      )

      -- Debugger
      ----------------------------------------------------------------------
      -- vim.keymap.set("n", "<leader>db", ':lua require"dap".toggle_breakpoint()<CR>')
      -- vim.keymap.set("n", "<leader>dB", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
      -- vim.keymap.set("n", "<leader>do", ':lua require"dap".step_out()<CR>')
      -- vim.keymap.set("n", "<leader>di", ':lua require"dap".step_into()<CR>')
      -- vim.keymap.set("n", "<leader>dd", ':lua require"dap".step_over()<CR>')
      -- vim.keymap.set("n", "<leader>dc", ':lua require"dap".continue()<CR>')
      -- vim.keymap.set("n", "<leader>dn", ':lua require"dap".run_to_cursor()<CR>')
      -- vim.keymap.set("n", "<leader>dk", ':lua require"dap".up()<CR>zz')
      -- vim.keymap.set("n", "<leader>dj", ':lua require"dap".down()<CR>zz')
      -- vim.keymap.set("n", "<leader>dt", ':lua require"dap".terminate()<CR>')
      -- vim.keymap.set("n", "<leader>dr", ':lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l')
      -- vim.keymap.set("n", "<leader>dR", ':lua require"dap".clear_breakpoints()<CR>')
      -- vim.keymap.set("n", "<leader>de", ':lua require"dap".set_exception_breakpoints({"all"})<CR>')
      -- vim.keymap.set("n", "<leader>da", ':lua require"debugHelper".attach()<CR>')
      -- vim.keymap.set("n", "<leader>dA", ':lua require"debugHelper".attachToRemote()<CR>')
      -- vim.keymap.set("n", "<leader>dh", ':lua require"dap.ui.widgets".hover()<CR>')
      -- vim.keymap.set(
      -- 	"n",
      -- 	"<leader>d?",
      -- 	':lua local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>'
      -- )
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup({})
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      require("dap-python").setup("python")
    end,
  },
}
