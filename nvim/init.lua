-- <space> as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.wo.number = true  -- enable line numbers
vim.o.mouse = 'a'  -- enable mouse mode
vim.o.undofile = true  -- save undo history
vim.o.completeopt = 'menuone,noselect'  -- better completion experience
vim.o.termguicolors = true
vim.o.clipboard = 'unnamedplus'  -- sync with system clipboard
vim.o.pumheight = 10 -- Maximum number of entries in a popup
vim.o.cursorline = true
vim.o.scrolloff = 4
vim.o.sidescrolloff = 8
vim.o.showmatch = true  -- show matching brackets
vim.wo.relativenumber = true
vim.o.autowrite = true
vim.o.confirm = true -- confirm instead of failing when exiting modified buffer
vim.o.list = true -- explicitly show tabs and trailing whitespace
vim.o.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.o.wrap = false
vim.o.breakindent = true  -- wrapped lines respect indent

-- performance
vim.o.synmaxcol = 300  -- lowering this improves performance in files with long lines
vim.o.lazyredraw = true

-- indentation stuff
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.shiftround = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.smartindent = true

-- search improvements
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- disable auto comments
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  command = "checktime",
})

-- -- delete trailing whitespace on write
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   pattern = { "*" },
--   command = [[%s/\s\+$//e]],
-- })

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Swap and backup files
local swap_dir = vim.fn.expand('~/.local/share/nvim/swap//')
local backup_dir = vim.fn.expand('~/.local/share/nvim/backup//')

-- Ensure the directories exist
if vim.fn.isdirectory(swap_dir) == 0 then
  vim.fn.mkdir(swap_dir, 'p')
end

if vim.fn.isdirectory(backup_dir) == 0 then
  vim.fn.mkdir(backup_dir, 'p')
end

vim.opt.directory = swap_dir
vim.opt.backupdir = backup_dir
vim.opt.swapfile = true
vim.opt.backup = true


------------
-- KEYMAPS
------------

-- disable space in normal and visual
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- switch CWD to the directory of the open buffer
vim.keymap.set("n", "<Leader>cd", ":cd %:p:h<CR>:pwd<CR>")

-- show path of the open buffer
vim.keymap.set('n', "<Leader>cp", ':echo expand("%:p")<CR>')

-- resize panes with arrows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

-- maintain selection after visual indent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- move text up and down with alt
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
vim.keymap.set("v", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("v", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv")
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv")

-- delete without putting to register
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- center view after jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-o>", "<C-o>zz")
vim.keymap.set("n", "<C-i>", "<C-i>zz")

-- keep cursor in place after joining
vim.keymap.set("n", "J", "mzJ`z")

-- buffer prev / next
vim.keymap.set("n", "<Leader>bp", ":bprevious<CR>")
vim.keymap.set("n", "<Leader>bn", ":bnext<CR>")

-- delete buffer but keep split open
vim.keymap.set("n", "<Leader>bd", "<CMD>bp | sp | bn | bd<CR>")

-- clear search highlight with <esc>
vim.keymap.set("n", "<esc>", ":noh<cr><esc>")

-- add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- save file with <ctrl-S>
vim.keymap.set({ "n" }, "<C-s>", "<Cmd>silent! update<CR>")
vim.keymap.set({ 'i', 'x' }, '<C-S>', '<Esc><Cmd>silent! update<CR>')

-- reselect latest changed, put, or yanked text
vim.keymap.set('n', 'gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"')

-- search inside visually highlighted text (`silent = false` for it to make effect immediately)
vim.keymap.set('x', 'g/', '<esc>/\\%V', { silent = false })


-------------
-- PLUGINS --
-------------

-- use `nvim --cmd "lua vim.g.disable_plugins=true"` to start without plugins
if (vim.fn.exists("g:disable_plugins") == 0 and vim.fn.exists("g:vscode") == 0) then
    vim.wo.signcolumn = 'yes'  -- enable sign column only when plugins are used
    require("plugins")
end
