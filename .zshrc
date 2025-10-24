# Zsh
# For Debian: echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

# Aliases
# --- Init completion (needs to happen before anything that uses compdef)
autoload -Uz compinit
ZCDUMP="${ZDOTDIR:-$HOME}/.cache/zsh/zcompdump-$ZSH_VERSION"
mkdir -p "${ZCDUMP:h}"
if [[ ! -f $ZCDUMP ]]; then
  compinit -C -d "$ZCDUMP"
else
  compinit -d "$ZCDUMP"
fi

#NeoVim
alias vi="nvim"
alias ls="eza -l --git-ignore --icons --git -TL 2"
alias grep="rg"
alias tmux="tmux -f ~/.config/tmux/tmux.conf attach || tmux -f ~/.config/tmux/tmux.conf new"

# Load Starship prompt
eval "$(starship init zsh)"

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Helper Methods
reload() { source ~/.zshrc && echo "✅ zsh reloaded"; }

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "$HOME/.local/bin/env"

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export TERM=wezterm

export OPENCODE_CONFIG=~/.config/ai/config.json
export PATH="/Users/jose/.local/bin:$PATH"

# Rust environment (cargo binaries)
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
