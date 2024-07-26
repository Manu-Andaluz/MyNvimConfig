return {
	{
		"xiyaowong/transparent.nvim",
		lazy = false,
		config = function()
			require("transparent").setup({
				extra_groups = {
					"NormalFloat",
					"NvimTreeNormal",
					"NeoTreeNormal",
					"NeoTreeNormalNC",
					"NeoTreeEndOfBuffer",
				},
				exclude_groups = { "CursorLine" }, -- Add this line
			})
			vim.cmd([[TransparentEnable]])
		end,
	},
}
