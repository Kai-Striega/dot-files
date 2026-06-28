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
