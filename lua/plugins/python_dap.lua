return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"rcarriga/nvim-dap-ui",
			"mfussenegger/nvim-dap-python",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local dap_python = require("dap-python")

			require("dapui").setup({
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						position = "left",
						size = 40,
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						position = "bottom",
						size = 10,
					},
				},
			})

			require("nvim-dap-virtual-text").setup({
				commented = true, -- Show virtual text alongside comment
			})
			dap_python.setup("python3")

			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					pythonPath = function()
						return "python3"
					end,
					console = "integratedTerminal",
					cwd = "${workspaceFolder}",
				},
			}

			vim.fn.sign_define("DapBreakpoint", {
				text = "",
				texthl = "DiagnosticSignError",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapBreakpointRejected", {
				text = "", -- or "❌"
				texthl = "DiagnosticSignError",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapStopped", {
				text = "", -- or "→"
				texthl = "DiagnosticSignWarn",
				linehl = "Visual",
				numhl = "DiagnosticSignWarn",
			})
			-- Automatically open/close DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			local opts = { noremap = true, silent = true }

			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Toggle breakpoint
			vim.keymap.set("n", "<leader>db", function()
				dap.toggle_breakpoint()
			end, opts)
			-- Continue / Start
			vim.keymap.set("n", "<leader>dc", function()
				dap.continue()
			end, opts)
			-- Step Over
			vim.keymap.set("n", "<leader>do", function()
				dap.step_over()
			end, opts)
			-- Step Into
			vim.keymap.set("n", "<leader>di", function()
				dap.step_into()
			end, opts)
			-- Step Out
			vim.keymap.set("n", "<leader>dO", function()
				dap.step_out()
			end, opts)
			-- Keymap to terminate debugging
			vim.keymap.set("n", "<leader>dq", function()
				require("dap").terminate()
			end, opts)
			-- Toggle DAP UI
			vim.keymap.set("n", "<leader>du", function()
				dapui.toggle()
			end, opts)
		end,
	},
}
