local map = vim.keymap.set

-- Vim keymap
map({ "n"},  "<C-j>", ":m.+1<cr>==", { desc = "Move Line DOWN in normal mode"})
map({ "n"},  "<C-k>", ":m.-2<cr>==", { desc = "Move Line UP in normal mode"})
map({ "i"},  "<C-j>", "<Esc> :m.+1<cr>==", { desc = "Move Line DOWN in normal mode"})
map({ "i"},  "<C-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move Line UP in normal mode"})
map({ "v"},  "<C-j>", "<Esc>:m '>+1<CR>gv=gv", { desc = "Move Line DOWN in normal mode"})
map({ "v"},  "<C-k>", "<Esc>:m '>-2<CR>gv=gv", { desc = "Move Line UP in normal mode"})
map({ "i"},  "jj", "<Esc>", { noremap = true, silent=true, desc = "Escape when jj pressed in insert mode"})
map({ "n"},  "<leader>e", ":e#<CR>", { noremap = true, silent=true, desc = "Alternate files"})




function OpenUrlUnderCursor()
  local url = vim.fn.expand("<cfile>")
    print(url)
    print('Protocol', string.match(url, "^([a-z]*[:][//])"))
    if string.match(url, "^([a-z]*[:][//])") then
        vim.system({'xdg-open', url}, { text = true }) -- xdg for linux
    else
        print("No valid URL under cursor")
    end
end

vim.api.nvim_set_keymap('n', '<leader>o', ':lua OpenUrlUnderCursor()<CR>', { noremap = true, silent = true })

-- Netrw show marked files list
--map({ "n" },   "<leader>m", ":echo netrw#Expose("netrwmarkfilelist")<CR>", { desc = "Netrw list bookmarked files"})
