-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Normal mode
local keymap = vim.keymap
keymap.set("n", "<leader>q", "<C-w>q") -- split window vertically
keymap.set("n", "<leader>w", "<cmd>update<cr>") -- split window vertically
keymap.set("n", "<c-l>", "<cmd>noh<cr><esc>")
keymap.set("n", "<space>d", "<cmd>pwd<cr>")

-- Insert mode
keymap.set("i", "jk", "<esc>")

-- Command mode
vim.cmd([[
  cnoremap <expr> %% getcmdtype() == ':' ? expand('%:p:h') . '\' : '%%'
  nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'
  nnoremap <space>lb ^
  nnoremap <space>le g_
]])

-- Widows

-- Location
keymap.set("n", "<space>lo", "<cmd>lopen<cr>", { desc = "Open Location List" })
keymap.set("n", "<space>lc", "<cmd>lclose<cr>", { desc = "Close Location List" })
keymap.set("n", "<space>lol", "<cmd>lolder<cr>", { desc = "Older Location List" })
keymap.set("n", "<space>lne", "<cmd>lnewer<cr>", { desc = "Newer Location List" })
keymap.set("n", "[l", "<cmd>lprevious:<cr>", { desc = "Previous Location List" })
keymap.set("n", "]l", "<cmd>lnext:<cr>", { desc = "Next Location List" })

-- Quickfix
keymap.set("n", "<space>qo", "<cmd>copen<cr>", { desc = "Open Quickfix List" })
keymap.set("n", "<space>qol", "<cmd>colder<cr>", { desc = "Older Quickfix List" })
keymap.set("n", "<space>qne", "<cmd>cnewer<cr>", { desc = "Newer Quickfix List" })
keymap.set("n", "[q", "<cmd>cprevious:<cr>", { desc = "Previous Quickfix List" })
keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next Quickfix List" })

-- Tabs
keymap.set("n", "<space>tn", "<cmd>tabnew<cr>", { desc = "Open new tab" })
keymap.set("n", "]t", "<cmd>tabnext<cr>", { desc = "Next tab" })
keymap.set("n", "[t", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
keymap.set("n", "<space>to", "<cmd>tabonly<cr>", { desc = "Only tab" })
keymap.set("n", "<space>tf", "<cmd>tabfirst<cr>", { desc = "First tab" })
keymap.set("n", "<space>tl", "<cmd>tablast<cr>", { desc = "Last tab" })
keymap.set("n", "<space>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })

-- Lines
-- keymap.set("n", "<leader>lb", "^", { desc = "Start of line" })
-- keymap.set("n", "<leader>le", "g_", { desc = "End of line" })

-- Toggle
keymap.set("n", "yop", "<cmd>set paste!<cr>", {})

-- plugins ---------------------
-- telescope
-- local is_inside_work_tree = {}
-- local is_in_git = function()
--   local cwd = vim.fn.getcwd()
--   if is_inside_work_tree[cwd] == nil then
--     vim.fn.system("git rev-parse --is-inside-work-tree")
--     is_inside_work_tree[cwd] = vim.v.shell_error == 0
--   end
-- end
-- -- local builtin = require("telescope.builtin")
-- local project_files = function()
--   if is_in_git() then
--     require("telescope.builtin").git_files()
--   else
--     require("telescope.builtin").find_files()
--   end
-- end
-- keymap.set("n", "<leader>fd", function()
--   project_files()
-- end, {})
keymap.set("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", {})
keymap.set("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", {})
keymap.set("n", "<leader>ss", "<cmd>lua require('telescope.builtin').grep_string()<cr>", {})
keymap.set("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", {})
keymap.set("n", "<leader>fm", "<cmd>lua require('telescope.builtin').marks()<cr>", {})
keymap.set("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", {})
keymap.set("n", "<leader>fo", "<cmd>lua require('telescope.builtin').oldfiles()<cr>", {})
keymap.set("n", "<leader>ft", "<cmd>lua require('telescope.builtin').git_status()<cr>", {})
-- keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")

-- neo-tree
keymap.set("n", "yon", "<cmd>Neotree toggle<cr>", {})
