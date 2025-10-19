return {
        -- add more treesitter parsers
        -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
        -- would overwrite `ensure_installed` with the new value.
        -- If you'd rather extend the default config, use the code below instead:
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
}


