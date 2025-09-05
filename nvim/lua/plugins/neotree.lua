return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		lazy = false, -- neo-tree will lazily load itself
		config = function()
			require("neo-tree").setup({
				filesystem = {
					filtered_items = {
						visible = true, -- do not show dotfiles
						hide_dotfiles = false,
						hide_gitignored = true,
						show_hidden_count = true,
					},
				},
			})
			vim.keymap.set("n", "<leader>v", ":Neotree filesystem reveal left<CR>", {})
		end,
	},
}
