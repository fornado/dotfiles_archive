-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
if false then return {} end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- add gruvbox
  -- { "ellisonleao/gruvbox.nvim" },

  -- Configure LazyVim to load gruvbox
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "gruvbox",
  --   },
  -- },

  -- nvim v0.8.0
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "yog", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    config = function()
      vim.g.lazygit_use_neovim_remote = 0
      require("telescope").load_extension("lazygit")
    end,
  },
  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- disable trouble
  { "folke/flash.nvim", enabled = false },

  -- disable trouble
  { "folke/trouble.nvim", enabled = true },

  -- enabled trouble
  {
    "lewis6991/gitsigns.nvim",
    enabled = true,
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "┃" },
        delete = { text = "-" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end)

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end)

        -- Actions
        map("n", "<leader>hs", gitsigns.stage_hunk)
        map("n", "<leader>hr", gitsigns.reset_hunk)
        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        map("n", "<leader>hu", gitsigns.undo_stage_hunk)
        map("n", "<leader>hS", gitsigns.stage_buffer)
        map("n", "<leader>hR", gitsigns.reset_buffer)
        map("n", "<leader>hp", gitsigns.preview_hunk)
        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end)
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
        map("n", "<leader>hd", gitsigns.diffthis)
        map("n", "<leader>hD", function()
          gitsigns.diffthis("~")
        end)
        map("n", "<leader>td", gitsigns.toggle_deleted)

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,
    },
  },

  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        -- "nvim-telescope/telescope-live-grep-args.nvim",
        -- version = "^1.0.0",
      },
    },
    keys = {
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        -- vimgrep_arguments = {
        --   "rg",
        --   "--color=never",
        --   "--no-heading",
        --   "--with-filename",
        --   "--line-number",
        --   "--column",
        --   "--smart-case",
        --   "--trim", -- add this value
        -- },
        mappings = {
          i = {
            ["<esc>"] = require("telescope.actions").close,
            ["<C-u>"] = false,
            ["<C-j>"] = require("telescope.actions").cycle_history_next,
            ["<C-k>"] = require("telescope.actions").cycle_history_prev,
            ["<C-p>"] = require("telescope.actions").move_selection_previous,
            ["<C-n>"] = require("telescope.actions").move_selection_next,
            -- ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
            -- ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " }),
            -- ["<C-j>"] = require("telescope.actions").move_selection_next,
            -- ["<C-k>"] = require("telescope.actions").move_selection_previous,
            -- ["<C-n>"] = require("telescope.actions").cycle_history_next,
            -- ["<C-p>"] = require("telescope.actions").cycle_history_prev,
          },
        },
      },
      pickers = {
        find_files = {
          mappings = {
            n = {
              ["cd"] = function(prompt_bufnr)
                local selection = require("telescope.actions.state").get_selected_entry()
                local dir = vim.fn.fnamemodify(selection.path, ":p:h")
                require("telescope.actions").close(prompt_bufnr)
                -- Depending on what you want put `cd`, `lcd`, `tcd`
                vim.cmd(string.format("silent lcd %s", dir))
              end,
            },
          },
          find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
        },
      },
    },
    config = function()
      -- local is_inside_work_tree = {}
      -- local is_in_git = function()
      --   local cwd = vim.fn.getcwd()
      --   if is_inside_work_tree[cwd] == nil then
      --     vim.fn.system("git rev-parse --is-inside-work-tree")
      --     is_inside_work_tree[cwd] = vim.v.shell_error == 0
      --   end
      -- end
      -- local builtin = require("telescope.builtin")
      -- local project_files = function()
      --   if is_in_git() then
      --     builtin.git_files()
      --   else
      --     builtin.find_files()
      --   end
      -- end
      -- vim.keymap.set("n", "<leader>fd", function()
      --   project_files()
      -- end)
      -- vim.keymap.set("n", "<leader>fd", <cmd>project_files()<cr>, {})
      -- vim.keymap.set("n", "<leader>fd", <cmd>project_files()<cr>, {})
      -- vim.api.nvim_set_keymap("n", "<Leader>fd", "<CMD>project_files()<CR>", { noremap = true, silent = true })
    end,
  },

  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
      },
    },
  },
  -- -- add volar to lspconfig
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       tsserver = {},
  --     },
  --   },
  -- },
  -- If you are using mason.nvim, you can get the ts_plugin_path like this
  -- local mason_registry = require('mason-registry')
  -- local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'

  -- local vue_language_server_path = '/path/to/@vue/language-server'

  -- local lspconfig = require('lspconfig')

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = "C:\\Program Files\\nodejs\\node-global\\node_modules\\@vue\\language-server",
                languages = { "vue" },
              },
            },
          },
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        },
        volar = {},
      },
    },
  },
  -- add tsserver and setup with typescript.nvim instead of lspconfig
  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = {
  --     "jose-elias-alvarez/typescript.nvim",
  --     init = function()
  --       require("lazyvim.util").lsp.on_attach(function(_, buffer)
  --         -- stylua: ignore
  --         vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
  --         vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
  --       end)
  --     end,
  --   },
  --   ---@class PluginLspOpts
  --   opts = {
  --     ---@type lspconfig.options
  --     servers = {
  --       -- tsserver will be automatically installed with mason and loaded with lspconfig
  --       tsserver = {},
  --     },
  --     -- you can do any additional lsp server setup here
  --     -- return true if you don't want this server to be setup with lspconfig
  --     ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
  --     setup = {
  --       -- example to setup with typescript.nvim
  --       tsserver = function(_, opts)
  --         require("typescript").setup({ server = opts })
  --         return true
  --       end,
  --       -- Specify * to use this function as a fallback for any server
  --       -- ["*"] = function(server, opts) end,
  --     },
  --   },
  -- },

  -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
  -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
  { import = "lazyvim.plugins.extras.lang.typescript" },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "LazyFile",
    config = true,
    -- stylua: ignore
    keys = {
      { ">t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "<t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "css",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "toml",
        "rust",
        "dockerfile",
        "gitignore",
        "vue",
        "jq",
        "scheme",
        "go",
        "commonlisp",
      },
    },
  },

  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
    end,
  },

  -- the opts function can also be used to change the default opts:
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, "😄")
    end,
  },

  -- or you can return new options to override all the defaults
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        --[[add your custom lualine config here]]
      }
    end,
  },

  -- use mini.starter instead of alpha
  { import = "lazyvim.plugins.extras.ui.mini-starter" },

  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },

  -- {
  --   "jay-babu/mason-nvim-dap.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "python" })
  --     if not opts.handlers then
  --       opts.handlers = {}
  --     end
  --     opts.handlers.python = function() end -- make sure python doesn't get set up by mason-nvim-dap, it's being set up by nvim-dap-python
  --   end,
  -- },
  -- {
  --   "WhoIsSethDaniel/mason-tool-installer.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.ensure_installed =
  --       require("astrocore").list_insert_unique(opts.ensure_installed, { "pyright", "black", "isort", "debugpy" })
  --   end,
  -- },
  -- {
  --   "mfussenegger/nvim-dap-python",
  --   dependencies = "mfussenegger/nvim-dap",
  --   ft = "python", -- NOTE: ft: lazy-load on filetype
  --   config = function(_, opts)
  --     local path = require("mason-registry").get_package("debugpy"):get_install_path()
  --     if vim.fn.has("win32") == 1 then
  --       path = path .. "/venv/Scripts/python"
  --     else
  --       path = path .. "/venv/bin/python"
  --     end
  --     require("dap-python").setup(path, opts)
  --   end,
  -- },
  -- {
  --   "nvim-neotest/neotest",
  --   optional = true,
  --   dependencies = { "nvim-neotest/neotest-python" },
  --   opts = function(_, opts)
  --     if not opts.adapters then
  --       opts.adapters = {}
  --     end
  --     table.insert(opts.adapters, require("neotest-python")(require("astrocore").plugin_opts("neotest-python")))
  --   end,
  -- },
  -- {
  --   "stevearc/conform.nvim",
  --   optional = true,
  --   opts = {
  --     formatters_by_ft = {
  --       python = { "isort", "black" },
  --     },
  --   },
  -- },

  -- dap
  {
    "mfussenegger/nvim-dap",
    opts = {
      -- adapters = {
      --   python = {
      --     type = "executable",
      --     command = "C:\\Users\\tony5\\AppData\\Local\\Programs\\Python\\Python312\\python.exe",
      --     args = { "-m", "debugpy.adapter" },
      --   },
      -- },
    },
    config = function(_, opts)
      -- require("dap-python").setup(path, opts)
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function(_, opts)
      require("dap-python").setup(
        "D:\\projects\\Dotfiles\\nvimfiles\\python\\.virtualenvs\\debugpy\\Scripts\\python",
        opts
      )
    end,
  },
  {
    "folke/neodev.nvim",
    opts = {
      library = { plugins = { "nvim-dap-ui" }, types = true },
    },
  },

  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
}
