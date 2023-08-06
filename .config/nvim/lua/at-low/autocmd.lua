local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup('vimrc_highlight_incsearch', { clear = true })
autocmd({ 'CmdlineEnter' }, {
	pattern = { '/', '?' },
	group = 'vimrc_highlight_incsearch',
	callback = function() vim.opt.hlsearch = true end,
})
autocmd({ 'CmdlineLeave' }, {
	pattern = { '/', '?' },
	group = 'vimrc_highlight_incsearch',
	callback = function() vim.opt.hlsearch = false end,
})

augroup('vimrc_highlight_yank', { clear = true })
autocmd('TextYankPost', {
	group = 'vimrc_highlight_yank',
	pattern = '*',
	callback = function()
		vim.highlight.on_yank({
			higroup = 'IncSearch',
			timeout = 40,
		})
	end,
})
