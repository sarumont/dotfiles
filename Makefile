all:
	stow --verbose --target=$$HOME --restow */

delete:
	stow --verbose --target=$$HOME --delete */

install-nvchad:
	git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
