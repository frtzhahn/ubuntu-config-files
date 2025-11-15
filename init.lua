-- =============================
-- Beginner-friendly Neovim config (Lua version)
-- =============================

require("plugins")

-- Show line numbers
vim.opt.number = true

-- Enable syntax highlighting (Neovim already does this)
vim.cmd("syntax on")

-- Enable mouse support
vim.opt.mouse = "a"

-- Enable system clipboard
vim.opt.clipboard = "unnamedplus"

-- Tabs and indentation
vim.opt.expandtab = true      -- use spaces instead of tabs
vim.opt.tabstop = 4           -- number of spaces for a tab
vim.opt.shiftwidth = 4        -- number of spaces for autoindent

-- Search settings
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Auto indentation
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Show status line
vim.opt.laststatus = 2

-- Make backspace behave naturally
vim.opt.backspace = { "indent", "eol", "start" }

-- Reduce message noise
vim.opt.shortmess:append("I")

-- =============================
-- Keymaps
-- =============================

local map = vim.keymap.set

-- Save file: Ctrl + s
map("n", "<C-s>", ":w<CR>", { silent = true })
map("i", "<C-s>", "<Esc>:w<CR>a", { silent = true })

-- Quit Neovim: Ctrl + q
map("n", "<C-q>", ":q<CR>", { silent = true })
map("i", "<C-q>", "<Esc>:q<CR>", { silent = true })

-- =============================
-- Auto commands
-- =============================

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
    pattern = "*",
    command = "redraw!"
})



-- Bootstrap packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Plugins
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- File explorer
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-tree/nvim-web-devicons'

  -- Fuzzy finder
  use {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/plenary.nvim'}}

  -- LSP and Autocomplete
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'L3MON4D3/LuaSnip'

  -- Statusline
  use 'nvim-lualine/lualine.nvim'

  --wakatime
  use 'wakatime/vim-wakatime'



-- Discord Rich Presence for Neovim
use {
    "vyfor/cord.nvim",
    config = function()
        require("cord").setup({
            auto_update = true,  -- optional, automatically updates presence
            show_file = true,    -- show current file name
            show_branch = true,  -- show git branch
        })
    end
}


  if packer_bootstrap then
    require('packer').sync()
  end
end)



-- =============================
-- File Explorer (like VSCode sidebar)
-- =============================
require("nvim-tree").setup{
  view = { width = 30 },
  renderer = { icons = { show = { git = true, folder = true, file = true } } },
}

-- Toggle file explorer with Ctrl+n
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true })

-- =============================
-- Telescope (Fuzzy Finder)
-- =============================
vim.keymap.set('n', '<C-p>', ':Telescope find_files<CR>', { silent = true })
vim.keymap.set('n', '<C-f>', ':Telescope live_grep<CR>', { silent = true })

-- =============================
-- Lualine (Statusline)
-- =============================
require('lualine').setup{
  options = { theme = 'auto', section_separators = '', component_separators = '' }
}



-- Enable LSP for Python and Lua
local lspconfig = require('lspconfig')

lspconfig.pyright.setup{}
lspconfig.lua_ls.setup{}


-- Enable true color support
vim.opt.termguicolors = true



vim.opt.laststatus = 3



-- =============================
-- Split management keymaps
-- =============================
local map = vim.keymap.set
local opts = { silent = true }

-- Navigate splits (using <Leader> + h/j/k/l)
map('n', '<Leader>h', '<C-w>h', opts)
map('n', '<Leader>j', '<C-w>j', opts)
map('n', '<Leader>k', '<C-w>k', opts)
map('n', '<Leader>l', '<C-w>l', opts)

-- Resize splits (using Ctrl + Arrow keys)
map('n', '<C-Up>', ':resize +2<CR>', opts)
map('n', '<C-Down>', ':resize -2<CR>', opts)
map('n', '<C-Left>', ':vertical resize -2<CR>', opts)
map('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- Close current split
map('n', '<Leader>q', ':close<CR>', opts)

-- Open new horizontal split
map('n', '<Leader>sh', ':split<CR>', opts)

-- Open new vertical split
map('n', '<Leader>sv', ':vsplit<CR>', opts)


-- =============================
-- Compile and run code in terminal
-- =============================
local map = vim.keymap.set

map("n", "<F5>", function()
    local filetype = vim.bo.filetype
    local file = vim.fn.expand("%")  -- current file
    local output = vim.fn.expand("%:r") -- filename without extension

    if filetype == "c" then
        vim.cmd('!gnome-terminal -- bash -c "gcc ' .. file .. ' -o ' .. output .. ' && ./' .. output .. '; exec bash"')
    elseif filetype == "cpp" then
        vim.cmd('!gnome-terminal -- bash -c "g++ ' .. file .. ' -o ' .. output .. ' && ./' .. output .. '; exec bash"')
    elseif filetype == "python" then
        vim.cmd('!gnome-terminal -- bash -c "python3 ' .. file .. '; exec bash"')
    elseif filetype == "java" then
        vim.cmd('!gnome-terminal -- bash -c "javac ' .. file .. ' && java ' .. output .. '; exec bash"')
    else
        print("No auto-run setup for this filetype")
    end
end, { silent = true })

