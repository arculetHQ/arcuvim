#!/bin/bash

# Create base directory
NVIM_DIR="$HOME/.config/nvim"
mkdir -p "$NVIM_DIR"

# Create root init.lua
touch "$NVIM_DIR/init.lua"

# Create lua structure
mkdir -p "$NVIM_DIR/lua/"{core,plugins,lsp,ui}
touch "$NVIM_DIR/lua/init.lua"

# Create core structure
touch "$NVIM_DIR/lua/core/init.lua"

# Create plugins structure
mkdir -p "$NVIM_DIR/lua/plugins/"{specs,configs}
touch "$NVIM_DIR/lua/plugins/init.lua"

# Create LSP structure
touch "$NVIM_DIR/lua/lsp/init.lua"

echo "Neovim folder structure created at: $NVIM_DIR"
