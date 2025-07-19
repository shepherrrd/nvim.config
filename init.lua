require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

-- dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"

vim.wo.number = true
vim.wo.relativenumber = true

-- Prevent LSP from loading on binary files (images, etc.)
local image_extensions = {
  'png', 'jpg', 'jpeg', 'gif', 'bmp', 'tiff', 'webp', 'ico', 'svg'
}

local binary_extensions = {
  'pdf', 'zip', 'tar', 'gz', 'rar', 'exe', 'bin', 'so', 'dylib',
  'mp3', 'mp4', 'avi', 'mov', 'wav', 'flac'
}

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*",
  callback = function()
    local filename = vim.fn.expand("%:p")
    local extension = vim.fn.fnamemodify(filename, ":e"):lower()
    
    if vim.tbl_contains(image_extensions, extension) then
      -- Handle image files - let image plugins handle them
      vim.bo.filetype = "image"
      vim.cmd("setlocal noswapfile nobackup noundofile")
      -- Don't set binary mode for images - let image plugins work
    elseif vim.tbl_contains(binary_extensions, extension) then
      -- Handle other binary files
      vim.bo.filetype = "binary"
      vim.cmd("setlocal noswapfile nobackup noundofile readonly")
      vim.cmd("setlocal binary")
      vim.cmd("edit ++bin " .. vim.fn.fnameescape(filename))
    end
  end
})

-- Add image preview keybindings and functions
vim.api.nvim_create_autocmd("FileType", {
  pattern = "image",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(buf)
    
    -- Show image with external viewer (Preview.app on macOS)
    vim.keymap.set('n', '<leader>ip', function()
      vim.fn.system('open "' .. filename .. '"')
    end, { buffer = buf, silent = true, desc = "Preview image externally" })
    
    -- Show image with terminal inline display (iTerm2)
    vim.keymap.set('n', '<leader>ii', function()
      vim.fn.system('imgcat "' .. filename .. '"')
    end, { buffer = buf, silent = true, desc = "Display image inline" })
    
    -- Show image info
    vim.keymap.set('n', '<leader>if', function()
      local info = vim.fn.system('file "' .. filename .. '"')
      vim.notify(info, vim.log.levels.INFO, { title = "Image Info" })
    end, { buffer = buf, silent = true, desc = "Show image info" })
  end
})

-- Global image preview commands
vim.api.nvim_create_user_command('ImageOpen', function(opts)
  local filename = opts.args ~= '' and opts.args or vim.api.nvim_buf_get_name(0)
  vim.fn.system('open "' .. filename .. '"')
end, { nargs = '?', complete = 'file' })

vim.api.nvim_create_user_command('ImageCat', function(opts)
  local filename = opts.args ~= '' and opts.args or vim.api.nvim_buf_get_name(0)
  vim.fn.system('imgcat "' .. filename .. '"')
end, { nargs = '?', complete = 'file' })
