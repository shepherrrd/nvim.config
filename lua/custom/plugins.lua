local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
        "typescript-language-server",
        "omnisharp",
        "pyright",
        "ruff",
        "black",
        "isort"
      },
    },
  },
  {
  
    "rmagatti/goto-preview",
    event = "LspAttach",
    config = function()
      require("goto-preview").setup({
        width = 100,
        height = 20,
        default_mappings = true, -- sets gpd, gpi, etc.
      })
    end,
  },


  {
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
    keys = {
      { "<leader>cs", "<cmd>SymbolsOutline<CR>", desc = "Symbols Outline" },
    },
    config = true,
  },

  
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-symbols.nvim",
    },
    keys = {
      { "gr", "<cmd>Telescope lsp_references<CR>", desc = "LSP References" },
      { "gd", "<cmd>Telescope lsp_definitions<CR>", desc = "LSP Definitions" },
      { "gi", "<cmd>Telescope lsp_implementations<CR>", desc = "LSP Implementations" },
      { "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document Symbols" },
      { "<leader>ws", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace Symbols" },
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
  
  -- Image viewer that works reliably with iTerm2
  {
    "princejoogie/chafa.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "m00qek/baleia.nvim"
    },
    config = function()
      require("chafa").setup({
        render = {
          min_padding = 5,
          show_label = true,
        },
        events = {
          update_on_nvim_resize = true,
        },
      })
    end,
  },
}

return plugins
