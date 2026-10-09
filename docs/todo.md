# TODO

Open items carried over from the stow → chezmoi migration (completed
2026-10-08 on shiva, dadfi and ifrit). The full migration log is in git
history: `git log --all -- MIGRATION.md`.

## Machines

- [x] **ifrit: Homebrew only.** Migrated retained MacPorts tools to Homebrew
      or existing mise/uvx-managed tools, removed MacPorts, and switched
      dotfiles package install/update to Homebrew only.
- [x] **ifrit: environment secrets → 1Password.** Added the private
      `~/.local/sh/ifrit.secrets.zshenv` with references into the `dotfiles`
      vault; non-private Moov environment settings live in `ifrit.zshenv`.
      Chezmoi skips the secret-backed target when the 1Password CLI is
      unavailable.

## Decisions parked

- [ ] **Docker access** stays on `sudo docker`. Options and tradeoffs: README
      "Docker".
- [ ] **herdr handoff on Omarchy:** shiva keeps Omarchy's packaged herdr (no
      `--handoff`, restart after `omarchy update`). Switch to the official
      installer only if that becomes a pain.
- [ ] **`sysup` name:** looking for something snarkier.
