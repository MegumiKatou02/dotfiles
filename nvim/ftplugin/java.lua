local jdtls_path = "C:/tools/jdtls"
local lombok_jar = "C:/Users/khong/.m2/repository/org/projectlombok/lombok/1.18.46/lombok-1.18.46.jar"
local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/"
  .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local status, jdtls = pcall(require, "jdtls")
if not status then return end

local root_dir = jdtls.setup.find_root({
  ".git", "mvnw", "gradlew", "pom.xml", "build.gradle",
})
if not root_dir then return end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
  capabilities = cmp_nvim_lsp.default_capabilities()
end

jdtls.start_or_attach({
  name = "jdtls",
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms256m",
    "-Xmx768m",
    "-XX:ReservedCodeCacheSize=128m",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. lombok_jar,
    "-jar", launcher,
    "-configuration", jdtls_path .. "/config_win",
    "-data", workspace_dir,
  },
  root_dir = root_dir,
  capabilities = capabilities,
  settings = {
    java = {
      jdt = { ls = { lombokSupport = { enabled = true } } },
      signatureHelp = { enabled = true },
      maven = { downloadSources = true },
      referencesCodeLens = { enabled = true },
      references = { includeDecompiledSources = true },
      inlayHints = { parameterNames = { enabled = "all" } },
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
  init_options = { bundles = {} },
  on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>co", "<cmd>lua require('jdtls').organize_imports()<CR>", opts)
    vim.keymap.set("n", "<leader>cm", "<cmd>lua require('jdtls').extract_method()<CR>", opts)
    vim.keymap.set("v", "<leader>cm", "<cmd>lua require('jdtls').extract_method(true)<CR>", opts)
    vim.keymap.set("n", "<leader>ct", "<cmd>lua require('jdtls').test_class()<CR>", opts)
    vim.keymap.set("n", "<leader>cT", "<cmd>lua require('jdtls').test_nearest_method()<CR>", opts)
  end,
})
