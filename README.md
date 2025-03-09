# (Under development)

# arculet.nvim 🌌

*A chill Neovim configuration for focused developers who want just what they need*

## Philosophy

This configuration is built for developers who:
- Want a **minimal but capable** setup
- Prefer understanding their config over using magic
- Need core IDE features without the bloat
- Enjoy a calm, distraction-free coding environment

No chadness, no megapacks - just essential tools configured thoughtfully.

## Features ✨

- **Minimal foundation** with carefully chosen plugins
- Essential IDE features (LSP, formatting, diagnostics)
- Smart navigation core (telescope, harpoon)
- Zen-like UI with subtle animations
- Batteries included but not forced
- Easy to understand and modify
- Optimized for flow state coding

## Installation ⚡

1. **Backup your current config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. Clone the repository:
   ```bash
   git clone https://github.com/arculetHQ/arculet.nvim ~/.config/nvim
   ```

3. Start NeoVim:
   ```bash
   nvim
   ```

## Configuration Structure 🗂️

```
.
├── init.lua
└── lua/
    └── arculet_nvim/
        ├── core/       # Essential settings
        │   ├── init.lua
        │   ├── keymaps.lua # Key mappings
        │   ├── options.lua # Editor options
        │   └── python.lua  # Python-specific config
        │
        ├── plugins/    # Plugin management
        │   ├── configs/    # Plugin configurations
        │   ├── specs/      # Plugin specifications
        │   ├── init.lua
        │   └── lazy.lua    # Lazy.nvim setup
        │
        ├── lsp/       # LSP configurations
        ├── custom/    # User customizations
        └── init.lua
```

## Basic Usage 🕹️


## Customization 🎨

This config is meant to be _your_ foundation. To make it yours:

1. Add new plugins in `lua/arculet_nvim/plugins/specs/`
2. Modify plugin configs in `lua/arculet_nvim/plugins/configs/`
3. Edit `lua/arculet_nvim/core/keymaps.lua` for keybindings
4. Add personal overrides in `lua/arculet_nvim/custom/`
5. Run `:Lazy sync` after making changes

**Pro tip:** Use the `custom/` directory to keep your personal modifications separate!

## Contributing 🤝

Found a bug or have an improvement idea?  
1. Open an issue to discuss
2. Fork the repository
3. Create a feature branch
4. Submit a PR with clear description

## License 📜

MIT License - see [LICENSE](LICENSE) for details

## Acknowledgments 🙏

- Neovim team for building an amazing editor
- Lazy.nvim maintainers for the great plugin manager
- Plugin authors for their incredible work
- Coffee beans everywhere for keeping us coding

