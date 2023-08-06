-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.2',
		-- or                            , branch = '0.1.x',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	use {
		'folke/tokyonight.nvim',
		config = function()
			vim.cmd [[colorscheme tokyonight-moon]]
			-- There are also colorschemes for the different styles.
			--colorscheme tokyonight
			--colorscheme tokyonight-night
			--colorscheme tokyonight-storm
			--colorscheme tokyonight-day
			--colorscheme tokyonight-moon
		end
	}

	use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
	use 'nvim-treesitter/playground'

	use {
		'ThePrimeagen/harpoon',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	use 'mbbill/undotree'
	use 'tpope/vim-fugitive'

	use {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	}

	use {
		'hrsh7th/nvim-cmp',
		'hrsh7th/cmp-nvim-lsp',
		'L3MON4D3/LuaSnip',
	}

end)
