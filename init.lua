
vim.g.mapleader = " "

vim.opt.updatetime = 300
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.syntax = on
vim.opt.encoding = 'utf-8'
vim.opt.showmatch = true
vim.opt.mouse = 'a'
vim.opt.cmdheight = 2
vim.opt.signcolumn = 'number'
vim.opt.undofile = true
vim.opt.background = 'dark'
vim.opt.termguicolors = true

vim.opt.number = true
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', '<cmd>quit<cr>', { desc = 'Quit' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to below split' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to above split' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })

-- Bootstrap Packer
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

-- Initialize Packer
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'folke/tokyonight.nvim'
  use 'navarasu/onedark.nvim'
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
  }
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use 'lewis6991/gitsigns.nvim'
    use 'windwp/nvim-autopairs'
    use {"akinsho/toggleterm.nvim", tag = '*'}
  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- Automatically run :PackerCompile whenever plugins.lua is updated
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerCompile
  augroup end
]])


vim.cmd[[colorscheme onedark]]
local function set_colorscheme(scheme, style)
  -- Clear existing highlights
  vim.cmd('highlight clear')

  if scheme == "onedark" then
    require('onedark').setup {
      style = style  -- Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', and 'light'
    }
    require('onedark').load()
  elseif scheme == "tokyonight" then
    vim.g.tokyonight_style = style  -- Choose between 'storm', 'night', and 'day'
    vim.cmd[[colorscheme tokyonight]]
  end

  -- Force Neovim to re-evaluate the colorscheme
  vim.cmd('doautocmd ColorScheme')

  -- Refresh the status line if you're using one (e.g., lualine)
  if pcall(require, 'lualine') then
    require('lualine').refresh()
  end

  -- Print a confirmation message
  print("Colorscheme set to " .. scheme .. " (" .. style .. ")")
end

-- Create a Neovim command to easily switch color schemes
vim.api.nvim_create_user_command('ColorScheme', function(opts)
  set_colorscheme(opts.fargs[1], opts.fargs[2])
end, {
  nargs = '+',
  complete = function(_, _, _)
    return {'onedark', 'tokyonight'}
  end
})


-- Telescope setup
require('telescope').setup{}

-- Telescope keymaps
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- NvimTree setup
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- NvimTree keymap
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', {})


-- NvimTreeSitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "lua", "vim", "vimdoc", "javascript", "python" },
    highlight = {
        enable = true,
    },
}

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_serparators = { left = '', right = ''},
    },
}

require('gitsigns').setup()
require('nvim-autopairs').setup()

require("toggleterm").setup{
  size = 20,
  open_mapping = [[<leader>t]],  -- Changed this line
  hide_numbers = true,
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
}

vim.keymap.set('n', '<leader>th', ':ToggleTerm size=20 direction=horizontal<CR>', {noremap = true, silent = true})
