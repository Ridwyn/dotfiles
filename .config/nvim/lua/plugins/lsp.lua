
return {
    {
    -- LSP config install lsp servers
        -- Require mason to setup formatters, linters, dap servers
        'williamboman/mason.nvim',
        config = function()
            local _config = require('mason')
            _config.setup({
                ensure_installed = {"prettier"} -- Specify tools (linters, formatters, DAP)
            })
        end,
    },
    {
        -- Require mason lsconfig to setup lsp servers
        'williamboman/mason-lspconfig.nvim',
        config = function()
            local _config = require('mason-lspconfig')

            local servers = { "pyright", "ts_ls",  "lua_ls", "clangd", "gopls", "jdtls" }
            _config.setup({
                ensure_installed = servers, -- LSPs to install
                automatic_installation = true, -- Automatically install missing servers
            })
        end,
    },

    -- mason nvim dap utilizes mason to automatically ensure debug adapters you want installed are installed, mason-lspconfig will not automatically install debug adapters for us
    {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
            -- ensure the java debug adapter is installed
            require("mason-nvim-dap").setup({
                ensure_installed = { "java-debug-adapter", "java-test" }
            })
        end
    },
    -- utility plugin for configuring the java language server for us
    {
        "mfussenegger/nvim-jdtls",
        dependencies = {
            "mfussenegger/nvim-dap",
        }
    },

    {
        -- Require to link vim lsp client to servers
        "neovim/nvim-lspconfig",
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
        config = function ()

            local servers = { "pyright", "ts_ls",  "lua_ls", "clangd", "gopls", "jdtls" }
            local function on_attach(client, bufnr)
                -- Key mappings for LSP functions
                local opts = { noremap=true, silent=true }
                vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>',     opts)
                vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>',    opts)
                vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
                vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>',     opts)
                vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',  '<Cmd>lua vim.lsp.buf.hover()<CR>',           opts)

                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(bufnr, "Format",
                    function(_)
                        vim.lsp.buf.format()
                    end,
                    { desc = "Format current buffer with LSP" })
            end

            local flags = {
                debounce_text_changes = 150,
            }

            -- Function to config all LSP servers in server list and enable to start them
            for _, lsp in ipairs(servers) do
                vim.lsp.config(lsp, {
                    flags = flags,
                    on_attach = on_attach,

                })
                vim.lsp.enable(lsp)
            end

            vim.lsp.config('lua_ls',{
                flags = flags,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT', -- or the appropriate Lua version
                        },
                        diagnostics = {
                            globals = {'vim'},  -- Declare 'vim' as a global
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true), -- Add runtime files in your setup
                        },
                    },
                },
            })
            vim.lsp.enable('lua_ls')

            --vim.lsp.config('jdtls', require('plugins.jdtls').config_)
            vim.lsp.enable('jdtls')
            ---- Specific config for lua to include vim as global variable
            --vim.lsp.config('jdtls',{
                --flags = flags,
                --on_attach = on_attach,
                --settings = {
                    --java = {
                        --signatureHelp = { enabled = true },
                        --completion = {
                            --favoriteStaticMembers = {},
                            --filteredTypes = {},
                        --},
                        --sources = {
                            --organizeImports = {
                                --starThreshold = 9999,
                                --staticStarThreshold = 9999,
                            --},
                        --},
                        --codeGeneration = {
                            --toString = {
                                --template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                            --},
                            --useBlocks = true,
                        --},
                        ---- Fernflower configuration
                        --decompiler = {
                            --enabled = true,          -- Enable the decompiler
                            --javaDecompilerPath = "/usr/share/java/fernflower.jar", -- Path to Fernflower
                        --},
                        --configuration = {
                            --runtimes = {
                                --{
                                    --name = "JavaSE-21",
                                    --path = "/usr/lib/jvm/java-21-openjdk", -- Specify Custom Path Here should point to root of jdk 
                                --},
                                --{
                                    --name = "JavaSE-25",
                                    --path = "/usr/lib/jvm/java-25-openjdk",
                                    --default = true,
                                --},
                            --},
                            --libraries = {
                                ---- Add the .m2 directory for Maven dependencies
                                --os.getenv("HOME") .. "/.m2/repository",  -- Maven local repository path
                            --},
                        --},
                    --},
                --},
            --})
            --vim.lsp.enable('jdtls')
        end,
    },

}
