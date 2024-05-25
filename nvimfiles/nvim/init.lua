vim.cmd([[
    let g:python3_host_prog = 'C:\\Users\\tony5\\AppData\\Local\\Programs\\Python\\Python312\\python.exe'
]])
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.keymaps")
require("config.lazy")
