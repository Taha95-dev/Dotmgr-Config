# Taha's Dotmgr Config

My personal Arch Linux environment, managed entirely by [dotmgr](https://github.com/Taha95-dev/Dotmgr). 

This repo contains my Neovim configuration, custom `dwl` themes, Waybar styling, Zsh setup, and system bootstrapping scripts.

![Preview](assets/preview.png)
*(Add a screenshot of your desktop here!)*

## 🚀 What's Inside

- **`symlinks/`**: Core configurations (Neovim, Alacritty, GTK, Zsh).
- **`themes/`**: Fully modular themes for `dwl`, Waybar, Wofi, and Fastfetch. Includes `moss`, `ember`, `dark`, and `green`.
- **`deps/`**: System packages automatically installed via `pacman`.
- **`commands/`**: Bootstrapping scripts (Git config, Yay installation, Neovim LSP sync).

## ⚡ Bootstrapping a New Machine

If you are on a fresh Arch Linux install and want to replicate this exact setup:

1. **Install `dotmgr`** (requires Go):
```bash
   git clone https://github.com/Taha95-dev/Dotmgr.git
   cd Dotmgr
   go build -o dotmgr .
   sudo install -m 755 dotmgr /usr/local/bin/dotmgr

    Clone this config repo:
    bash

    git clone https://github.com/Taha95-dev/Dotmgr-Config.git ~/.config/dotmgr
    cd ~/.config/dotmgr

    Deploy:
    bash

    # 1. Install all system packages
    dotmgr deps

    # 2. Symlink all configs to ~/.config
    dotmgr link

    # 3. Run the custom setup script (Git config, LSP setup, etc.)
    dotmgr run
```
🎨 Theme Switcher

Switch the entire visual aesthetic of the desktop (Wallpaper, dwl borders, Waybar, Wofi, Alacritty) with FZF:
bash

dotmgr theme

⌨️ Key Components

    WM: dwl (Wayland)

    Terminal: Alacritty

    Editor: Neovim (Lazy.nvim)

    Bar: Waybar

    Launcher: Wofi

    Shell: Zsh

📝 License

MIT License. Feel free to steal anything you like!
