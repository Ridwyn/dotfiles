-- source all vim commands i'm yet to convert
local vimscript_cmds = vim.fn.stdpath("config") .. "/vim/commands.vim"

vim.cmd("source " .. vimscript_cmds) -- For init.lua

vim.api.nvim_create_user_command("AsynToTab", function(opts)
	vim.fn.OutputToTab(opts.args)
end, { nargs = "*" })

--Open lsp log file
vim.api.nvim_create_user_command("LspLog", function(_)
	vim.cmd("e " .. vim.lsp.log.get_filename())
end, { nargs = "*" })


--Wipe buffer not backed by file on disk
vim.api.nvim_create_user_command("CleanBuffers", function(_)
	local buffers = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		-- Only include buffers that are listed and loaded
		if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
			table.insert(buffers, {
				bufnr = bufnr,
				buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr }),
				name = vim.api.nvim_buf_get_name(bufnr),
				changed = vim.bo[bufnr].modified,
			})
		end
	end

  for _, buf in ipairs(buffers) do
    -- Whitelist of buftypes to avoid wiping
    local whitelist_buf = {"terminal"}
    local foundInWhitelist = vim.fn.index(whitelist_buf, buf.buftype)
    local filePath = vim.fn.fnamemodify(buf.name, ":p")
    local isOndisk = vim.uv.fs_stat(filePath)
    if not isOndisk and foundInWhitelist == -1  then
      vim.cmd.bwipe({buf.name, bang = true})
      print("Wiped ==>> ".. buf.name)
    end
  end

end, { nargs = "*" })

--  Get lsp diagnostics
vim.api.nvim_create_user_command("GetLspDiagnostics", function(opts)
	if opts.bang then
		vim.diagnostic.setloclist()
	else
		vim.diagnostic.setqflist()
	end
end, { nargs = "*", bang = true })

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
vim.api.nvim_create_user_command("Restart", function()
	-- Use vim.cmd to execute a command that reloads Neovim's configuration
	local conf_file_path = vim.fn.stdpath("config") .. "/init.lua"
	vim.print(conf_file_path .. " last modified at " .. get_last_modified_time(conf_file_path))
	local cmd = "source " .. conf_file_path
	vim.cmd(cmd)
	vim.cmd("redraw")
end, { nargs = "*" })
