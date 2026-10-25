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



--Scract command  
vim.api.nvim_create_user_command("Scratch", function(cmd_args)
  local name = "Scratch"
  if cmd_args.args ~= nil then
    name = cmd_args.args[0]
  end
	local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(buf, "Scratch")
	vim.cmd("split | b" .. buf )

end, { nargs = "*" })


local function strip_ansi(str)
	-- Matches the ESC character (\27 or \x1b) followed by standard ANSI control sequences
	return str:gsub("\27%[%d+;?%d*m", ""):gsub("\27%[[%d;]*[A-Za-z]", "")
end

local function create_terminal_and_sendcmd(cmd, isMakeCmd)
	local buf = vim.api.nvim_create_buf(true, false)
	-- vim.cmd("split | b" .. buf .. " | terminal")
	-- vim.fn.chansend(vim.b[buf].terminal_job_id, cmd .. "\n")

	local tempfile = vim.fn.tempname()
	local fullcmd = cmd .. " 2&>1 | tee  " .. tempfile
	vim.cmd("split | b" .. buf)
	vim.fn.jobstart(fullcmd, {
		term = true,
		on_exit = function()
			-- set quickfix if :Make is MAKE
			if isMakeCmd then
				print(fullcmd)
				vim.schedule(function()
					local lines = vim.fn.readfile(tempfile)
					local qflist = {}
					for _, line in ipairs(lines) do
						local l = strip_ansi(line)
						table.insert(qflist, { text = l })
					end
					-- Populate the quickfix list
					vim.fn.setqflist(qflist)

					-- Open the quickfix window automatically if items were added
					if #qflist > 0 then
						vim.cmd("copen")
					end
				end)
			end
		end,
	})
end

--Make command to 
vim.api.nvim_create_user_command("Make", function(cmd_args)
	-- 1. Get the configured makeprg (defaults to buffer-local, falls back to global)
	local makeprg = vim.bo.makeprg
	if makeprg == "" then
		makeprg = vim.o.makeprg
	end
	create_terminal_and_sendcmd(makeprg .. cmd_args.args, true)
end, { nargs = "*" })

--Term command cleaner way to :sp | term
vim.api.nvim_create_user_command("Term", function(cmd_args)
	local args = vim.trim(cmd_args.args)

	local cmd = args
	if args:sub(1, 1) == "'" then
		if args:sub(args:len()) ~= "'" then
			vim.cmd('echohl ErrorMsg | echo " mising closing \'" | echohl None')
			return
		else
			-- this is safe todo since ' is exactly 1 byte so we can safely chop 1 byte on both ends
			local cleancmd = args:sub(2, -2)
			create_terminal_and_sendcmd(cleancmd)
			return
		end
	end
	create_terminal_and_sendcmd(cmd)
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
		local whitelist_buf = { "terminal" }
		local foundInWhitelist = vim.fn.index(whitelist_buf, buf.buftype)
		local filePath = vim.fn.fnamemodify(buf.name, ":p")
		local isOndisk = vim.uv.fs_stat(filePath)
		if not isOndisk and foundInWhitelist == -1 then
			vim.cmd.bwipe({ buf.name, bang = true })
			print("Wiped ==>> " .. buf.name)
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
