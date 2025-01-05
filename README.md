# Dotfiles Repository

This repository contains configuration files for various tools and applications. The dotfiles are organized for easy management using [GNU Stow](https://www.gnu.org/software/stow/), a symlink farm manager, to simplify symlink creation and maintenance.

## 📁 File Structure

```plaintext
.
├── .config/
│   ├── nvim/           # Neovim configuration
│   ├── ghostty/        # Ghostty terminal emulator configuration
│   └── starship/       # Starship prompt configuration
├── zshrc/              # Zsh shell configuration (symlink to ~/.zshrc)
└── tmux/               # Tmux configuration (symlink to ~/.tmux.conf)
```

## 🚀 Installation

To use this repository, follow the steps below:

1. Install GNU Stow

You can install GNU Stow using Homebrew:

```plaintext
brew install stow
```

2. Clone the Repository

Clone the repository to your home directory:

```plaintext
git clone https://github.com/your-username/dotfiles.git ~/dotfiles

cd ~/dotfiles
```

3. Apply the Dotfiles Using Stow

To create symlinks for your configurations, run the following command:

```plaintext
stow .
```

## 💡 Contributing

Feel free to open issues or submit pull requests for improvements or fixes!
