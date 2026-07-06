STOW=stow --verbose --no-folding --target=$$HOME
HOST=$(shell uname -n)
DIR=.hosts-$(HOST)
OS=$(shell uname -s)

base:
	$(STOW) --restow */

host:
	if test -d $(DIR); then $(STOW) --restow $(DIR)/; fi

macos:
	if test "$(OS)" = "Darwin"; then $(STOW) --restow .macos/; fi

delete-base:
	$(STOW) --delete */

delete-host:
	if test -d $(DIR); then $(STOW) --delete $(DIR)/; fi

delete-macos:
	if test "$(OS)" = "Darwin"; then $(STOW) --delete .macos/; fi

delete: delete-base delete-host delete-macos

.PHONY: base host macos
