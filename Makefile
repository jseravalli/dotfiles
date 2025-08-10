# Makefile for setting up dotfiles

DOTFILES_DIR ?= $(HOME)/code/jseravalli/dotfiles
INSTALL_SCRIPT := $(DOTFILES_DIR)/install.zsh

.PHONY: all install

all: install

install:
	@echo "→ Running install script..."
	@chmod +x $(INSTALL_SCRIPT)
	@DOTFILES_DIR=$(DOTFILES_DIR) $(INSTALL_SCRIPT)
	@echo "✅ Installation complete!"

