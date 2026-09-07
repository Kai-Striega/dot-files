-- Neovim configuration.
-- Built entirely on Neovim's built-ins: native LSP, built-in completion,
-- default LSP keymaps, built-in syntax highlighting and colorschemes.
-- No plugin manager and no external Neovim plugins.

-- ============================================
-- EDITOR OPTIONS
-- ============================================
-- (nvim already enables syntax, filetype plugin/indent, incsearch, hlsearch,
--  wildmenu and showcmd by default, so those are omitted.)

vim.g.mapleader = "\\"

local opt = vim.opt

-- Hybrid line numbers: relative distances plus the absolute current line.
opt.number = true
opt.relativenumber = true

-- Folding: by indent, everything open by default.
opt.foldmethod = "indent"
opt.foldlevel = 99

opt.cursorline = true

-- Indentation: 4 spaces, no tabs.
opt.shiftwidth = 4
opt.tabstop = 4
opt.expandtab = true

opt.backup = false

-- Keep the cursor away from the screen edges when scrolling.
opt.scrolloff = 10

opt.wrap = false

-- Case-insensitive search unless the query contains capitals.
opt.ignorecase = true
opt.smartcase = true

opt.showmatch = true

-- Files Wildmenu should never offer to edit.
opt.wildignore = "*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx"

-- ============================================
-- STATUS LINE
-- ============================================
opt.statusline = " %F %M %Y %R" .. "%=" .. " ascii: %b hex: 0x%B row: %l col: %c percent: %p%%"
opt.laststatus = 2

-- ============================================
-- COLOR SCHEME
-- ============================================
opt.termguicolors = true
vim.cmd.colorscheme("retrobox")

-- ============================================
-- LSP (native, no nvim-lspconfig)
-- ============================================
-- Server binaries are expected on PATH. rust-analyzer, hls and fortls are
-- typically installed via their toolchains; pyrefly and clangd must be
-- installed separately (see README).

vim.lsp.config("pyrefly", {
  cmd = { "pyrefly", "lsp" },
  filetypes = { "python" },
  root_markers = { "pyrefly.toml", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
})

vim.lsp.config("clangd", {
  cmd = { "clangd" },
  filetypes = { "c", "cpp" },
  root_markers = { "compile_commands.json", ".clangd", ".git" },
})

vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
})

vim.lsp.config("hls", {
  cmd = { "haskell-language-server-wrapper", "--lsp" },
  filetypes = { "haskell", "lhaskell" },
  root_markers = { "*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml", ".git" },
})

vim.lsp.config("fortls", {
  cmd = { "fortls", "--notify_init", "--hover_signature", "--use_signature_help" },
  filetypes = { "fortran" },
  root_markers = { ".fortls", ".git" },
})

vim.lsp.config("texlab", {
  cmd = { "texlab" },
  filetypes = { "tex", "plaintex", "bib" },
  root_markers = { ".latexmkrc", ".git" },
})

vim.lsp.enable({ "pyrefly", "clangd", "rust_analyzer", "hls", "fortls", "texlab" })

-- Show diagnostics inline.
vim.diagnostic.config({ virtual_text = true })

-- ============================================
-- COMPLETION + LSP KEYMAPS
-- ============================================
-- Neovim 0.11+ provides default LSP maps: grr (references), gra (code action),
-- grn (rename), gri (implementation), K (hover) and [d / ]d (diagnostics).
-- We enable autocompletion and add gd (go to definition) per buffer on attach.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf, desc = "Go to definition" })
  end,
})

-- ============================================
-- FILE EXPLORER (built-in netrw)
-- ============================================
vim.keymap.set("n", "<leader>e", "<cmd>Lexplore<CR>", { desc = "Toggle file explorer" })
