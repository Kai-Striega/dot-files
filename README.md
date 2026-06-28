# dot-files

My dotfiles

# Vim

A portable Vim configuration for Haskell, Python, C++, and Rust development, using vim-plug and CoC for LSP-powered autocomplete.

## Installation

These dotfiles are managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level directory in this repo is a Stow *package* whose contents are
mirrored into `$HOME` (e.g. `vim/.vimrc` is symlinked to `~/.vimrc`). Add new
dotfiles by following the same `package/.dotfile` layout.

1. Install GNU Stow:

```shell
sudo apt install stow      # Debian/Ubuntu
brew install stow          # macOS
```

2. Clone this repo into any directory that you would like:

```shell
gh repo clone Kai-Striega/dot-files ~/dot-files
```

3. Symlink the dotfiles into your home directory with the bootstrap script:

```shell
cd ~/dot-files
./bootstrap.sh -n          # dry run: preview the changes without applying them
./bootstrap.sh             # create the symlinks
./bootstrap.sh -R          # restow after adding new files to a package
```

4. Install the Fortran langauge server `fortls`:

```shell
pipx install fortls
```

5. Open Vim and install plugins:


```vim
:PlugInstall
```

6. Install CoC langauge extensions:

```vim
:CocInstall coc-pyright coc-clangd coc-rust-analyzer
```

7. Add config for Haskell and Fortran by opening :CocConfig in Vim and pasting:

```json
{
  "languageserver": {
    "haskell": {
      "command": "haskell-language-server-wrapper",
      "args": ["--lsp"],
      "rootPatterns": ["*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml"],
      "filetypes": ["haskell", "lhaskell"]
    },
    "fortran": {
      "command": "fortls",
      "args": ["--notify_init", "--hover_signature", "--use_signature_help"],
      "rootPatterns": [".fortls", ".git"],
      "filetypes": ["fortran"]
    }
  }
}
```

## Language Support 

### macOS

```shell
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install node
```

### Linux (Debian/Ubuntu)

```shell
sudo apt update && sudo apt-get upgrade -y
sudo apt install -y curl git vim build-essential libffi-dev libgmp-dev \
  libncurses-dev libncurses5 libtinfo5 pkg-config
```

Install Node.js via nvm (recommended over apt, which often ships an outdated version):

```shell
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install --lts
```

## Color Scheme (Molokai)

```
cd ~/.vim/colors
```

```
curl -o molokai.vim https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim
```

# Neovim

A minimal Neovim configuration for the same languages, built entirely on
Neovim's built-ins: native LSP, built-in completion, default LSP keymaps, and a
bundled colorscheme. There is no plugin manager and no external Neovim plugins.
Requires **Neovim 0.11+** (the native `vim.lsp.config`/`vim.lsp.enable` API).

## Installation

1. Stow the `nvim` package (symlinks `~/.config/nvim/init.lua`):

```shell
cd ~/dot-files
./bootstrap.sh nvim
```

2. Install the language servers you need so the LSP can attach. `rust-analyzer`,
   `haskell-language-server-wrapper`, and `fortls` usually come with their
   toolchains; `pyright` and `clangd` are installed separately:

```shell
npm install -g pyright       # Python
sudo apt install clangd      # C/C++
```

## Key bindings

LSP navigation uses Neovim's built-in defaults: `K` (hover), `gd` (definition),
`grr` (references), `gri` (implementation), `grn` (rename), `gra` (code action),
and `[d` / `]d` (previous/next diagnostic). `<leader>e` toggles the built-in
netrw file explorer.
