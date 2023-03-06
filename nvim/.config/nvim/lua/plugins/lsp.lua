local function config_lsp(_, _)
  local desc = require("config.lib").desc

  local function lsp_keys()
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, desc(opts, "Open float"))
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, desc(opts, "Go to previous diagnostic"))
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, desc(opts, "Go to next diagnostic"))
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, desc(opts, "Set location list"))
  end

  local function on_attach(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gD", function()
      vim.lsp.buf.declaration()
    end, desc(opts, "Go to declaration"))
    vim.keymap.set("n", "gd", function()
      vim.lsp.buf.definition()
    end, desc(opts, "Go to definition"))
    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover()
    end, desc(opts, "Hover"))
    vim.keymap.set("n", "<leader>vw", function()
      vim.lsp.buf.workspace_symbol("")
    end, desc(opts, "View workspace symbol"))
    vim.keymap.set("n", "<leader>vd", function()
      vim.diagnostic.open_float()
    end, desc(opts, "View diagnostic"))
    vim.keymap.set("n", "<leader>vc", "<cmd>CodeActionMenu<CR>", desc(opts, "View code actions"))
    vim.keymap.set("n", "<leader>vrr", function()
      vim.lsp.buf.references({})
    end, desc(opts, "View references"))
    vim.keymap.set("n", "<leader>vrn", function()
      vim.lsp.buf.rename()
    end, desc(opts, "Rename in buffer"))
    vim.keymap.set("i", "<C-h>", function()
      vim.lsp.buf.signature_help()
    end, desc(opts, "View signature help"))
  end

  local function lsp_settings()
    local sign = function(opts)
      vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = "",
      })
    end

    sign({ name = "DiagnosticSignError", text = "✘" })
    sign({ name = "DiagnosticSignWarn", text = "▲" })
    sign({ name = "DiagnosticSignHint", text = "⚑" })
    sign({ name = "DiagnosticSignInfo", text = "" })

    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      update_in_insert = false,
      underline = true,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })

    -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    --
    -- vim.lsp.handlers["textDocument/signatureHelp"] =
    --     vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
  end

  local function setup_cmp()
    local lspkind = require("lspkind")
    local luasnip = require("luasnip")
    local cmp = require("cmp")

    vim.opt.completeopt = { "menu", "menuone", "noselect" }
    local select_opts = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      sources = {
        { name = "path" },
        { name = "nvim_lsp", keyword_length = 3 },
        { name = "buffer",   keyword_length = 3 },
        -- {name = 'luasnip', keyword_length = 2},
      },
      window = {
        documentation = vim.tbl_deep_extend("force", cmp.config.window.bordered(), {
          max_height = 15,
          max_width = 60,
        }),
      },
      formatting = {
        fields = { "abbr", "menu", "kind" },
        format = lspkind.cmp_format({
          mode = "symbol_text",
          before = function(entry, item)
            local short_name = {
              nvim_lsp = "LSP",
              nvim_lua = "nvim",
            }

            local menu_name = short_name[entry.source.name] or entry.source.name

            item.menu = string.format("[%s]", menu_name)
            return item
          end,
        }),
      },
      mapping = {
        -- confirm selection
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<C-y>"] = cmp.mapping.confirm({ select = false }),

        -- navigate items on the list
        ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
        ["<Down>"] = cmp.mapping.select_next_item(select_opts),
        ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
        ["<C-n>"] = cmp.mapping.select_next_item(select_opts),

        -- scroll up and down in the completion documentation
        ["<C-f>"] = cmp.mapping.scroll_docs(5),
        ["<C-u>"] = cmp.mapping.scroll_docs( -5),

        ["<C-Space>"] = cmp.mapping.complete({}),

        -- toggle completion
        ["<C-e>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.abort()
            fallback()
          else
            cmp.complete()
          end
        end),

        -- go to next placeholder in the snippet
        ["<C-d>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),

        -- go to previous placeholder in the snippet
        ["<C-b>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable( -1) then
            luasnip.jump( -1)
          else
            fallback()
          end
        end, { "i", "s" }),
      },
    })

    --   ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    -- cmp_mappings['<Tab>'] = nil
    -- cmp_mappings['<S-Tab>'] = nil
    --
    cmp.setup.filetype({ "markdown" }, {
      completion = {
        autocomplete = false, ---@diagnostic disable-line
      },
    })
  end

  lsp_keys()
  lsp_settings()
  setup_cmp()

  require("neodev").setup({
    override = function(root_dir, options)
      if root_dir == "/home/norta/code/dotfiles/nvim/.config/nvim/lua/" then
        options.plugins = true
      end
    end,
  })
  require("mason").setup()
  require("mason-lspconfig").setup()
  local lspconfig = require("lspconfig")

  local configs = require("lspconfig.configs")
  if not configs.myst then
    configs.myst = {
      default_config = {
        cmd = { "myst-lsp", "--stdio" },
        filetypes = { "markdown" },
        root_dir = function(fname)
          return lspconfig.util.find_git_ancestor(fname)
        end,
        single_file_support = true,
      },
    }
  end

  local default_capabilities = require("cmp_nvim_lsp").default_capabilities()
  local auto_langs = { "gopls", "clangd", "myst", "lua_ls", "bashls" }

  for _, server in ipairs(auto_langs) do
    lspconfig[server].setup({
      on_attach = on_attach,
      capabilities = default_capabilities,
    })
  end

  lspconfig.pyright.setup({
    on_attach = on_attach,
    capabilities = default_capabilities,
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "off",
        },
      },
    },
  })

  --[[ lspconfig.pylsp.setup({
    on_attach = on_attach,
    capabilities = default_capabilities,
    settings = {
      pylsp = {
        plugins = {
          pylsp_mypy = {
            enabled = true,
            live_mode = true,
            dmypy = false,
          },
          autopep8 = {
            enabled = false,
          },
          jedi_completion = {
            enabled = false,
          },
          jedi_definition = {
            enabled = false,
          },
          jedi_hover = {
            enabled = false,
          },
          jedi_references = {
            enabled = false,
          },
          jedi_signature_help = {
            enabled = false,
          },
          jedi_symbols = {
            enabled = false,
          },
          mccabe = {
            enabled = false,
          },
          pycodestyle = {
            enabled = false,
          },
          pyflakes = {
            enabled = false,
          },
          yapf = {
            enabled = false,
          },
        },
      },
    },
  }) ]]
  require("rust-tools").setup({
    server = {
      on_attach = on_attach,
    },
  })
end

return {
  -- LSP!!!
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- LSP Support
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "folke/neodev.nvim" },

      -- Autocompletion
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },

      --- VSCode icons for cmp
      { "onsails/lspkind.nvim" },

      --- Better signature help
      {
        "ray-x/lsp_signature.nvim",
        config = true,
      },

      -- Snippets
      { "L3MON4D3/LuaSnip" },

      -- { "rafamadriz/friendly-snippets" },

      -- Language specific configs
      { "simrat39/rust-tools.nvim" },

      -- Better diagnostics
      {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = true,
      },

      -- UI for LSP
      {
        "j-hui/fidget.nvim",
        config = true,
      },

      --- Glance like vscode peek
      {
        "dnlhc/glance.nvim",
        event = "VeryLazy",
        config = true,
        keys = {
          { "<leader>pd", "<cmd>Glance definitions<CR>",      desc = "Peek definitions" },
          { "<leader>pt", "<cmd>Glance type_definitions<CR>", desc = "Peek type definitions" },
          { "<leader>pi", "<cmd>Glance implementations<CR>",  desc = "Peek implementations" },
          { "<leader>pr", "<cmd>Glance references<CR>",       desc = "Peek references" },
        },
      },

      -- Extra LSP Sources
      {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "mason.nvim" },
        opts = function()
          local nls = require("null-ls")
          return {
            sources = {
              nls.builtins.formatting.stylua,
              nls.builtins.formatting.black,
              -- nls.builtins.diagnostics.mypy,
              nls.builtins.diagnostics.ruff,
              nls.builtins.diagnostics.rpmspec,
            },
          }
        end,
      },
    },
    config = config_lsp,
    ft = {
      "python",
      "c",
      "cpp",
      "rust",
      "bash",
      "zsh",
      "sh",
      "lua",
      "markdown",
      "spec",
      "go",
    },
    cond = function()
      return not vim.g.disable_lsp
    end,
  },
  {
    "kosayoda/nvim-lightbulb",
    event = "VeryLazy",
    dependencies = {
      { "antoinemadec/FixCursorHold.nvim" },
      {
        "weilbith/nvim-code-action-menu",
        cmd = "CodeActionMenu",
        config = function()
          vim.keymap.set("i", "<C-l>", "<cmd>CodeActionMenu<CR>")
        end,
      },
    },
    opts = {
      autocmd = { enabled = true },
    },
  },
}
