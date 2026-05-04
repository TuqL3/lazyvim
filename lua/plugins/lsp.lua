return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        vtsls = {
          settings = {
            typescript = {
              tsserver = {
                maxTsServerMemory = 8192,
                experimental = {
                  enableProjectDiagnostics = false,
                  useVsCodeWatcher = false,
                },
                watchOptions = {
                  watchFile = "useFsEventsOnParentDirectory",
                  watchDirectory = "useFsEvents",
                  fallbackPolling = "dynamicPriority",
                  excludeDirectories = { "**/node_modules", "**/.git", "**/dist", "**/build", "**/.next", "**/coverage", "**/.turbo" },
                },
              },
              preferences = {
                includePackageJsonAutoImports = "off",
                importModuleSpecifier = "shortest",
              },
              suggest = {
                autoImports = false,
                completeFunctionCalls = false,
              },
              workspaceSymbols = { scope = "currentProject" },
              implementationsCodeLens = { enabled = false },
              referencesCodeLens = { enabled = false, showOnAllFunctions = false },
              inlayHints = {
                parameterNames = { enabled = "none" },
                parameterTypes = { enabled = false },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                enumMemberValues = { enabled = false },
              },
            },
            javascript = {
              suggest = { autoImports = false, completeFunctionCalls = false },
              inlayHints = {
                parameterNames = { enabled = "none" },
                parameterTypes = { enabled = false },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
              },
            },
            vtsls = {
              experimental = {
                completion = { enableServerSideFuzzyMatch = true },
                maxInlayHintLength = 30,
              },
              autoUseWorkspaceTsdk = true,
              tsserver = {
                globalPlugins = {},
              },
            },
          },
        },

        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
            run = "onSave",
            problems = { shortenToSingleLine = true },
          },
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(
              "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs", "eslint.config.ts",
              ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml", ".eslintrc.yml", ".eslintrc.json",
              "package.json"
            )(fname)
          end,
          on_new_config = function(config, new_root_dir)
            local function has_eslint(dir)
              return vim.fn.filereadable(dir .. "/node_modules/eslint/package.json") == 1
                or vim.fn.filereadable(dir .. "/node_modules/.bin/eslint") == 1
            end
            local dir = new_root_dir
            while dir and dir ~= "/" do
              if has_eslint(dir) then return end
              dir = vim.fn.fnamemodify(dir, ":h")
            end
            config.enabled = false
          end,
        },

        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim", "Snacks", "MiniMap" },
              },
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },

        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              usePlaceholders = true,
              staticcheck = true,
              completeUnimported = true,
              analyses = {
                unusedparams = true,
                shadow = true,
                nilness = true,
                unusedwrite = true,
                useany = true,
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
            },
          },
        },
      },
    },
  },
}
