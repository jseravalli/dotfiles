# Zsh

# Aliases
alias vi="nvim"
alias ls="eza --icons -TL 2 -l --git"
alias grep="rg"

# Load Starship prompt
eval "$(starship init zsh)"

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Helper Methods
reload() { source ~/.zshrc && echo "✅ zsh reloaded"; }

echo "ZSH Session Loaded 🚀"
