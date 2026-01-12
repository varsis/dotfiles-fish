return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "mason-org/mason.nvim",
      opts = {},
    },
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {
        automatic_enable = false,
        ensure_installed = {
          "bashls",
          "clangd",
          "cssls",
          "dockerls",
          "gopls",
          "html",
          "htmx",
          "jsonls",
          "lua_ls",
          "rust_analyzer",
          "taplo",
          "templ",
          "tailwindcss",
          "terraformls",
          "tflint",
          "ts_ls",
          "yamlls",
          "zls",
          "eslint",
        },
      },
    },
  },
  config = function()
    require("mason").setup()
    local keymaps = require("lsp_keymaps")
    require("lsp_autocommands").setup()

    local capabilities = require("blink.cmp").get_lsp_capabilities({
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true, -- needs fswatch on linux
          relativePatternSupport = true,
        },
      },
    }, true)

    ---@param client vim.lsp.Client LSP client
    ---@param bufnr number Buffer number
    ---@diagnostic disable: unused-local
    local on_attach = function(client, bufnr)
      keymaps.on_attach(bufnr)
    end

    -- Set global defaults for all LSP servers
    vim.lsp.config('*', {
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Configure gopls
    vim.lsp.config('gopls', {
      settings = {
        gopls = {
          gofumpt = true,
          codelenses = {
            gc_details = true,
            generate = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          analyses = {
            nilness = true,
            unusedparams = true,
            unusedvariable = true,
            unusedwrite = true,
            useany = true,
          },
          staticcheck = true,
          directoryFilters = { "-.git", "-node_modules" },
          semanticTokens = true,
        },
      },
      flags = {
        debounce_text_changes = 150,
      },
    })
    vim.lsp.enable('gopls')

    -- Configure ts_ls
    vim.lsp.config('ts_ls', {
      settings = {
        javascript = {
          inlayHints = {
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true,
          },
        },
        typescript = {
          inlayHints = {
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true,
          },
        },
      },
    })
    vim.lsp.enable('ts_ls')

    -- Enable servers with default config
    for _, lsp in ipairs({
      "bashls",
      "clangd",
      "cssls",
      "dockerls",
      "jsonls",
      "rust_analyzer",
      "taplo",
      "templ",
      "terraformls",
      "tflint",
      "zls",
    }) do
      vim.lsp.enable(lsp)
    end

    -- Configure html and htmx with custom filetypes
    for _, lsp in ipairs({ "html", "htmx" }) do
      vim.lsp.config(lsp, {
        filetypes = { "html", "templ" },
      })
      vim.lsp.enable(lsp)
    end

    -- Configure tailwindcss
    vim.lsp.config('tailwindcss', {
      filetypes = { "html", "templ", "javascript" },
      settings = {
        tailwindCSS = {
          includeLanguages = {
            templ = "html",
          },
        },
      },
    })
    vim.lsp.enable('tailwindcss')

    -- Configure yamlls
    vim.lsp.config('yamlls', {
      settings = {
        yaml = {
          schemaStore = {
            url = "https://www.schemastore.org/api/json/catalog.json",
            enable = true,
          },
        },
      },
    })
    vim.lsp.enable('yamlls')

    -- Configure eslint with custom on_attach
    vim.lsp.config('eslint', {
      on_attach = function(client, bufnr)
        keymaps.on_attach(bufnr)

        -- Optionally format on save if eslint supports it
        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll", -- Requires eslint.nvim or custom command
          })
        end
      end,
    })
    vim.lsp.enable('eslint')

    -- Configure lua_ls
    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          telemetry = { enable = false },
          hint = {
            enable = true,
          },
        },
      },
    })
    vim.lsp.enable('lua_ls')

    local float_config = {
      focusable = true,
      style = "minimal",
      border = "none",
      source = "if_many",
      max_width = 80,
    }

    -- setup diagnostics
    vim.diagnostic.config({
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = float_config,
    })

    vim.lsp.buf.hover(float_config)
    vim.lsp.buf.signature_help(float_config)
    vim.highlight.priorities.semantic_tokens = 95

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded", -- optional
      max_width = 80,     -- forces line wrapping
      wrap = true,
    })

    -- Also ensure wrapping is enabled for floating windows:
    vim.api.nvim_create_autocmd("BufWinEnter", {
      callback = function()
        local config = vim.api.nvim_win_get_config(0)
        if config and config.relative ~= "" then
          vim.wo.wrap = true
        end
      end,
    })

    -- set up diagnostic signs
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "󰌶",
        },
      },
    })
  end,
}
