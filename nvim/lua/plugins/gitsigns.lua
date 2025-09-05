return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "契" },
      topdelete    = { text = "契" },
      changedelete = { text = "▎" },
    },
    current_line_blame = true,
  },
}

