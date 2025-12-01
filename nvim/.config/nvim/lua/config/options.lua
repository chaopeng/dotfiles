-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- use absolute line number.
vim.opt.relativenumber = false

-- use treesitter to folding code blocks.
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- once 0.10, we can use build-in osc52
-- use osc 52 clipboard which is supported on kitty.
-- vim.g.clipboard = {
--   name = "OSC 52",
--   copy = {
--     ["+"] = require("vim.clipboard.osc52").copy,
--     ["*"] = require("vim.clipboard.osc52").copy,
--   },
--   paste = {
--     ["+"] = require("vim.clipboard.osc52").paste,
--     ["*"] = require("vim.clipboard.osc52").paste,
--   },
-- }

local function copy(lines, _)
  require("osc52").copy(table.concat(lines, "\n"))
end

local function paste()
  return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
end

vim.g.clipboard = {
  name = "osc52",
  copy = { ["+"] = copy, ["*"] = copy },
  paste = { ["+"] = paste, ["*"] = paste },
}

-- Fuchsia related ----------------------------------------

vim.filetype.add({ extension = { cml = "json5" } })
vim.filetype.add({ extension = { fidl = "fidl" } })
