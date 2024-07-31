return {
	"simrat39/rust-tools.nvim",
	ft = "rust",
	dependencies = "neovim/nvim-lspconfig",
	opts = function()
		return {
			tools = {
				inlay_hints = {
					auto = true,
					show_parameter_hints = true,
				},
			},
			server = {
				on_attach = function(client, bufnr)
					-- Enable completion triggered by <c-x><c-o>
					vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

					-- Instead of using RustSetInlayHints, we'll use the built-in inlay hints feature
					if client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(bufnr, true)
					end

					-- You can add more custom keybindings here if needed
				end,
				settings = {
					["rust-analyzer"] = {
						checkOnSave = {
							command = "clippy",
						},
					},
				},
			},
		}
	end,
	config = function(_, opts)
		require("rust-tools").setup(opts)
	end,
}
