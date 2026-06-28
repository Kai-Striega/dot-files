# dot-files

My dotfiles

# Dependencies

A complete list of everything the configurations in this repo expect, grouped by
the stow package that needs it. Install commands are given for Debian/Ubuntu
(`apt`) and macOS (`brew`); items installed through a language toolchain or a
vendor script show that instead.

## Core (needed by every setup)

| Dependency | Used for | Install |
|------------|----------|---------|
| [GNU Stow](https://www.gnu.org/software/stow/) | `bootstrap.sh` symlinks the packages into `$HOME` | `sudo apt install stow` / `brew install stow` |
| git | cloning this repo, LSP project-root detection, Oh My Zsh `git` plugin | `sudo apt install git` / `brew install git` |
| curl | fetching the installers and plugins below | `sudo apt install curl` / preinstalled on macOS |

## Shell — `zsh` package (`zsh/.zshrc`)

| Dependency | Used for | Install |
|------------|----------|---------|
| zsh | the shell itself | `sudo apt install zsh` / `brew install zsh` |
| [Oh My Zsh](https://ohmyz.sh/) | framework (`robbyrussell` theme, `git` plugin) | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` |
| [Starship](https://starship.rs/) | the prompt (`starship init zsh`) | `curl -sS https://starship.rs/install.sh \| sh` / `brew install starship` |
| tmux | the `t` alias (`tmux new-session -A -s main`) | `sudo apt install tmux` / `brew install tmux` |
| Neovim | the `vim` alias points at `nvim` (see below) | see the `nvim` package |

## Neovim — `nvim` package (`nvim/.config/nvim/init.lua`)

| Dependency | Used for | Install |
|------------|----------|---------|
| Neovim **0.11+** | the editor; native LSP API (`vim.lsp.config`/`vim.lsp.enable`) | `sudo apt install neovim` / `brew install neovim` |

The Neovim config uses no plugins. It only needs the language-server binaries below.

## Language servers (used by Neovim's native LSP)

| Server | Language | Install |
|--------|----------|---------|
| pyright (`pyright-langserver`) | Python | `npm install -g pyright` (needs [Node.js](#nodejs)) |
| clangd | C / C++ | `sudo apt install clangd` / `brew install llvm` |
| rust-analyzer | Rust | `rustup component add rust-analyzer` (see [Rust](#rust)) |
| haskell-language-server (`haskell-language-server-wrapper`) | Haskell | `ghcup install hls` (see [Haskell](#haskell)) |
| fortls | Fortran | `uv tool install fortls` (needs [uv](#uv)) |

## Toolchains used to obtain the servers

### Node.js

Install via nvm (recommended over apt, which often ships an outdated version):

```shell
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install --lts
```

### Rust

```shell
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### Haskell

```shell
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

### uv (for fortls)

[uv](https://docs.astral.sh/uv/) installs each tool into its own isolated
environment using its own managed Python, so it is unaffected by system Python
changes:

```shell
curl -LsSf https://astral.sh/uv/install.sh | sh   # install uv
uv tool install fortls                            # install the Fortran server
```

### Build prerequisites (Linux)

Needed to build native toolchains such as GHC/HLS:

```shell
sudo apt update && sudo apt-get upgrade -y
sudo apt install -y curl git build-essential libffi-dev libgmp-dev \
  libncurses-dev libncurses5 libtinfo5 pkg-config
```

On macOS install the Command Line Tools and Homebrew instead:

```shell
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

# Installation

These dotfiles are managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level directory in this repo is a Stow *package* whose contents are
mirrored into `$HOME` (e.g. `zsh/.zshrc` is symlinked to `~/.zshrc`). Add new
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

See the [Dependencies](#dependencies) section above for the tools each package
needs, then see [Neovim](#neovim) for the editor's language servers.

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
