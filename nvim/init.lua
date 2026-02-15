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

vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#ff15b7", bg = "#1d0121" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#ff15b7", bg = "#1d0121" })


-- Цвета
--vim.api.nvim_set_hl(0, "Normal", { fg = "#cc0fa0" })          -- основной текст чуть темнее розового
--vim.api.nvim_set_hl(0, "LineNr", { fg = "#ff15b7" })          -- номера строк
--vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ff15b7" })    -- номер текущей строки
--vim.api.nvim_set_hl(0, "Comment", { fg = "#ff15b7", italic = true })  -- комментарии
--vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1e1e2e" })      -- тёмный фон текущей строки
vim.opt.swapfile = false
vim.opt.clipboard = "unnamedplus"


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

            local pickers = require("telescope.pickers")
            local finders = require("telescope.finders")
            local conf = require("telescope.config").values
            local telescope_builtin = require("telescope.builtin")

            -- Глобальный вызов: _G.find_text_files()
            function _G.find_text_files()
                telescope_builtin.find_files({
                    prompt_title = "Text Files Only",
                    hidden = true,  -- включает скрытые файлы
                    file_ignore_patterns = {
                        -- изображения
                        "%.png$", "%.jpg$", "%.jpeg$", "%.gif$", "%.bmp$", "%.webp$", "%.tiff$", "%.ico$",
                        -- видео
                        "%.mp4$", "%.mkv$", "%.avi$", "%.mov$", "%.flv$", "%.wmv$", "%.webm$",
                        -- аудио
                        "%.mp3$", "%.wav$", "%.flac$", "%.ogg$", "%.aac$", "%.m4a$",
                        -- архивы и образы
                        "%.zip$", "%.tar$", "%.gz$", "%.7z$", "%.rar$", "%.iso$", "%.dmg$", "%.pkg$",
                        -- исполняемые и бинарные
                        "%.exe$", "%.dll$", "%.so$", "%.o$", "%.class$", "%.pyc$",
                        -- шрифты
                        "%.ttf$", "%.otf$", "%.woff$", "%.woff2$",
                        -- базы данных и другие крупные бинарные
                        "%.db$", "%.sqlite$", "%.pak$",
                        -- системные папки
                        "node_modules", ".git", "vendor",
                        "%.zst$", "%.tmp$"
                    }
                })
            end
            
            -- 📝 функция: меню создания нового файла
            function _G.create_new_file()
                vim.ui.input({ prompt = "Название файла: " }, function(filename)
                    if filename and filename ~= "" then
                        vim.cmd("e " .. filename)          -- создаёт и открывает файл
                    else
                        print("Отменено")
                    end
                end)
            end
            
            dashboard.section.buttons.val = {
                dashboard.button("f", "  Find text files", ":lua find_text_files()<CR>"),
                dashboard.button("n", "  New File", ":lua create_new_file()<CR>"),
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
        "olimorris/onedarkpro.nvim",
        priority = 1000, -- Ensure it loads first
        config = function()
            require("onedarkpro").setup({
                colors = {
                    dark = { bg = "#1d0121" },
                    onedark = { bg = "#1d0121" },
                }
            })
            vim.cmd("colorscheme onedark_dark")
        end
    },
     
    -- Статуслайн
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require('lualine').setup{
                options = { theme = 'onedark_dark' }
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

    {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
        input = {
                enabled = true,
                insert_only = false,
                win_options = {
                    winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
                },
                border = "rounded",
            },
            select = {
                enabled = true,
                backend = { "builtin" },
                builtin = {
                    border = "rounded",
                    borderchars = { "│", "│", "─", "─", "╭", "╮", "╰", "╯" },
                    min_width = { 50, 0.4 },
                    max_width = { 80, 0.8 },
                    win_options = {
                        winblend = 10,
                        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
                    },
                },
            },
        },
    },

    {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
        cmdline = {
            enabled = true,
                view = "cmdline_popup",
                opts = {
                    position = { row = "50%", col = "50%" },
                    size = { width = 60 },
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                        chars = { "│", "│", "─", "─", "╭", "╮", "╰", "╯" },
                    },
                    win_options = {
                        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
                    },
                },
            },
            popupmenu = {
                enabled = true,
                backend = "nui",
                win_options = {
                    winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
                },
            },
            presets = {
                bottom_search = false,    -- поиск внизу отключен
                command_palette = true,   -- палитра команд
            },
        },
    },
})
local alpha = require'alpha'

-- 🩶 Меню "Сохранить и выйти" через dressing.nvim
vim.api.nvim_create_user_command("A", function()
    local opts = { prompt = "Выбери действие:" }
    local actions = {
        "Сохранить и открыть Alpha",
        "Сохранить и выйти",
        "Выйти в Alpha",
        "Сохранить",
        "Выйти",
        "Отмена",
    }

    vim.ui.select(actions, opts, function(choice)
        if choice == "Сохранить и открыть Alpha" then
            vim.cmd("w")  -- сохранить файл
            vim.cmd("Alpha")
        elseif choice == "Сохранить и выйти" then
            vim.cmd("wq")  -- сохранить и выйти
        elseif choice == "Выйти в Alpha" then
            vim.cmd("Alpha")
        elseif choise == "Сохранить" then
            vim.cmd("w")
        elseif choice == "Выйти" then
            vim.cmd("q")
        else
            print("Отменено")
        end
    end)
end, { desc = "Меню: Сохранить / Выйти / Alpha" })

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

vim.keymap.set('n', '<leader><Tab>', ':A<CR>', { noremap = true, silent = true })
