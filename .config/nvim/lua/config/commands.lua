
-- source all vim commands i'm yet to convert
local vimscript_cmds = vim.fn.stdpath('config') ..'/vim/commands.vim'

vim.cmd('source ' .. vimscript_cmds) -- For init.lua

vim.api.nvim_create_user_command(
    'AsynToTab',
    function (opts)
       vim.fn.OutputToTab(opts.args)
    end,
    {nargs = '*'}
)


-- Set the location list with prepared entries
---@param loclist table?
local function populateLocationList (loclist)
    vim.fn.setloclist(0, loclist, 'r')  -- 0 means current buffer  
    if (#loclist ~= 0) then
        vim.cmd("llist")
    end
end
-- Set the location list with prepared entries
---@param qlist table?
local function populateQuickfixList (qlist)
    vim.fn.setqflist({}, 'r')            -- Clear the quickfix list
    vim.fn.setqflist(qlist, 'r')            -- Set the quickfix list
    if #qlist ~= 0 then
        vim.cmd("copen")
    end
end
--  Get lsp diagnostics
vim.api.nvim_create_user_command(
    'GetLspDiagnostics',
    function (opts)
       local diagnostics = nil

        if opts.bang  then
            diagnostics = vim.diagnostic.get(); --then get diagnostics across all buffers and populate quickfix
            if #diagnostics == 0 then
                print("No diagnostics found.")
                return
            end
            local qlist = vim.diagnostic.toqflist(diagnostics)
            populateQuickfixList(qlist)
            --local qlist = {}
            --for _, diag in ipairs(diagnostics) do
                --print("Severity: " .. diag.severity .. " - " .. diag.message)
                --table.insert(qlist, {
                    --filename = vim.fn.expand('%:p'),       -- Full path of the current file
                    --lnum = diag.user_data.lsp.range.start.line + 1,      -- Line number (1-based)
                    --col = diag.user_data.lsp.range.start.character + 1,  -- Column number (1-based)
                    --text = diag.message,                   -- The diagnostic message
                    --type = diag.severity,                  -- Severity (can be mapped to your needs)
                --})
            --end
            --populateQuickfixList(qlist)
            return
        else
            --then get diagnostic for only current buffer and populater the location list
            diagnostics = vim.diagnostic.get(0);
            if #diagnostics == 0 then
                print("No diagnostics found.")
                return
            end
            -- Then get diagnostics across all buffers and populate quickfix
            -- Print diagnostic messages
            local loclist = {}
            for _, diag in ipairs(diagnostics) do
                print("Severity: " .. diag.severity .. " - " .. diag.message)
                table.insert(loclist, {
                    lnum = diag.lnum + 1,  -- Line number (1-based)
                    col = diag.col + 1,  -- Column number (1-based)
                    text = diag.message,  -- The diagnostic message
                    type = diag.severity, -- Severity (can be mapped to your needs)
                })
            end
            populateLocationList(loclist)
            return
        end

    end,
    {nargs = '*', bang = true}
)

 --
 --command! -nargs=+ AsynToTab call OutputToTab(<q-args>)
 -- Example usage:
 -- :AsynToTab MyTab ls
 -- :AsynToTab MyTab !ls -l
 -- :AsynToTab DebugTab echo &path
--
-- Function to get the last modified time of a file
local function get_last_modified_time(file_path)
    local stat = vim.loop.fs_stat(file_path)
    if stat then
        return os.date("%Y-%m-%d %H:%M:%S", stat.mtime.sec)
    else
        return "File not found"
    end
end

-- Soft Restart nvim some changes might need quiting and restarting nvim
vim.api.nvim_create_user_command(
  'Restart',
  function()
   -- Use vim.cmd to execute a command that reloads Neovim's configuration
        local conf_file_path = vim.fn.stdpath('config') ..'/init.lua'
        vim.print(conf_file_path .. ' last modified at ' .. get_last_modified_time(conf_file_path))
         local cmd = 'source '.. conf_file_path
         vim.cmd(cmd)
         vim.cmd('redraw')
  end,
  { nargs = '*'}
)
