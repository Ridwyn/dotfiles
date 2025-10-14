vim.g.mapleader = " "

local opt = vim.o

opt.cursorline = true
opt.history = 200
opt.number = true
opt.relativenumber = true
opt.scrolloff = 13
opt.wildmenu = true
opt.tabstop = 4 
opt.shiftwidth = 4
opt.ignorecase = true
opt.incsearch = true
opt.hlsearch = true
opt.smartcase = true
opt.clipboard = 'unnamedplus'

opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs

opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.termguicolors = true -- True color support
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.wrap = false -- Disable line wrap

-- Set the colorscheme
vim.cmd('colorscheme habamax')

