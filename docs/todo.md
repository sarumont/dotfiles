# TODO

Open items carried over from the stow → chezmoi migration (completed
2026-10-08 on shiva, dadfi and ifrit). The full migration log is in git
history: `git log --all -- MIGRATION.md`.

## Machines

- [ ] **ifrit: Homebrew only.** It uses both MacPorts and Homebrew; move the
      `darwin_port` list in `home/.chezmoidata/packages.yaml` to Homebrew and
      drop MacPorts (also the MacPorts paths in `.zshenv` and `sysup`).
- [ ] **ifrit: private SSH hosts.** `secretRefs.sshConfig.onepassword` in
      `home/.chezmoidata/secrets.yaml` is empty, so `~/.ssh/config.d/private`
      renders empty there. Create the 1Password item and fill in the `op://`
      reference if ifrit needs those hosts.
- [ ] **dadfi: herdr follow-up.** herdr now comes from the official installer
      off Omarchy; after `chezmoi apply`, `sudo pacman -R herdr` and restart the
      herdr server once (skip if already done).
- [ ] **mesafi:** not migrated. Decide whether to remove its GitHub auth key:
      `gh ssh-key delete 117524922`.
- [ ] Archive `~/dotfiles-pre-rewrite-2026-10-08.tar.gz` (shiva) somewhere
      safe: the repo's pre-rewrite history (mirror + bundle).

## Decisions parked

- [ ] **Docker access** stays on `sudo docker`. Options and tradeoffs: README
      "Docker".
- [ ] **herdr handoff on Omarchy:** shiva keeps Omarchy's packaged herdr (no
      `--handoff`, restart after `omarchy update`). Switch to the official
      installer only if that becomes a pain.
- [ ] **`sysup` name:** looking for something snarkier.
- [ ] **Neovim visual `S`:** flash's treesitter select wins over vim-surround's
      visual surround. Revisit if missed.
- [ ] **Kotlin LSP** needs a JDK (e.g. `java = "temurin-21"` in mise). Skipped
      while not writing Kotlin; the `lang.kotlin` extra stays.

## Verify

- [ ] Next time the Proton Pass session is gone, confirm `chezmoi status`
      prints the "not logged in: skipping secret-backed files" warning
      (`.chezmoitemplates/secrets-ready` assumes `pass-cli vault list` fails
      without a session).
