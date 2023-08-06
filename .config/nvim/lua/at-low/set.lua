vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true
vim.opt.colorcolumn = { 80 }

vim.opt.expandtab = false
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 0
vim.opt.tabstop = 8

vim.opt.copyindent = true
vim.opt.preserveindent = true
vim.autoindent = true
vim.smartindent = true

vim.opt.list = true
vim.opt.listchars = {
	multispace = '·',
	tab   = '> ',
	trail = '-',
	nbsp  = '+',
}

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.g.mapleader = " "

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 1
vim.g.netrw_winsize = 25
