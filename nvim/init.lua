-- Основные настройки
vim.opt.number = true             -- отображать номера строк
vim.opt.relativenumber = true     -- относительные номера
vim.opt.tabstop = 4               -- ширина таба
vim.opt.shiftwidth = 4            -- отступ
vim.opt.expandtab = true          -- пробелы вместо табов
vim.opt.smartindent = true        -- умный отступ
vim.opt.wrap = false              -- отключаем перенос строк
vim.opt.termguicolors = true      -- 24-бит цвет
vim.opt.cursorline = true         -- подсветка текущей строки

-- Цвета
vim.api.nvim_set_hl(0, "Normal", { fg = "#cc0fa0" })          -- основной текст чуть темнее розового
vim.api.nvim_set_hl(0, "LineNr", { fg = "#ff15b7" })          -- номера строк
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ff15b7" })    -- номер текущей строки
vim.api.nvim_set_hl(0, "Comment", { fg = "#ff15b7", italic = true })  -- комментарии
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1e1e2e" })      -- тёмный фон текущей строки

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Lazy.nvim плагины
require("lazy").setup({
    {
    "brenoprata10/nvim-highlight-colors",
    config = function()
    require("nvim-highlight-colors").setup{
            render = "virtual",            -- рисует маленький квадратик сбоку
            enable_named_colors = true,    -- включает поддержку "red", "blue" и т.п.
            enable_hex = true,             -- включить #RRGGBB и #RGB
            enable_rgb = true,             -- включить rgb()
            enable_hsl = true,             -- включить hsl()
            enable_var_usage = true,       -- подсветка цветов, объявленных как CSS-переменные
            blacklist = {},                -- никаких исключенийnable_tailwind = true,        -- если работаешь с TailwindCSS
            enable_tailwind = true,        -- tailwind цвета
            }
    end,

    },
        -- Тема с кастомным фоном
    {
        "goolord/alpha-nvim",
        config = function()
            local alpha = require'alpha'
            local dashboard = require'alpha.themes.dashboard'


        -- 🔹 функция чтения ascii файла построчно
        local function read_ascii(path)
            local ascii = {}
            local f = io.open(path, "r")
            if f then
                for line in f:lines() do
                    table.insert(ascii, line)
                end
                    f:close()
            end
                    return ascii
            end

                -- 🔸 путь к ascii файлу
            local ascii_path = vim.fn.stdpath("config") .. "/ascii/sewerslvt.txt"
            local header_art = read_ascii(ascii_path)

                -- 🔸 добавляем твой “Welcome to Neovim!” под арт
            table.insert(header_art, "")
            table.insert(header_art, "Welcome to Neovim!")
            table.insert(header_art, "==================")

                -- назначаем результат как header
            dashboard.section.header.val = header_art

            local Job = require("plenary.job")
            local pickers = require("telescope.pickers")
            local finders = require("telescope.finders")
            local conf = require("telescope.config").values

            function _G.find_text_files()
                Job:new({
                    command = "fd",
                    args = { "-t", "f" },
                    on_exit = vim.schedule_wrap(function(j)
                        local t = {}
                        for _, f in ipairs(j:result()) do
                            local ok, h = pcall(io.open, f, "rb")
                            if ok and h then
                                local d = h:read(256)
                                h:close()
                                if d and not d:find("\0") then table.insert(t, f) end
                            end
                        end

                        pickers.new({}, {
                            prompt_title = "Text Files",
                            finder = finders.new_table { results = t },
                            sorter = conf.generic_sorter({})
                        }):find()
                    end)
                }):start()
            end


            dashboard.section.buttons.val = {
                dashboard.button("f", "  Find text files", ":lua find_text_files()<CR>"),
                dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
                dashboard.button("c", "  Config", ":e $MYVIMRC<CR>"),
                dashboard.button("q", "  Quit", ":qa<CR>"),
            }

            alpha.setup(dashboard.opts)
        end
    },

     -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require('telescope').setup{
                defaults = {
                    file_ignore_patterns = {"node_modules", ".git"},
                    prompt_prefix = "🔍 ",
                }
            }
        end
    },

    {
        "morhetz/gruvbox",
        config = function()
            vim.cmd("colorscheme gruvbox")
            vim.cmd("hi Normal guibg=#3a0024")  -- фиолетовый фон
        end
    },

    -- Статуслайн
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require('lualine').setup{
                options = { theme = 'gruvbox' }
            }
        end
    },

    -- Файловый менеджер
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("nvim-tree").setup{}
        end
    },

    -- LSP
    { "neovim/nvim-lspconfig" },

    -- Автодополнение
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
})

-- Keymaps
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>w', ':w<CR>')

-- Автодополнение (минимальный пример)
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      -- Можно подключить LuaSnip позже
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  })
})


