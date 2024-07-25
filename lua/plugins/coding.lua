return {
	-- Create annotations with one keybind, and jump your cursor in the inserted annotation
	{
		"danymat/neogen",
		keys = {
			{
				"<leader>cc",
				function()
					require("neogen").generate({})
				end,
				desc = "Neogen Comment",
			},
		},
		opts = { snippet_engine = "luasnip" },
	},

	-- Incremental rename
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = true,
	},

	-- Refactoring tool
	{
		"ThePrimeagen/refactoring.nvim",
		keys = {
			{
				"<leader>r",
				function()
					require("refactoring").select_refactor()
				end,
				mode = "v",
				noremap = true,
				silent = true,
				expr = false,
			},
		},
		opts = {},
	},

	-- Go forward/backward with square brackets
	{
		"echasnovski/mini.bracketed",
		event = "BufReadPost",
		config = function()
			local bracketed = require("mini.bracketed")
			bracketed.setup({
				file = { suffix = "" },
				window = { suffix = "" },
				quickfix = { suffix = "" },
				yank = { suffix = "" },
				treesitter = { suffix = "n" },
			})
		end,
	},

	-- Better increase/descrease
	{
		"monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					augend.integer.alias.decimal,
					augend.integer.alias.hex,
					augend.date.alias["%Y/%m/%d"],
					augend.constant.alias.bool,
					augend.semver.alias.semver,
					augend.constant.new({ elements = { "let", "const" } }),
				},
			})
		end,
	},

	{
		"simrat39/symbols-outline.nvim",
		keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
		cmd = "SymbolsOutline",
		opts = {
			position = "right",
		},
	},

	-- extend auto completion
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			local cmp = require("cmp")
			opts.mapping = vim.tbl_deep_extend("force", opts.mapping, {
				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-m>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			})
		end,
	},

	-- Modify nvim-cmp configuration
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			local cmp = require("cmp")

			-- Disable ghost text (parameter hints)
			opts.experimental = opts.experimental or {}
			opts.experimental.ghost_text = false

			-- Enhance completion
			opts.completion = vim.tbl_extend("force", opts.completion or {}, {
				completeopt = "menu,menuone,noinsert",
			})

			-- Add parenthesis completion and show parameters
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			-- Modify the formatting of completion items
			opts.formatting = vim.tbl_extend("force", opts.formatting or {}, {
				format = function(entry, vim_item)
					-- Show parameter names in completion menu
					if entry.completion_item.labelDetails then
						vim_item.abbr =
							string.format("%s (%s)", vim_item.abbr, entry.completion_item.labelDetails.detail or "")
					end
					return vim_item
				end,
			})

			return opts
		end,
	},

	-- Ensure nvim-autopairs is installed
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	-- Disable inlay hints for LSP
	{
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hints = { enabled = false },
			capabilities = {
				textDocument = {
					inlayHint = {
						dynamicRegistration = false,
					},
				},
			},
		},
	},

	{
		"kamykn/spelunker.vim",
		event = "BufReadPre",
		config = function()
			vim.g.spelunker_check_type = 2
			vim.g.spelunker_disable_epic_comments = 1
			vim.g.spelunker_disable_backquoted_checking = 1
		end,
	},

	-- Spell checking in comments for programming languages
	{
		"lewis6991/spellsitter.nvim",
		config = function()
			require("spellsitter").setup()
		end,
	},

	-- Code actions for spell checking
	{
		"f3fora/cmp-spell",
		dependencies = "hrsh7th/nvim-cmp",
		config = function()
			require("cmp").setup({
				sources = {
					{ name = "spell" },
					-- your other sources
				},
			})
		end,
	},

	-- nvim-navic for showing code context
	{
		"SmiteshP/nvim-navic",
		dependencies = "neovim/nvim-lspconfig",
		config = function()
			require("nvim-navic").setup({
				highlight = true,
				depth_limit = 5,
				icons = {
					File = " ",
					Module = " ",
					Namespace = " ",
					Package = " ",
					Class = " ",
					Method = " ",
					Property = " ",
					Field = " ",
					Constructor = " ",
					Enum = " ",
					Interface = " ",
					Function = " ",
					Variable = " ",
					Constant = " ",
					String = " ",
					Number = " ",
					Boolean = " ",
					Array = " ",
					Object = " ",
					Key = " ",
					Null = " ",
					EnumMember = " ",
					Struct = " ",
					Event = " ",
					Operator = " ",
					TypeParameter = " ",
				},
			})
		end,
	},

	-- lualine for statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic" },
		event = "VeryLazy",
		opts = function()
			return {
				sections = {
					lualine_c = {
						{ "filename", path = 1 },
						{
							function()
								return require("nvim-navic").get_location()
							end,
							cond = function()
								return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
							end,
						},
					},
				},
			}
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic" },
		event = "VeryLazy",
		opts = function()
			local function diagnostics_indicator(_, _, diagnostics, _)
				local symbols = { Error = " ", Warn = " ", Info = " " }
				local result = {}
				for name, count in pairs(diagnostics) do
					if symbols[name] and count > 0 then
						table.insert(result, symbols[name] .. count)
					end
				end
				return table.concat(result, " ")
			end

			return {
				options = {
					theme = "auto",
					globalstatus = true,
					disabled_filetypes = { statusline = { "dashboard", "alpha" } },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = {
						{
							"diagnostics",
							symbols = {
								error = " ",
								warn = " ",
								info = " ",
								hint = " ",
							},
						},
						{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
						{ "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
						{
							function()
								return require("nvim-navic").get_location()
							end,
							cond = function()
								return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
							end,
						},
					},
					lualine_x = {
						{
							function()
								return require("noice").api.status.command.get()
							end,
							cond = function()
								return package.loaded["noice"] and require("noice").api.status.command.has()
							end,
							color = "Statement",
						},
						{
							function()
								return require("noice").api.status.mode.get()
							end,
							cond = function()
								return package.loaded["noice"] and require("noice").api.status.mode.has()
							end,
							color = "Constant",
						},
						{
							function()
								return "  " .. require("dap").status()
							end,
							cond = function()
								return package.loaded["dap"] and require("dap").status() ~= ""
							end,
							color = "Debug",
						},
						{
							require("lazy.status").updates,
							cond = require("lazy.status").has_updates,
							color = "Special",
						},
						{
							"diff",
							symbols = {
								added = " ",
								modified = " ",
								removed = " ",
							},
						},
					},
					lualine_y = {
						{ "progress", separator = " ", padding = { left = 1, right = 0 } },
						{ "location", padding = { left = 0, right = 1 } },
					},
					lualine_z = {
						function()
							return " " .. os.date("%R")
						end,
					},
				},
				extensions = { "neo-tree", "lazy" },
			}
		end,
	},
}
