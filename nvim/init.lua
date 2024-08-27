-- vim-plug plugin setup
vim.cmd([[
call plug#begin('~/.vim/plugged')

" List your plugins here
Plug 'preservim/nerdtree' " File explorer
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'rebelot/kanagawa.nvim'
Plug 'tpope/vim-commentary'

call plug#end()
]])
-- Plug 'folke/which-key.nvim'

-- Theme enable
vim.cmd('syntax enable')
vim.o.background = 'dark'
vim.cmd('colorscheme kanagawa-wave') -- wave = dark, dragon = darker, lotus = light

-- Set guifont
-- vim.o.guifont = 'FiraCode:h14'

-- Set line numbers
vim.wo.number = true

-- Enable syntax highlighting
vim.cmd('syntax on')

-- Set tabs and indentation
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Enable relative line numbers
vim.wo.relativenumber = true

-- Remap leader key to space
vim.g.mapleader = ' '

-- Save with Ctrl+s
vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-s>', '<Esc>:w<CR>l', { noremap = true, silent = true })

-- Toggle NERDTree with Ctrl+n
vim.api.nvim_set_keymap('n', '<C-n>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })

-- Fuzzy find files with Ctrl+p
vim.api.nvim_set_keymap('n', '<C-p>', ':Files<CR>', { noremap = true, silent = true })

-- Fuzzy find buffers with Ctrl+b
vim.api.nvim_set_keymap('n', '<C-b>', ':Buffers<CR>', { noremap = true, silent = true })

-- Search project with Ctrl+f
vim.api.nvim_set_keymap('n', '<C-f>', ':Rg<CR>', { noremap = true, silent = true })

-- remove highlighting with Alt-h
vim.api.nvim_set_keymap('n', '<A-h>', ':nohlsearch<CR>', { noremap = true, silent = true })

-- Swap the current line with the line below using <C-j>
vim.api.nvim_set_keymap('n', '<C-j>', 'ddp', { noremap = true, silent = true })

-- Swap the current line with the line above using <C-k>
vim.api.nvim_set_keymap('n', '<C-k>', 'ddkP', { noremap = true, silent = true })



-- Copy to system clipboard
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>Y', '"+yg_', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>p', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>P', '"+P', { noremap = true, silent = true })

-- open terminal
vim.api.nvim_set_keymap('n', '<leader>t', ':split | terminal<CR>', { noremap = true, silent = true })

-- resize splits
vim.api.nvim_set_keymap('n', '<C-Up>', ':resize +2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Down>', ':resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true })

-- navigate splits
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
