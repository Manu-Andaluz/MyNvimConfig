return {
	"mfussenegger/nvim-dap",
	event = "VeryLazy",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"David-Kunz/jester", -- Add Jester as a dependency
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local jester = require("jester")

		-- Jester setup
		jester.setup({
			cmd = "npm run test:e2e -t '$result' -- $file", -- Adjust this if needed
			dap = {
				type = "pwa-node",
				request = "launch",
				cwd = vim.fn.getcwd(),
				runtimeArgs = { "--inspect-brk", "$path_to_jest", "--no-coverage", "-t", "$result", "--", "$file" },
				args = { "--no-cache" },
				sourceMaps = true,
				protocol = "inspector",
				console = "integratedTerminal",
				port = 9229,
				disableOptimisticBPs = true,
			},
		})

		-- DAP setup for pwa-node
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = {
					vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
					"${port}",
				},
			},
		}

		dap.configurations.typescript = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Debug Current E2E Test File",
				runtimeExecutable = "node",
				runtimeArgs = {
					"./node_modules/jest/bin/jest.js",
					"--runInBand",
					"--config",
					"./test/jest-e2e.json",
					"${file}",
				},
				rootPath = "${workspaceFolder}",
				cwd = "${workspaceFolder}",
				console = "integratedTerminal",
				internalConsoleOptions = "neverOpen",
			},
		}

		dapui.setup()

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- Keymaps for Jester
		vim.keymap.set("n", "<Leader>jr", jester.run, { desc = "Jest run" })
		vim.keymap.set("n", "<Leader>jd", jester.debug, { desc = "Jest debug" })
		vim.keymap.set("n", "<Leader>jf", jester.run_file, { desc = "Jest run file" })
		vim.keymap.set("n", "<Leader>jl", jester.run_last, { desc = "Jest run last" })

		-- Existing keymaps
		vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
		vim.keymap.set("n", "<Leader>dc", dap.continue, {})
		vim.keymap.set("n", "<Leader>do", dapui.toggle, {})
		vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
	end,
}
