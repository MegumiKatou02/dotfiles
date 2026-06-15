return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = 'master',
    lazy = false,
    config = function()
        local configs = require("nvim-treesitter.configs")

        require("nvim-treesitter.install").compilers = { "zig", "gcc", "clang" }

        configs.setup({
            ensure_installed = {
                "c",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "elixir",
                "heex",
                "javascript",
                "html",
                "typescript",
                "tsx",
                "css",
                "vue",
                "rust",
            },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
    }
