local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local opts = {
  sources = {
    null_ls.builtins.formatting.clang_format.with({
      filetypes = {
        "c",
        "cpp",
        "proto",
      },
    }),
    null_ls.builtins.formatting.gofumpt.with({
      filetypes = { "go" },
    }),
    null_ls.builtins.formatting.goimports_reviser.with({
      filetypes = { "go" },
    }),
    null_ls.builtins.formatting.golines.with({
      filetypes = { "go" },
    }),
    null_ls.builtins.formatting.prettier.with({
      filetypes = {
        "javascript",
        "typescript",
        "css",
        "scss",
        "html",
        "json",
        "yaml",
        "markdown",
        "graphql",
        "md",
        "txt",
      },
    }),
    null_ls.builtins.formatting.black.with({
      filetypes = {
        "python"
      }
    }),
  },
   on_attach = function(client, bufnr)
    if client:supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = bufnr,
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
}

return opts
