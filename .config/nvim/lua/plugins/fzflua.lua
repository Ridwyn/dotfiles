
return {
    -- Install for fuzzy searches across vim , files and git.

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
        map({ "n", "x" },   "<leader>f.", "<cmd>FzfLua oldfiles<cr>",        opts)
        map({ "n", "x" },   "<leader>fgf", "<cmd>FzfLua git_files<cr>",       opts)
        map({ "n", "x" },   "<leader>fgs", "<cmd>FzfLua git_status<cr>",      opts)
        map({ "n", "x" },   "<leader>fgc", "<cmd>FzfLua git_commits<cr>",     opts)
        map({ "n", "x" },   "<leader>fgb", "<cmd>FzfLua git_branches<cr>",    opts)

        map({ "n" },   "<leader>gra", "<cmd>FzfLua lsp_code_actions<cr>",    opts)
        map({ "n", "x" },   "<leader>fd", "<cmd>FzfLua lsp_workspace_diagnostics<cr>",        opts)
    end
}
