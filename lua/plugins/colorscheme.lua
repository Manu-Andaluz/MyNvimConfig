return {
	"olimorris/onedarkpro.nvim",
	opts = {
		options = {
			transparency = true,
			cursorline = true,
		},
		highlights = {
			Visual = { fg = "#e2e2e2", bg = "#0D47A1", style = "bold" },
			IncSearch = { fg = "#e2e2e2", bg = "#0D47A1", style = "bold" },
			-- Add this line to set a custom background color
			Normal = { bg = "#1a1b26" }, -- Replace with your desired color

			-- Add this line to highlight the cursor line with a soft white
			CursorLine = { bg = "#2c2e3e" }, -- Adjust the color code for desired softness
		},
	},
}
