vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
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
        "akinsho/bufferline.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
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
        opts = {
            window = {
                position = "current",
            },
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
                    { "filename", path = 1}
                },
            },
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
                    "javascript",
                    "jsdoc",
                    "json",
                    "json5",
                    "lua",
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
                "eslint",
                "jsonls",
                "lua_ls",
                "pyright",
                "terraformls",
                "tsserver",
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

            require("lspconfig").eslint.setup({
                capabilities,
                on_attach = function(client, bufnr)
                    vim.api.nvim_create_autocmd("BufWritePre", { buffer = bufnr, command = "EslintFixAll" })
                end,
            });
            require("lspconfig").jsonls.setup({ capabilities })
            require("lspconfig").lua_ls.setup({ capabilities })
            require("lspconfig").pyright.setup({ capabilities })
            require("lspconfig").terraformls.setup({ capabilities })
            require("lspconfig").tsserver.setup({ capabilities })
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
}, {
    install = {
        colorscheme = { "nightfox" }
    },
})


local wk = require("which-key")
local telescope = require("telescope.builtin")

wk.register({
    g = {
        name = "[g]oto",
        d = { vim.lsp.buf.definition, "[g]oto [d]efinition" },
        D = { vim.lsp.buf.declaration, "[g]oto [D]eclaration" },
        i = { vim.lsp.buf.implemenentation, "[g]oto [i]mplementation" },
        r = { vim.lsp.buf.references, "[g]oto [r]eferences" },
    },
    K = { vim.lsp.buf.hover, "Hover" }
})

wk.register({
    ["<space>"] = { telescope.find_files, "files" },
    b = {
        name = "[b]uffer",
        d = { "<cmd>bwipeout<cr>", "[b]uffer [d]elete" },
        n = { "<cmd>bnext<cr>", "[b]uffer [n]ext" },
        p = { "<cmd>bprev<cr>", "[b]uffer [p]revious" },
    },
    c = {
        name = "[c]ode",
        a = { vim.lsp.buf.code_action, "[c]ode [a]ctions" },
        f = { vim.lsp.buf.format, "[c]ode [f]ormat" },
        h = { vim.lsp.buf.signature_help, "[c]ode [h]elp" },
        r = { vim.lsp.buf.rename, "[c]ode [r]ename" },
        t = { vim.lsp.buf.type_definition, "[c]ode [t]type" },
    },
    f = {
        name = "[f]ind",
        b = { telescope.buffers, "[f]ind [b]uffer" },
        f = { telescope.find_files, "[f]ind [f]ile" },
        g = { telescope.live_grep, "[f]ind [g]rep" },
        r = { telescope.lsp_references, "[f]ind [r]eferences" },
    },
    t = {
        name = "[t]rouble",
        c = { function() require("trouble").close() end, "[t]rouble [d]oc" },
        d = { function() require("trouble").open("document_diagnostics") end, "[t]rouble [d]oc" },
        f = { function() require("neotest").run.run(vim.fn.expand("%")) end, "[t]est [f]ile" },
        n = { vim.diagnostic.goto_next, "[t]rouble [n]ext" },
        p = { vim.diagnostic.goto_prev, "[t]rouble [p]revious" },
        t = { vim.diagnostic.open_float, "[t]rouble [t]ell" },
        w = { function() require("trouble").open("workspace_diagnostics") end, "[t]rouble [w]orkspace" },
    },
}, { prefix = "<leader>" })

--vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--    vim.lsp.diagnostic.on_publish_diagnostics,
--    {
--        virtual_text = false,
--        signs = true,
--        update_in_insert = false,
--        underline = true,
--    }
--)

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

vim.o.tabstop = 4      -- <tab> looks like 4 spaces
vim.o.expandtab = true -- <tab> inserts spaces instead of a <tab> char
vim.o.softtabstop = 4  -- spaces inserted instead of <tabl> char
vim.o.shiftwidth = 4   -- spaces inserted when indenting

vim.o.number = true    -- show line numbers
