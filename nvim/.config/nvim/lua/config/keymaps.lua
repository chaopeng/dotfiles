-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>wt", "<cmd> split term://fish<cr>", { desc = "Open a terminal in hsplit window" })

-- also support cc to yank. for mouse friendly.
map("v", "cc", "y")
-- in normal mode, just copy whole line.
map("n", "cc", "yy")

-- cv for paste
map("v", "cv", "p")
map("n", "cv", "0p")
