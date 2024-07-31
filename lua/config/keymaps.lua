-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Keymaps are automatically loaded on the VeryLazy event
-- Add any additional keymaps here
local discipline = require("craftzdog.discipline")
discipline.cowboy()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "de", 've"_d')
keymap.set("n", "db", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Move between windows
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize window
keymap.set("n", "<C-S-h>", "5<C-w><", { desc = "Decrease window width" })
keymap.set("n", "<C-S-j>", "5<C-w>-", { desc = "Decrease window height" })
keymap.set("n", "<C-S-k>", "5<C-w>+", { desc = "Increase window height" })
keymap.set("n", "<C-S-l>", "5<C-w>>", { desc = "Increase window width" })

--
-- Keeping the old resize mappings as well
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Navigate to file definition
keymap.set("n", "<leader>;", function()
	require("telescope.builtin").lsp_definitions({
		jump_type = "vsplit", -- or "split" for horizontal split
		reuse_win = true,
	})
end, { desc = "Go to definition" })

-- Replace all exact occurrences of the current word in the root directory
keymap.set("n", "<leader>rw", function()
	local word = vim.fn.expand("<cword>")
	local qf_list = {}

	-- Search for the exact word in all files
	local handle = io.popen(string.format("rg --vimgrep '\\b%s\\b'", word))
	if handle then
		for line in handle:lines() do
			table.insert(qf_list, {
				filename = vim.fn.fnamemodify(line:match("^(.-):%d+"), ":p"),
				lnum = tonumber(line:match(":(%d+):")),
				col = tonumber(line:match(":%d+:(%d+):")),
				text = line:match(":%d+:%d+:(.+)"),
			})
		end
		handle:close()
	end

	-- Populate the quickfix list
	vim.fn.setqflist(qf_list)

	-- Open the quickfix window
	vim.cmd("copen")

	-- Prompt for the replacement word
	local replacement = vim.fn.input("Replace '" .. word .. "' with: ")
	if replacement ~= "" then
		-- Perform the replacement
		vim.cmd(string.format("cfdo %%s/\\<%s\\>/%s/gc | update", word, replacement))
	end
end, { desc = "Replace exact word in project" })
