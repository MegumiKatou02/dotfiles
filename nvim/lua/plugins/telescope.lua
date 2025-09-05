
return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")
      local builtin   = require("telescope.builtin")

      telescope.setup({
        defaults = {
          file_ignore_patterns = { "%.class" },
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = { preview_width = 0.6, width = 0.9 },
            vertical   = { preview_height = 0.6, height = 0.9 },
          },

          get_selection_window = function()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              local bt  = vim.api.nvim_buf_get_option(buf, "buftype")
              local ft  = vim.api.nvim_buf_get_option(buf, "filetype")
              if bt == "" and ft ~= "neo-tree" and ft ~= "NvimTree" and ft ~= "TelescopePrompt" then
                return win
              end
            end
            return vim.api.nvim_get_current_win()
          end,
          mappings = {
            i = {
              ["<CR>"] = actions.select_default + actions.center, -- Enter: mở ở win hiện tại
              ["<C-x>"] = actions.select_horizontal,               -- mở ở horizontal split
              ["<C-v>"] = actions.select_vertical,                 -- mở ở vertical split
              ["<C-t>"] = actions.select_tab,                      -- mở ở tab mới
            },
            n = {
              ["<CR>"] = actions.select_default + actions.center,
            },
          },
        },
        extensions = {
          ["ui-select"] = require("telescope.themes").get_dropdown({}),
        },
      })

      telescope.load_extension("ui-select")

      -- Keymaps an toàn: nếu đang đứng ở neo-tree thì nhảy qua pane code trước rồi mới mở
      local function safe(fn)
        return function()
          local ft = vim.bo.filetype
          if ft == "neo-tree" or ft == "NvimTree" then vim.cmd("wincmd w") end
          fn()
        end
      end

      vim.keymap.set("n", "<leader>ff", safe(builtin.find_files), { desc = "Find Files" })
      vim.keymap.set("n", "<leader>pf", safe(builtin.git_files),  { desc = "Git Files"  })
      vim.keymap.set("n", "<leader>fg", safe(builtin.live_grep),  { desc = "Live Grep"  })
      vim.keymap.set("n", "<leader>fb", safe(builtin.buffers),    { desc = "Buffers"    })
      vim.keymap.set("n", "<leader>fh", safe(builtin.help_tags),  { desc = "Help Tags"  })
    end,
  },
}
