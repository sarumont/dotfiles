# TODO

Open items carried over from the stow → chezmoi migration (completed
2026-10-08 on shiva, dadfi and ifrit). The full migration log is in git
history: `git log --all -- MIGRATION.md`.

## Machines

- [x] **ifrit: Homebrew only.** Migrated retained MacPorts tools to Homebrew
      or existing mise/uvx-managed tools, removed MacPorts, and switched
      dotfiles package install/update to Homebrew only.
- [ ] **ifrit: environment secrets → 1Password** (migrate on ifrit). Pattern:
      - one template, e.g. `home/dot_local/sh/private_ifrit.secrets.zshenv.tmpl`
        (`private_` → 0600; the `*.zshenv` loader picks it up, and the
        existing `.local/sh/ifrit.*` ignore rule keeps it off other hosts);
      - each line `export FOO='{{ template "secret" (list .secrets "" "op://VAULT/ITEM/FIELD") }}'`,
        or iterate one item's fields (`onepassword "item"` → `.fields`);
      - add the target to the secrets block in `home/.chezmoiignore` so it's
        skipped, not failed, when `op` isn't signed in.
      - `secretRefs.sshConfig` is unused there (no private SSH hosts).

## Decisions parked

- [ ] **Docker access** stays on `sudo docker`. Options and tradeoffs: README
      "Docker".
- [ ] **herdr handoff on Omarchy:** shiva keeps Omarchy's packaged herdr (no
      `--handoff`, restart after `omarchy update`). Switch to the official
      installer only if that becomes a pain.
- [ ] **`sysup` name:** looking for something snarkier.
