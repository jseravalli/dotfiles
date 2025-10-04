# Zsh

# Aliases
alias vi="nvim"
alias ls="eza --icons -TL 2 -l --git"
alias grep="rg"
alias tmux="tmux -f ~/.config/tmux/tmux.conf attach || tmux -f ~/.config/tmux/tmux.conf new"

# Load Starship prompt
eval "$(starship init zsh)"

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Helper Methods
reload() { source ~/.zshrc && echo "✅ zsh reloaded"; }

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export TERM=wezterm
