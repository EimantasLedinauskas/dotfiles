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


-- comments
table.insert(plugins, {
    'numToStr/Comment.nvim',
    config = function()
        require("Comment").setup()
    end,
})


-- autocompletion
table.insert(plugins, {
    'hrsh7th/nvim-cmp',
    dependencies = {
        -- snippet engine & its associated nvim-cmp source
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',

        -- cmp sources
        'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        require('luasnip.loaders.from_vscode').lazy_load()
        luasnip.config.setup {}

        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            completion = {
                completeopt = 'menu,menuone,noinsert'
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete {},
                ['<CR>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                },
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            },
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            },
        }
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
        pcall(require('telescope').load_extension, 'fzf')  -- Enable telescope fzf native, if installed

        vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles)
        vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers)
        vim.keymap.set('n', '<leader>fg', require('telescope.builtin').git_files)
        vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files)
        vim.keymap.set('n', '<leader>ss', require('telescope.builtin').current_buffer_fuzzy_find)
        vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags)
        vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep)
        vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics)
        vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume)
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

        -- mason-lspconfig requires these functions called in this order before setting up servers
        require('mason').setup()
        require('mason-lspconfig').setup()

        local servers = {
            pylsp = {},
            lua_ls = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                    diagnostics = { globals = {'vim'}, },  -- Get the language server to recognize the `vim` global
                },
            },
        }

        -- -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        -- Ensure the servers above are installed
        local mason_lspconfig = require 'mason-lspconfig'

        mason_lspconfig.setup {
            ensure_installed = vim.tbl_keys(servers),
        }

        mason_lspconfig.setup_handlers {
            function(server_name)
                require('lspconfig')[server_name].setup {
                    capabilities = capabilities,
                    on_attach = on_attach,
                    settings = servers[server_name],
                    filetypes = (servers[server_name] or {}).filetypes,
                }
            end,
        }
    end,
})


-- setup the plugins
require("lazy").setup(plugins, lazy_opts)
