return {
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local on_attach = function(client, bufnr)
				if vim.bo[bufnr].filetype == "vue" and client.name == "ts_ls" then
					client.server_capabilities.semanticTokensProvider = nil
				end
			end
			-- local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			-- lua
			vim.lsp.config["lua_ls"] = {
				cmd = { "lua-language-server" },
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			}
			-- local mason_registry = require("mason-registry")
			local vue_language_server = vim.fn.stdpath("data")
				.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

			-- typescript
			vim.lsp.config["ts_ls"] = {
				capabilities = capabilities,
                on_attach = on_attach,
				init_options = {
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = vue_language_server,
							languages = { "vue" },
						},
					},
				},
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			}
			-- Js
			vim.lsp.config["eslint"] = {
				capabilities = capabilities,
			}
			-- zig
			vim.lsp.config["zls"] = {
				capabilities = capabilities,
			}
		end,
	},
}
