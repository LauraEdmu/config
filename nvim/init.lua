vim.g.mapleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
  spec = {
    { import = "plugins" }, -- loads lua/plugins/*.lua
    { "preservim/nerdtree" },
    { "junegunn/fzf", build = function() vim.fn["fzf#install"]() end },
    { "junegunn/fzf.vim" },
    { "rebelot/kanagawa.nvim" },
    { "tpope/vim-commentary" },
    -- { "folke/which-key.nvim" },
  },
})

-- Theme
vim.cmd("syntax enable")
vim.o.background = "dark"
vim.cmd("colorscheme kanagawa-wave")

-- Editor settings
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Key mappings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Save with Ctrl+S
map("n", "<C-s>", ":w<CR>", opts)
map("i", "<C-s>", "<Esc>:w<CR>l", opts)

-- Toggle NERDTree
map("n", "<C-n>", ":NERDTreeToggle<CR>", opts)

-- Fuzzy find
map("n", "<C-p>", ":Files<CR>", opts)
map("n", "<C-b>", ":Buffers<CR>", opts)
map("n", "<C-f>", ":Rg<CR>", opts)

-- Clear highlight
map("n", "<A-h>", ":nohlsearch<CR>", opts)

-- Swap lines
map("n", "<C-j>", "ddp", opts)
map("n", "<C-k>", "ddkP", opts)

-- Clipboard yank/paste
map("v", "<leader>y", '"+y', opts)
map("n", "<leader>Y", '"+yg_', opts)
map("n", "<leader>y", '"+y', opts)
map("n", "<leader>p", '"+p', opts)
map("n", "<leader>P", '"+P', opts)

-- Open terminal
map("n", "<leader>t", ":split | terminal<CR>", opts)

-- Resize splits
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate splits
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

