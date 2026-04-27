# dot-files

My dotfiles

# Vim

A portable Vim configuration for Haskell, Python, C++, and Rust development, using vim-plug and CoC for LSP-powered autocomplete.

## Installation

1. Clone this repo into any directory that you would like:

```shell
gh repo clone Kai-Striega/dot-files ~/
```

2. Add a symbolic link for you system to find your dotfiles:

```shell
ln -s ~/dot-files/.vimrc ~/.vimrc
```

3. Install the Fortran langauge server `fortls`:

```shell
pipx install fortls
```

4. Open Vim and install plugins:


```vim
:PlugInstall
```

5. Install CoC langauge extensions:

```vim
:CocInstall coc-pyright coc-clangd coc-rust-analyzer
```

6. Add config for Haskell and Fortran by opening :CocConfig in Vim and pasting:

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
