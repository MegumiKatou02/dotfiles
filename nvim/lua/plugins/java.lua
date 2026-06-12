return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      local jdtls = require("jdtls")
      local root_dir = jdtls.setup.find_root({
        ".git", "mvnw", "gradlew", "pom.xml", "build.gradle"
      })
      if not root_dir then
        return
      end

      local jdtls_path = "C:/tools/jdtls"
      local launcher = "bin/jdtls.bat" -- Windows
      local cmd_path = jdtls_path .. "/" .. launcher

      if vim.fn.executable(cmd_path) ~= 1 then
        vim.notify("jdtls not found at " .. cmd_path, vim.log.levels.ERROR)
        return
      end


      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_capabilities = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_capabilities.default_capabilities()
      end

      local config = {
        cmd = {
          cmd_path,
          "-configuration", vim.fn.stdpath("cache") .. "/jdtls/config",
          "-data", vim.fn.stdpath("cache") .. "/jdtls/workspace/"
            .. vim.fn.fnamemodify(root_dir, ":p:h:t"),
            "--jvm-arg=-javaagent:C:/Users/khong/.m2/repository/org/projectlombok/lombok/1.18.46/lombok-1.18.46.jar",
        },
        cmd_cwd = jdtls_path,
        root_dir = root_dir,
        capabilities = capabilities,
        settings = {
          java = {
            jdt = {
                ls = {
                    lombokSupport = {
                        enabled = true
                    },
                },
            },
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-21",
                  path = "C:/Program Files/Eclipse Adoptium/jdk-21.0.8.9-hotspot",
                },
              },
            },
            completion = {
              favoriteStaticMembers = {
                "org.assertj.core.api.Assertions.*",
                "org.junit.jupiter.api.Assertions.*",
                "org.mockito.Mockito.*",
                "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
                "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
              },
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
          },
        },
        on_attach = function(client, bufnr)
          local opts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

          -- Java specific
          vim.keymap.set("n", "<leader>co", "<cmd>lua require('jdtls').organize_imports()<CR>", opts)
          vim.keymap.set("n", "<leader>cm", "<cmd>lua require('jdtls').extract_method()<CR>", opts)
          vim.keymap.set("v", "<leader>cm", "<cmd>lua require('jdtls').extract_method(true)<CR>", opts)
          vim.keymap.set("n", "<leader>ct", "<cmd>lua require('jdtls').test_class()<CR>", opts)
          vim.keymap.set("n", "<leader>cT", "<cmd>lua require('jdtls').test_nearest_method()<CR>", opts)
        end,
      }

      jdtls.start_or_attach(config)
    end,
  },
}
