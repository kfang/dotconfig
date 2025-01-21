vim.g.mapleader = ' '
vim.o.termguicolors = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "edeneast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        opts = {}
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        lazy = false,
        config = function ()
            require("telescope").setup({
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                    live_grep = {
                        additional_args = function()
                            return { "--hidden", "--glob", "!**/.git/*" }
                        end,
                    },
                    grep_string = {
                        additional_args = function()
                            return { "--hidden", "--glob", "!**/.git/*" }
                        end,
                    },
                },
            })
        end,
    },
    {
        "arkav/lualine-lsp-progress",
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function(_, opts)
            require("neo-tree").setup(opts)
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
        opts = {
            sections = {
                lualine_c = {
                    "lsp_progress",
                    { "filename", path = 4}
                },
            },
            tabline = {
                lualine_a = { "buffers" },
                lualine_b = { "branch" },
                lualine_c = {},
                lualine_x = {},
                lualine_y = { "filename" },
                lualine_z = { "tabs" },
            }
        },
        config = function(_, opts)
            vim.cmd("colorscheme nightfox")
            require("lualine").setup(opts)
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        lazy = false,
        config = function()
            local treesitter = require("nvim-treesitter.configs")

            treesitter.setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "go",
                    "javascript",
                    "jsdoc",
                    "json",
                    "json5",
                    "lua",
                    "python",
                    "rust",
                    "terraform",
                    "typescript",
                    "vim",
                    "query",
                    "yaml",
                    "python",
                },
                sync_install = true,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false
                }
            })

        end,
    },
    {
        "williamboman/mason.nvim",
        version = false,
        cmd = "Mason",
        build = ":MasonUpdate",
        lazy = false,
        config = function(_, opts)
            require("mason").setup(opts)
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        lazy = false,
        opts = {
            ensure_installed = {
                "denols",
                "eslint",
                "gopls",
                "jsonls",
                "lua_ls",
                "pyright",
                "rust_analyzer",
                "terraformls",
                "ts_ls",
            }
        },
        config = function(_, opts)
            require("mason-lspconfig").setup(opts)
        end
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "folke/neodev.nvim",
            "hrsh7th/nvim-cmp",
        },
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local nvim_lsp = require("lspconfig");

            nvim_lsp.denols.setup({ 
                capabilities,
                root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
            })
            require("lspconfig").eslint.setup({
                capabilities,
                on_attach = function(client, bufnr)
                    vim.api.nvim_create_autocmd("BufWritePre", { buffer = bufnr, command = "EslintFixAll" })
                end,
            });
            require("lspconfig").gopls.setup({ capabilities })
            require("lspconfig").jsonls.setup({ capabilities })
            require("lspconfig").lua_ls.setup({ capabilities })
            require("lspconfig").pyright.setup({ capabilities })
            require("lspconfig").rust_analyzer.setup({ capabilities })
            require("lspconfig").terraformls.setup({ capabilities })
            nvim_lsp.ts_ls.setup({ 
                capabilities,
                root_dir = nvim_lsp.util.root_pattern("package.json"),
                single_file_support = false,
            })
        end
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/cmp-cmdline",
        },
        lazy = false,
        config = function()
            local cmp = require("cmp")

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                }),
                preselect = "item",
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                }),
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            })
        end
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        config = function ()
            local ufo = require("ufo")

            vim.o.foldcolumn = "1"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            vim.keymap.set("n", "zR", ufo.openAllFolds)
            vim.keymap.set("n", "zM", ufo.closeAllFolds)

            ufo.setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { "treesitter", "indent" }
                end
            })
        end
    }
}, {
    install = {
        colorscheme = { "nightfox" }
    },
})


local wk = require("which-key")
local telescope = require("telescope.builtin")

wk.add({
    { "gd", vim.lsp.buf.definition, desc = "[g]oto [d]efinition" },
    { "gD", vim.lsp.buf.declaration, desc = "[g]oto [D]eclaration" },
    { "gi", vim.lsp.buf.implemenentation, desc = "[g]oto [i]mplementation" },
    { "gr", vim.lsp.buf.references, desc = "[g]oto [r]eferences" },
    { "K", vim.lsp.buf.hover, desc = "Hover" },
    { "<leader><space>", telescope.find_files, desc = "files" },
    { "<leader>b", group = "[b]uffer" },
    { "<leader>bd", "<cmd>bwipeout<cr>", desc = "[b]uffer [d]elete" },
    { "<leader>bn", "<cmd>bnext<cr>", desc = "[b]uffer [n]ext" },
    { "<leader>bp", "<cmd>bprev<cr>", desc = "[b]uffer [p]revious" },
    { "<leader>c", group = "[c]ode" },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "[c]ode [a]ctions" },
    { "<leader>cf", vim.lsp.buf.format, desc = "[c]ode [f]ormat" },
    { "<leader>ch", vim.lsp.buf.signature_help, desc = "[c]ode [h]elp" },
    { "<leader>cr", vim.lsp.buf.rename, desc = "[c]ode [r]ename" },
    { "<leader>ct", vim.lsp.buf.type_definition, desc = "[c]ode [t]type" },
    { "<leader>f", group = "[f]ind" },
    { "<leader>fb", telescope.buffers, desc = "[f]ind [b]uffer" },
    { "<leader>ff", telescope.find_files, desc = "[f]ind [f]ile" },
    { "<leader>fg", telescope.live_grep, desc = "[f]ind [g]rep" },
    { "<leader>fr", telescope.lsp_references, desc = "[f]ind [r]eferences" },
    { "<leader>ft", "<cmd>Neotree<cr>", desc = "[f]ind [t]ree" },
    { "<leader>t", group = "[t]rouble" },
    { "<leader>tc", function () require("trouble").close() end, desc = "[t]rouble [c]lose" },
    { "<leader>td", function () require("trouble").open("document_diagnostics") end, desc = "[t]rouble [d]oc" },
    { "<leader>tn", vim.diagnostic.goto_next, desc = "[t]rouble [n]ext" },
    { "<leader>tp", vim.diagnostic.goto_prev, desc = "[t]rouble [p]revious" },
    { "<leader>tt", vim.diagnostic.open_float, desc = "[t]rouble [t]ell" },
    { "<leader>tw", function () require("trouble").open("workspace_diagnostics") end, desc = "[t]rouble [w]orkspace" },
})

--vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--    vim.lsp.diagnostic.on_publish_diagnostics,
--    {
--        virtual_text = false,
--        signs = true,
--        update_in_insert = false,
--        underline = true,
--    }
--)

vim.o.tabstop = 4      -- <tab> looks like 4 spaces
vim.o.expandtab = true -- <tab> inserts spaces instead of a <tab> char
vim.o.softtabstop = 4  -- spaces inserted instead of <tabl> char
vim.o.shiftwidth = 4   -- spaces inserted when indenting

vim.o.number = true    -- show line numbers
