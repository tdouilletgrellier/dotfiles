local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	use ("wbthomason/packer.nvim") -- Have packer manage itself	
  use ('williamboman/mason.nvim')
  use ('williamboman/mason-lspconfig.nvim')
  use ('neovim/nvim-lspconfig')
-- Hrsh7th Code Completion Suite
    use 'hrsh7th/nvim-cmp' 
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/cmp-vsnip'                             
    use 'hrsh7th/cmp-path'                              
    use 'hrsh7th/cmp-buffer'                            
    use 'hrsh7th/vim-vsnip'  
 -- File explorer tree
 use {
  'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
 }

 -- Dracula theme for styling
 use 'Mofiqul/dracula.nvim'
 use 'rafamadriz/neon'
 use 'folke/tokyonight.nvim'

  -- Treesitter
 use {
  -- recommended packer way of installing it is to run this function, copied from documentation
         'nvim-treesitter/nvim-treesitter',
      run = function()
              local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
              ts_update()
         end,

 }

 -- Telescope used to fuzzy search files
 use {
    'nvim-telescope/telescope.nvim', --, tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
 }

 -- Lualine information / Status bar
 use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
 }

 use {
	"windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
}

use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}

    use 'majutsushi/tagbar'  


use "lukas-reineke/indent-blankline.nvim"

use 'voldikss/vim-floaterm'
use 'mfussenegger/nvim-lint'
use 'folke/which-key.nvim'
use 'dstein64/nvim-scrollview'

use {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
 --db.setup({
    theme = 'hyper',
    config = {
      week_header = {
       enable = true,
      },

--dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
      shortcut = {
        { desc = ' New File', group = '@property', action = 'enew', key = 'e' },

        { desc = '󰊳 Sync Plugins', group = '@variable', action = 'PackerSync', key = 'u' },
        {
          icon = ' ',
          icon_hl = 'DiagnosticHint',
          desc = 'Find Files',
          group = 'Label',
          action = 'Telescope find_files',
          key = 'ff',
        },
        {
          desc = ' Live Grep',
          group = 'Number',
          action = 'Telescope live_grep',
          key = 'fg',
        },
        {
          desc = ' Toggle Tree',
          group = '@property',
          action = 'NvimTreeToggle',
          key = 'n',
        },
        { desc = '  Quit NVim', group = '@variable', action = 'qa', key = 'q' },        
      },
      project = { enable = false },
    },
  --})
    }
  end,
  requires = {'nvim-tree/nvim-web-devicons'}
}

use {
    "nvim-zh/colorful-winsep.nvim",
    config = function ()
        require('colorful-winsep').setup()
    end
}


use 'phaazon/hop.nvim'
use 'HiPhish/nvim-ts-rainbow2'

use  {'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {'williamboman/mason.nvim'},           -- Optional
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},         -- Required
            {'hrsh7th/cmp-nvim-lsp'},     -- Required
            {'hrsh7th/cmp-buffer'},       -- Optional
            {'hrsh7th/cmp-path'},         -- Optional
            {'saadparwaiz1/cmp_luasnip'}, -- Optional
            {'hrsh7th/cmp-nvim-lua'},     -- Optional

            -- Snippets
            {'L3MON4D3/LuaSnip'},             -- Required
            {'rafamadriz/friendly-snippets'}, -- Optional
        }
      }

use  'akinsho/toggleterm.nvim'





	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)