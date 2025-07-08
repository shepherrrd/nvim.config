local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
        "typescript-language-server",
        "omnisharp"
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "mfussenegger/nvim-dap",
    init = function()
      require("core.utils").load_mappings("dap")
    end
  },
  {
    "dreamsofcode-io/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      require("core.utils").load_mappings("dap")
    end
  },
  -- {
  --   "jose-elias-alvarez/null-ls.nvim",
  --   ft = {
  --     "go",
  --     "javascript",
  --     "typescript",
  --     "python",
  --   },
  --   opts = function()
  --     return require "custom.configs.null-ls"
  --   end,
  -- },
  {
    "nvimtools/none-ls.nvim",
    ft = {
      "go",
      "javascript",
      "typescript",
      "python",
    },
    opts = function(_, opts)
      return require "custom.configs.null-ls"
			-- local nls = require('null-ls')
			-- opts.sources = vim.list_extend(opts.sources or {}, {
			-- 	nls.builtins.code_actions.gitsigns,
			-- 	-- go
			-- 	nls.builtins.code_actions.gomodifytags,
			-- 	nls.builtins.code_actions.impl,
			-- 	nls.builtins.diagnostics.golangci_lint,
			-- 	-- ts
			-- 	nls.builtins.formatting.biome,
			-- 	require('typescript.extensions.null-ls.code-actions'),
			-- 	-- other
			-- 	nls.builtins.formatting.stylua,
			-- 	nls.builtins.formatting.shfmt,
			-- })
			-- return opts
		end,
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
      require("core.utils").load_mappings("gopher")
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
}

return plugins
