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

-- LSP
table.insert(plugins, {
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Automatically install LSPs to stdpath for neovim
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

            -- nmap('gd', require('telescope.builtin').lsp_definitions)
            -- nmap('gr', require('telescope.builtin').lsp_references)
            -- nmap('gI', require('telescope.builtin').lsp_implementations)
            -- nmap('<leader>D', require('telescope.builtin').lsp_type_definitions)
            -- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols)
            -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols)

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
        -- local capabilities = vim.lsp.protocol.make_client_capabilities()
        -- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        -- Ensure the servers above are installed
        local mason_lspconfig = require 'mason-lspconfig'

        mason_lspconfig.setup {
            ensure_installed = vim.tbl_keys(servers),
        }

        mason_lspconfig.setup_handlers {
            function(server_name)
                require('lspconfig')[server_name].setup {
                    -- capabilities = capabilities,
                    on_attach = on_attach,
                    settings = servers[server_name],
                    filetypes = (servers[server_name] or {}).filetypes,
                }
            end,
        }
    end,
})


require("lazy").setup(plugins, lazy_opts)
