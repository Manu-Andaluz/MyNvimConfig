return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = {
		filesystem = {
			filtered_items = {
				visible = true, -- This line makes hidden files visible
				hide_dotfiles = false,
				hide_gitignored = false,
			},
		},
	},
}
