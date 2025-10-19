local map = vim.keymap.set

-- Vim keymap
map({ "n"},  "<C-j>", ":m.+1<cr>==", { desc = "Move Line DOWN in normal mode"})
map({ "n"},  "<C-k>", ":m.-2<cr>==", { desc = "Move Line UP in normal mode"})
map({ "i"},  "<C-j>", "<Esc> :m.+1<cr>==", { desc = "Move Line DOWN in normal mode"})
map({ "i"},  "<C-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move Line UP in normal mode"})
map({ "v"},  "<C-j>", "<Esc>:m '>+1<CR>gv=gv", { desc = "Move Line DOWN in normal mode"})
map({ "v"},  "<C-k>", "<Esc>:m '>-2<CR>gv=gv", { desc = "Move Line UP in normal mode"})
map({ "i"},  "jj", "<Esc>", { noremap = true, silent=true, desc = "Escape when jj pressed in insert mode"})
map({ "n"},  "<leader>a", ":e#<CR>", { noremap = true, silent=true, desc = "Alternate files"})
map({ "n"},  "<leader>e", ":Explore<CR>", { noremap = true, silent=true, desc = "Explore netrw"})
map({ "t"},  "<Esc>", "<C-\\><C-n>", { noremap = true, silent=true, desc = "Escape insert in terminal mode"})



-- Easily split windows
vim.keymap.set("n", "<leader>wv", ":vsplit<cr>", { desc = "[W]indow Split [V]ertical" })
vim.keymap.set("n", "<leader>wh", ":split<cr>", { desc = "[W]indow Split [H]orizontal" })


-- Remove search highlights after searching
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Remove search highlights" })



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
