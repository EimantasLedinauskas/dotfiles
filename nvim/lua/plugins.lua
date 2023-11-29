-- bootstrap plugin manager (https://github.com/folke/lazy.nvim)
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

-- plugin manager options
local lazy_opts = {}

-- plugin spec
local plugins = {}


-- theme
table.insert(plugins, {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    config = function()
        vim.cmd.colorscheme 'carbonfox'
    end,
})


-- comments
table.insert(plugins, {
    'numToStr/Comment.nvim',
    config = function()
        require("Comment").setup()
    end,
})


-- autocompletion
table.insert(plugins, {
    'echasnovski/mini.completion',
    version = false,
    config = function()
        require("mini.completion").setup()
    end,
})

-- fuzzy finder telescope
table.insert(plugins, {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
    },
    config = function()
        pcall(require('telescope').load_extension, 'fzf') -- Enable telescope fzf native, if installed

        local builtin = require('telescope.builtin')
        local utils = require('telescope.utils')

        vim.keymap.set('n', '<leader>?', builtin.oldfiles)
        vim.keymap.set('n', '<leader><space>', builtin.buffers)
        vim.keymap.set('n', '<leader>fg', builtin.git_files)
        vim.keymap.set('n', '<leader>ff', function() builtin.find_files({ cwd = utils.buffer_dir() }) end )
        vim.keymap.set('n', '<leader>fF', builtin.find_files)
        vim.keymap.set('n', '<leader>ss', builtin.current_buffer_fuzzy_find)
        vim.keymap.set('n', '<leader>sh', builtin.help_tags)
        vim.keymap.set('n', '<leader>sg', function() builtin.live_grep({ cwd = utils.buffer_dir() }) end )
        vim.keymap.set('n', '<leader>sG', builtin.live_grep)
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics)
        vim.keymap.set('n', '<leader>sr', builtin.resume)
    end,
})


-- LSP
table.insert(plugins, {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
    },
    config = function()
        --  This function gets run when an LSP connects to a particular buffer.
        local on_attach = function(_, bufnr)
            local nmap = function(keys, func)
                vim.keymap.set('n', keys, func, { buffer = bufnr })
            end

            nmap('<leader>rn', vim.lsp.buf.rename)
            nmap('<leader>ca', vim.lsp.buf.code_action)

            nmap('gd', require('telescope.builtin').lsp_definitions)
            nmap('gr', require('telescope.builtin').lsp_references)
            nmap('gI', require('telescope.builtin').lsp_implementations)

            nmap('K', vim.lsp.buf.hover)
            nmap('<C-k>', vim.lsp.buf.signature_help)

            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                vim.lsp.buf.format()
            end, { desc = 'Format current buffer with LSP' })
        end

        -- Ensure the servers above are installed
        -- mason-lspconfig requires these functions called in this order before setting up servers
        require('mason').setup()
        require('mason-lspconfig').setup()

        local servers = {
            pylsp = {},
            -- pyright = {},
            lua_ls = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                    diagnostics = { globals = { 'vim' }, }, -- Get the language server to recognize the `vim` global
                },
            },
        }

        require('mason-lspconfig').setup {
            ensure_installed = vim.tbl_keys(servers),
        }

        require('mason-lspconfig').setup_handlers {
            function(server_name)
                require('lspconfig')[server_name].setup {
                    on_attach = on_attach,
                    settings = servers[server_name],
                    filetypes = (servers[server_name] or {}).filetypes,
                }
            end,
        }
    end,
})


-- treesitter
table.insert(plugins, {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
        -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
        vim.defer_fn(function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { 'cpp', 'python', 'lua', 'vimdoc', 'vim', 'bash' },
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<c-space>',
                        node_incremental = '<c-space>',
                        -- scope_incremental = '<c-s>',
                        node_decremental = '<M-space>',
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ['aa'] = '@parameter.outer',
                            ['ia'] = '@parameter.inner',
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner',
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ['<leader>a'] = '@parameter.inner',
                        },
                    },
                },
            }
        end, 0)
    end,
})

-- file manager
table.insert(plugins, {
    'stevearc/oil.nvim',
    config = function()
        vim.keymap.set("n", "-", "<CMD>Oil<CR>")
        require("oil").setup({
            columns = {"icon", "permissions", "size", "mtime"},
            delete_to_trash = true,
        })
    end,
})

-- setup the plugins
require("lazy").setup(plugins, lazy_opts)
