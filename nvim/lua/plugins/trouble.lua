return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Workspace/File)" },
    { "<leader>xq", "<cmd>Trouble quickfix toggle<cr>",    desc = "Quickfix List" },
    { "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>", desc = "LSP References" },
    { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Document Symbols" },
  },
}

