STOW=stow --verbose --no-folding --target=$$HOME
HOST=$(shell uname -n)
DIR=hosts-$(HOST)

base:
	$(STOW) --restow */

host:
	if test -d $(DIR); then $(STOW) --restow $(DIR)/; fi

delete-base:
	$(STOW) --delete */

delete-host:
	if test -d $(DIR); then $(STOW) --delete $(DIR)/; fi

delete: delete-base delete-host

install-nvchad:
	git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

.PHONY: base host
