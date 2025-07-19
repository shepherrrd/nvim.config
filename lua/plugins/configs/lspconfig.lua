dofile(vim.g.base46_cache .. "lsp")
require "nvchad.lsp"

local M = {}
local utils = require "core.utils"

-- export on_attach & capabilities for custom lspconfigs

M.on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad.signature").setup(client)
  end

  if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end

  -- Enable mouse support for Cmd+click navigation
  vim.opt.mouse = "a"
  
  -- Set up Cmd+click for go-to-definition (macOS)
  vim.keymap.set('n', '<D-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', { buffer = bufnr, silent = true })
  vim.keymap.set('n', '<C-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', { buffer = bufnr, silent = true })
  
  -- Set up keyboard shortcuts for go-to-definition
  vim.keymap.set('n', '<D-CR>', '<cmd>lua vim.lsp.buf.definition()<CR>', { buffer = bufnr, silent = true, desc = "Go to definition" })
  vim.keymap.set('n', '<C-CR>', '<cmd>lua vim.lsp.buf.definition()<CR>', { buffer = bufnr, silent = true, desc = "Go to definition" })
  vim.keymap.set('n', '<D-Enter>', '<cmd>lua vim.lsp.buf.definition()<CR>', { buffer = bufnr, silent = true, desc = "Go to definition" })
  vim.keymap.set('n', '<C-Enter>', '<cmd>lua vim.lsp.buf.definition()<CR>', { buffer = bufnr, silent = true, desc = "Go to definition" })
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

-- Enhanced capabilities for better indexing and navigation
M.capabilities.textDocument.definition = {
  dynamicRegistration = true,
  linkSupport = true
}

M.capabilities.textDocument.declaration = {
  dynamicRegistration = true,
  linkSupport = true
}

M.capabilities.textDocument.implementation = {
  dynamicRegistration = true,
  linkSupport = true
}

M.capabilities.textDocument.references = {
  dynamicRegistration = true
}

M.capabilities.textDocument.documentSymbol = {
  dynamicRegistration = true,
  symbolKind = {
    valueSet = {
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26
    }
  },
  hierarchicalDocumentSymbolSupport = true,
  tagSupport = {
    valueSet = { 1 }
  }
}

M.capabilities.workspace = {
  workspaceFolders = true,
  symbol = {
    dynamicRegistration = true,
    symbolKind = {
      valueSet = {
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26
      }
    }
  }
}

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

require("lspconfig").lua_ls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}

return M
