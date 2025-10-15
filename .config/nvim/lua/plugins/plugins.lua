-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
-- if true then return {} end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
    -- Install for fuzzy searches across vim , files and git.
    {
        "ibhagwan/fzf-lua",
        dependencies = { 'junegunn/fzf' },
        opts = function()


        end,

        config = function()
            local map = vim.keymap.set
            local opts = { noremap = true, silent = true }

            -- FzfLua keymaps in normal and ex mode
            map({ "n", "x" },   "<leader>ff",  "<cmd>FzfLua files<cr>",           opts)
            map({ "n", "x" },   "<leader>fs",  "<cmd>FzfLua live_grep<cr>",       opts)
            map({ "n", "x" },   "<leader>fb",  "<cmd>FzfLua buffers<cr>",         opts)
            map({ "n", "x" },   "<leader>fa",  "<cmd>FzfLua args<cr>",            opts)
            map({ "n", "x" },   "<leader>fm",  "<cmd>FzfLua manpages<cr>",        opts)
            map({ "n", "x" },   "<leader>fcc", "<cmd>FzfLua command_history<cr>", opts)
            map({ "n", "x" },   "<leader>fff", "<cmd>FzfLua oldfiles<cr>",        opts)
            map({ "n", "x" },   "<leader>fgf", "<cmd>FzfLua git_files<cr>",       opts)
            map({ "n", "x" },   "<leader>fgs", "<cmd>FzfLua git_status<cr>",      opts)
            map({ "n", "x" },   "<leader>fgc", "<cmd>FzfLua git_commits<cr>",     opts)
            map({ "n", "x" },   "<leader>fgb", "<cmd>FzfLua git_branches<cr>",    opts)

        end
    },

    {
        --Require for highlight yank text
        'machakann/vim-highlightedyank',
    },
    {
        --Require for Git 
        'tpope/vim-fugitive',
    },

    {
        --Require for improved nvim statusline
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local config_ = require('lualine')
            config_.setup({
                icons_enabled = true,
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff', 'diagnostics'},
                    lualine_c = {'filename'},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'}
                }
            })
        end
    },


    -- add more treesitter parsers
    -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
    -- would overwrite `ensure_installed` with the new value.
    -- If you'd rather extend the default config, use the code below instead:
    {
        "nvim-treesitter/nvim-treesitter",
        run = ':TSUpdate',
        config = function ()
            local configs = require("nvim-treesitter.configs")

            local ensure_installed = vim.list_extend(configs.get_ensure_installed_parsers(), {
                "bash",
                "html",
                "javascript",
                "java",
                "go",
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
            })

            configs.setup({
                ensure_installed = ensure_installed,
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },


    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.config
        opts = {
            bigfile = { enabled = true },
            dashboard = { enabled = false },
            explorer = { enabled = false },
            indent = { enabled = true },
            input = { enabled = true },
            notifier = {
                enabled = true,
                timeout = 3000,
            },
            picker = { enabled = false },
            quickfile = { enabled = false },
            scope = { enabled = true },
            scroll = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
            styles = {
                notification = {
                    -- wo = { wrap = true } -- wrap notifications
                }
            }
        },
        init = function()
            vim.api.nvim_create_autocmd("user", {
                pattern = "verylazy",
                callback = function()
                    -- setup some globals for debugging (lazy-loaded)
                    _g.dd = function(...)
                        snacks.debug.inspect(...)
                    end
                    _g.bt = function()
                        snacks.debug.backtrace()
                    end
                    vim.print = _g.dd -- override print to use snacks for `:=` command

                    -- Create some toggle mappings
                    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                    Snacks.toggle.diagnostics():map("<leader>ud")
                    Snacks.toggle.line_number():map("<leader>ul")
                    Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
                    Snacks.toggle.treesitter():map("<leader>uT")
                    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
                    Snacks.toggle.inlay_hints():map("<leader>uh")
                    Snacks.toggle.indent():map("<leader>ug")
                    Snacks.toggle.dim():map("<leader>uD")
                end,
            })
        end,
    },

    -- LSP config install lsp servers
    {
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

            -- Specific config for lua to include vim as global variable
            vim.lsp.config('jdtls',{
                flags = flags,
                on_attach = on_attach,
                settings = {
                    java = {
                        signatureHelp = { enabled = true },
                        completion = {
                            favoriteStaticMembers = {},
                            filteredTypes = {},
                        },
                        sources = {
                            organizeImports = {
                                starThreshold = 9999,
                                staticStarThreshold = 9999,
                            },
                        },
                        codeGeneration = {
                            toString = {
                                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                            },
                            useBlocks = true,
                        },
                        -- Fernflower configuration
                        decompiler = {
                            enabled = true,          -- Enable the decompiler
                            javaDecompilerPath = "/usr/share/java/fernflower.jar", -- Path to Fernflower
                        },
                        configuration = {
                            runtimes = {
                                {
                                    name = "JavaSE-21",
                                    path = "/usr/lib/jvm/java-21-openjdk", -- Specify Custom Path Here should point to root of jdk 
                                },
                                {
                                    name = "JavaSE-25",
                                    path = "/usr/lib/jvm/java-25-openjdk",
                                    default = true,
                                },
                            },
                            libraries = {
                                -- Add the .m2 directory for Maven dependencies
                                os.getenv("HOME") .. "/.m2/repository",  -- Maven local repository path
                            },
                        },
                    },
                },
            })
            vim.lsp.enable('jdtls')
        end,
    },

    --    Blink for autocompletions
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },

        version = '1.*',
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = { preset = 'default' },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = { documentation = { auto_show = false } },
            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },

        opts_extend = { "sources.default" }
    }


}
