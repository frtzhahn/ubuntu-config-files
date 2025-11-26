-- =============================
-- Beginner-friendly Neovim config (Lua version)
-- =============================

-- init.lua
-- MUST be first, before any keymaps
vim.g.mapleader = " " -- Sets the leader key to the spacebar
-- vim.g.maplocalleader = " "   -- optional


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
      auto_update = true,   -- automatically updates Discord presence
      show_file = true,     -- show the current file name
      show_branch = false,  -- hide git branch
      editor_icon = true,  -- hide Neovim icon
      workspace_text      = "Working on %s",
      enable_line_number  = true,
      line_number_text    = "Line %s out of %s",
    })
  end
}




--use {
--    "vyfor/cord.nvim",
--    config = function()
--        require("cord").setup({
--            auto_update = true,  -- optional, automatically updates presence
--            show_file = false,    -- show current file name
--            show_branch = false,  -- show git branch
--       })
--    end
--}


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

-- Horizontal split terminal
map('n', '<Leader>th', ':split | terminal<CR>', opts)

-- Vertical split terminal
map('n', '<Leader>tv', ':vsplit | terminal<CR>', opts)

-- Floating terminal
map('n', '<Leader>tf', function()
  vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    row = math.floor(vim.o.lines * 0.1),
    col = math.floor(vim.o.columns * 0.1),
    style = 'minimal',
    border = 'rounded',
  })
  vim.cmd('terminal')
end, opts)


local float_term_win

map('n', '<Leader>tf', function()
  local buf = vim.api.nvim_create_buf(false, true)
  float_term_win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    row = math.floor(vim.o.lines * 0.1),
    col = math.floor(vim.o.columns * 0.1),
    style = 'minimal',
    border = 'rounded',
  })
  vim.cmd('terminal')
end, opts)


map('n', '<Leader>tj', function()
  if float_term_win and vim.api.nvim_win_is_valid(float_term_win) then
    vim.api.nvim_set_current_win(float_term_win)
  end
end, opts)



-- Navigate between splits (normal + terminal mode)
map({'n', 't'}, '<Leader>h', '<C-\\><C-N><C-w>h', opts)
map({'n', 't'}, '<Leader>j', '<C-\\><C-N><C-w>j', opts)
map({'n', 't'}, '<Leader>k', '<C-\\><C-N><C-w>k', opts)
map({'n', 't'}, '<Leader>l', '<C-\\><C-N><C-w>l', opts)


-- Resize splits (using Ctrl + Arrow keys)
map('n', '<C-Up>', ':resize +2<CR>', opts)
map('n', '<C-Down>', ':resize -2<CR>', opts)
map('n', '<C-Left>', ':vertical resize -2<CR>', opts)
map('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- Close current split
map('n', '<Leader>q', ':close<CR>', opts)


-- Horizontal empty split
map('n', '<Leader>sh', ':new<CR>', opts)

-- Vertical empty split
map('n', '<Leader>sv', ':vnew<CR>', opts)



local map = vim.keymap.set

map("n", "<F5>", function()
    local file = vim.fn.expand("%:p")         -- full path
    local filename = vim.fn.expand("%:t")     -- filename.ext
    local filetype = vim.bo.filetype
    local basename = vim.fn.expand("%:t:r")   -- filename only
    local dir = vim.fn.fnamemodify(file, ":h") -- directory

    if filename == "" then
        print("Save the file first.")
        return
    end

    local cmd = nil

    ---------------------------------------------------------
    -- JAVA
    ---------------------------------------------------------
    if filetype == "java" then
        cmd = string.format(
            'konsole --noclose -e sh -c "cd %s && clear && javac %s && java %s; exec zsh"',
            dir, filename, basename
        )

    ---------------------------------------------------------
    -- C
    ---------------------------------------------------------
    elseif filetype == "c" then
        cmd = string.format(
            'konsole --noclose -e sh -c "cd %s && clear && gcc %s -o %s && ./%s; exec zsh"',
            dir, filename, basename, basename
        )

    ---------------------------------------------------------
    -- C++
    ---------------------------------------------------------
    elseif filetype == "cpp" then
        cmd = string.format(
            'konsole --noclose -e sh -c "cd %s && clear && g++ %s -o %s && ./%s; exec zsh"',
            dir, filename, basename, basename
        )

    ---------------------------------------------------------
    -- PYTHON
    ---------------------------------------------------------
    elseif filetype == "python" then
        cmd = string.format(
            'konsole --noclose -e sh -c "cd %s && clear && python3 %s; exec zsh"',
            dir, filename
        )

    ---------------------------------------------------------
    -- JAVASCRIPT (node)
    ---------------------------------------------------------
    elseif filetype == "javascript" then
        cmd = string.format(
            'konsole --noclose -e sh -c "cd %s && clear && node %s; exec zsh"',
            dir, filename
        )

    ---------------------------------------------------------
    -- TYPESCRIPT (ts-node)
    ---------------------------------------------------------
    elseif filetype == "typescript" then
        cmd = string.format(
            'konsole --noclose -e sh -c "cd %s && clear && ts-node %s; exec zsh"',
            dir, filename
        )

    ---------------------------------------------------------
    -- BASH scripts
    ---------------------------------------------------------
    elseif filetype == "sh" then
        cmd = string.format(
            'konsole --noclose -e sh -c "cd %s && clear && bash %s; exec zsh"',
            dir, filename
        )

    ---------------------------------------------------------
    -- LUA
    ---------------------------------------------------------
    elseif filetype == "lua" then
        cmd = string.format(
            'konsole --noclose -e sh -c "cd %s && clear && lua %s; exec zsh"',
            dir, filename
        )

    ---------------------------------------------------------
    -- GO
    ---------------------------------------------------------
    elseif filetype == "go" then
        cmd = string.format(
            'konsole --noclose -e sh -c "cd %s && clear && go run %s; exec zsh"',
            dir, filename
        )

    else
        print("Unsupported filetype: " .. filetype)
        return
    end

    vim.fn.jobstart(cmd)   -- launch Konsole
end)



-- 1️⃣ Load plugins (packer / lazy)
require('plugins')  

-- 2️⃣ Setup Nvim-Tree floating config
require("nvim-tree").setup({
  view = {
    float = {
      enable = true,
      open_win_config = function()
        local width = 50
        local height = 20
        local row = math.floor((vim.o.lines - height) / 2)
        local col = math.floor((vim.o.columns - width) / 2)
        return {
          relative = "editor",
          border = "rounded",
          width = width,
          height = height,
          row = row,
          col = col,
        }
      end,
    },
  },
  renderer = {
    icons = {
      show = {
        git = true,
        folder = true,
        file = true,
      }
    }
  }
})

