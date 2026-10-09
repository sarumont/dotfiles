# TODO

Open items carried over from the stow → chezmoi migration (completed
2026-10-08 on shiva, dadfi and ifrit). The full migration log is in git
history: `git log --all -- MIGRATION.md`.

## Machines

- [ ] **ifrit: Homebrew only.** It uses both MacPorts and Homebrew; move the
      `darwin_port` list in `home/.chezmoidata/packages.yaml` to Homebrew and
      drop MacPorts (also the MacPorts paths in `.zshenv` and `sysup`).
- [ ] **ifrit: environment secrets → 1Password** (migrate on ifrit). Pattern:
      - one template, e.g. `home/dot_local/sh/private_ifrit.secrets.zshenv.tmpl`
        (`private_` → 0600; the `*.zshenv` loader picks it up, and the
        existing `.local/sh/ifrit.*` ignore rule keeps it off other hosts);
      - each line `export FOO='{{ template "secret" (list .secrets "" "op://VAULT/ITEM/FIELD") }}'`,
        or iterate one item's fields (`onepassword "item"` → `.fields`);
      - add the target to the secrets block in `home/.chezmoiignore` so it's
        skipped, not failed, when `op` isn't signed in.
      - `secretRefs.sshConfig` is unused there (no private SSH hosts).

## Hyprland workspaces (shiva)

Named workspaces live in `home/dot_config/hypr/bindings.lua`.

- [ ] **Signal:** install `signal-desktop` (extra; Omarchy launches it on
      `SUPER+SHIFT+G`). Its comms rule is already in place. If it should be
      in `packages.yaml`, that needs a desktop+personal list (`linux_personal`
      also reaches the dadfi server).
- [ ] **Verify window classes** the first time each app opens (`hyprctl
      clients`): Obsidian (`obsidian` / `md.obsidian.Obsidian`), Discord web
      app (`chrome-discord.com__…`), Signal (`signal` / `Signal` /
      `signal-desktop`). Rules match those; fix the regex if one differs.

## Decisions parked

- [ ] **Docker access** stays on `sudo docker`. Options and tradeoffs: README
      "Docker".
- [ ] **herdr handoff on Omarchy:** shiva keeps Omarchy's packaged herdr (no
      `--handoff`, restart after `omarchy update`). Switch to the official
      installer only if that becomes a pain.
- [ ] **`sysup` name:** looking for something snarkier.
